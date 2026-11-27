# TabungKu Cloud — Pertemuan 9

Backend REST API CRUD dan Laporan untuk TabungKu menggunakan FastAPI, SQLAlchemy 2, Alembic, dan MySQL 8.4.

## Endpoint Utama

- `GET /health` — Pemeriksaan API dan koneksi MySQL
- `GET /kegiatan` — Daftar kegiatan (filter `tanggal`, `tipe`, `selesai`, `q`, `urut=terbaru|terlama`, pagination `limit`/`offset`, header `X-Total-Count`)
- `GET /kegiatan/{id}` — Detail satu kegiatan
- `POST /kegiatan` — Tambah kegiatan baru (`201 Created`)
- `PUT /kegiatan/{id}` — Ganti seluruh field kegiatan
- `PATCH /kegiatan/{id}` — Ubah sebagian field dan validasi ulang aturan bisnis
- `DELETE /kegiatan/{id}` — Hapus kegiatan (`204 No Content`)
- `GET /laporan/harian?tanggal=YYYY-MM-DD` — Ringkasan harian & pengeluaran per kategori (dihitung di SQL)
- `GET /laporan/rentang?mulai=YYYY-MM-DD&sampai=YYYY-MM-DD` — Ringkasan rentang tanggal (maksimal 31 hari)

## Menjalankan dengan Docker Compose

```bash
cd lib/pert9/tabungku-cloud
cp .env.example .env
docker compose up -d --build
docker compose exec api alembic current
```

Dokumentasi Swagger UI tersedia di `http://localhost:8000/docs` dan Adminer di `http://localhost:8081`.
