from datetime import datetime

from fastapi import APIRouter, HTTPException
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from ..database import engine

router = APIRouter(tags=["health"])


@router.get("/health")
def health() -> dict[str, str]:
    waktu = datetime.now().astimezone().isoformat(timespec="seconds")
    try:
        with engine.connect() as connection:
            mysql_version = str(connection.execute(text("SELECT VERSION()")).scalar_one())
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=503,
            detail={
                "status": "degraded",
                "waktu_server": waktu,
                "database": "error",
                "detail": "API aktif, tetapi MySQL belum dapat dihubungi.",
            },
        ) from exc
    return {
        "status": "ok",
        "waktu_server": waktu,
        "database": "ok",
        "mysql_version": mysql_version,
    }
