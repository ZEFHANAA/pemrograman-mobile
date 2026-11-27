from datetime import date, timedelta

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import case, func, select
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Kegiatan, Tipe
from ..schemas import LaporanHarian, RingkasanHari, TotalKategori

router = APIRouter(prefix="/laporan", tags=["laporan"])

MAX_RANGE_DAYS = 31


def _summarize_by_date(db: Session, start_date: date, end_date: date) -> list[RingkasanHari]:
    """Agregasi SQL per tanggal, lalu mengisi hari tanpa transaksi dengan nilai 0."""

    def sum_if(condition, value):
        return func.coalesce(func.sum(case((condition, value), else_=0)), 0)

    stmt = (
        select(
            Kegiatan.tanggal,
            func.count().label("jumlah"),
            sum_if(Kegiatan.selesai.is_(True), 1).label("selesai"),
            sum_if(Kegiatan.tipe == Tipe.pemasukan, Kegiatan.nominal).label("masuk"),
            sum_if(Kegiatan.tipe == Tipe.pengeluaran, Kegiatan.nominal).label("keluar"),
        )
        .where(Kegiatan.tanggal.between(start_date, end_date))
        .group_by(Kegiatan.tanggal)
    )
    by_date = {row.tanggal: row for row in db.execute(stmt)}

    results: list[RingkasanHari] = []
    cursor = start_date
    while cursor <= end_date:
        row = by_date.get(cursor)
        masuk = int(row.masuk) if row else 0
        keluar = int(row.keluar) if row else 0
        results.append(
            RingkasanHari(
                tanggal=cursor,
                jumlah_kegiatan=row.jumlah if row else 0,
                selesai=int(row.selesai) if row else 0,
                pemasukan=masuk,
                pengeluaran=keluar,
                tabungan=masuk - keluar,
            )
        )
        cursor += timedelta(days=1)
    return results


@router.get("/harian", response_model=LaporanHarian)
def daily_report(tanggal: date, db: Session = Depends(get_db)):
    """Ringkasan transaksi satu hari beserta rincian pengeluaran per kategori."""
    summary = _summarize_by_date(db, tanggal, tanggal)[0]

    stmt = (
        select(Kegiatan.kategori, func.sum(Kegiatan.nominal).label("total"))
        .where(Kegiatan.tanggal == tanggal, Kegiatan.tipe == Tipe.pengeluaran)
        .group_by(Kegiatan.kategori)
        .order_by(func.sum(Kegiatan.nominal).desc())
    )
    per_kategori = [
        TotalKategori(kategori=row.kategori, total=int(row.total)) for row in db.execute(stmt)
    ]
    return LaporanHarian(**summary.model_dump(), per_kategori=per_kategori)


@router.get("/rentang", response_model=list[RingkasanHari])
def range_report(mulai: date, sampai: date, db: Session = Depends(get_db)):
    """Ringkasan harian dari `mulai` hingga `sampai` (maksimal 31 hari)."""
    if sampai < mulai:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST, "Tanggal sampai harus setelah tanggal mulai"
        )
    if (sampai - mulai).days + 1 > MAX_RANGE_DAYS:
        raise HTTPException(
            status.HTTP_400_BAD_REQUEST, f"Rentang maksimal {MAX_RANGE_DAYS} hari"
        )
    return _summarize_by_date(db, mulai, sampai)
