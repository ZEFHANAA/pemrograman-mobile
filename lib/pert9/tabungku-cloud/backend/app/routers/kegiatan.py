from datetime import date
from typing import Literal

from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from fastapi.exceptions import RequestValidationError
from pydantic import ValidationError
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Kegiatan, Tipe
from ..schemas import KegiatanInput, KegiatanOut, KegiatanPatch

router = APIRouter(prefix="/kegiatan", tags=["kegiatan"])


def _find_or_404(db: Session, kegiatan_id: int) -> Kegiatan:
    row = db.get(Kegiatan, kegiatan_id)
    if row is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "Kegiatan tidak ditemukan")
    return row


@router.get("", response_model=list[KegiatanOut])
def list_kegiatan(
    response: Response,
    tanggal: date | None = None,
    tipe: Tipe | None = None,
    selesai: bool | None = None,
    urut: Literal["terbaru", "terlama"] = "terbaru",
    q: str | None = Query(None, description="Cari kata kunci di judul"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    """Daftar kegiatan dengan filter, pengurutan, pagination, dan header X-Total-Count."""
    stmt = select(Kegiatan)
    if tanggal is not None:
        stmt = stmt.where(Kegiatan.tanggal == tanggal)
    if tipe is not None:
        stmt = stmt.where(Kegiatan.tipe == tipe)
    if selesai is not None:
        stmt = stmt.where(Kegiatan.selesai == selesai)
    if q:
        stmt = stmt.where(Kegiatan.judul.contains(q))

    total = db.scalar(select(func.count()).select_from(stmt.subquery()))
    response.headers["X-Total-Count"] = str(total or 0)

    order_id = Kegiatan.id.desc() if urut == "terbaru" else Kegiatan.id.asc()
    stmt = stmt.order_by(Kegiatan.selesai, order_id).limit(limit).offset(offset)
    return db.scalars(stmt).all()


@router.get("/{kegiatan_id}", response_model=KegiatanOut)
def get_kegiatan(kegiatan_id: int, db: Session = Depends(get_db)):
    return _find_or_404(db, kegiatan_id)


@router.post("", response_model=KegiatanOut, status_code=status.HTTP_201_CREATED)
def create_kegiatan(data: KegiatanInput, db: Session = Depends(get_db)):
    row = Kegiatan(**data.model_dump())
    db.add(row)
    db.commit()
    db.refresh(row)
    return row


@router.put("/{kegiatan_id}", response_model=KegiatanOut)
def replace_kegiatan(kegiatan_id: int, data: KegiatanInput, db: Session = Depends(get_db)):
    row = _find_or_404(db, kegiatan_id)
    for col, val in data.model_dump().items():
        setattr(row, col, val)
    db.commit()
    db.refresh(row)
    return row


@router.patch("/{kegiatan_id}", response_model=KegiatanOut)
def patch_kegiatan(kegiatan_id: int, data: KegiatanPatch, db: Session = Depends(get_db)):
    """Ubah sebagian field dan validasi ulang aturan bisnis setelah digabung."""
    row = _find_or_404(db, kegiatan_id)
    merged = KegiatanOut.model_validate(row).model_dump()
    merged.update(data.model_dump(exclude_unset=True))
    try:
        validated = KegiatanInput.model_validate(merged)
    except ValidationError as exc:
        raise RequestValidationError(exc.errors(include_url=False, include_context=False)) from exc
    for col, val in validated.model_dump().items():
        setattr(row, col, val)
    db.commit()
    db.refresh(row)
    return row


@router.delete("/{kegiatan_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_kegiatan(kegiatan_id: int, db: Session = Depends(get_db)):
    db.delete(_find_or_404(db, kegiatan_id))
    db.commit()
