from datetime import datetime

from fastapi import FastAPI, HTTPException
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError

from .database import engine


app = FastAPI(title="TabungKu API", version="0.1.0")


@app.get("/")
def beranda() -> dict[str, str]:
    return {"pesan": "Selamat datang di TabungKu API. Dokumentasi tersedia di /docs."}


@app.get("/health")
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
                "detail": "API hidup, tetapi MySQL belum dapat dihubungi.",
            },
        ) from exc
    return {
        "status": "ok",
        "waktu_server": waktu,
        "database": "ok",
        "mysql_version": mysql_version,
    }
