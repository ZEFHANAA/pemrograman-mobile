from fastapi import FastAPI

from .routers import health, kegiatan, laporan

app = FastAPI(title="TabungKu Cloud API", version="0.2.0")


@app.get("/")
def beranda() -> dict[str, str]:
    return {"pesan": "TabungKu Cloud API aktif. Dokumentasi tersedia di /docs."}


app.include_router(health.router)
app.include_router(kegiatan.router)
app.include_router(laporan.router)
