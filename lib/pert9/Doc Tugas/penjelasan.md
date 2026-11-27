# Laporan Praktikum dan Tugas Pertemuan 9 - REST API CRUD dengan FastAPI, SQLAlchemy 2, dan Alembic

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)

## Ringkasan

Pertemuan 9 membangun backend REST API CRUD penuh untuk sumber daya `/kegiatan` menggunakan FastAPI, ORM SQLAlchemy 2, migrasi Alembic (`0001_buat_tabel_kegiatan.py`), dan validasi aturan bisnis Pydantic, ditambah endpoint `/laporan/harian` serta `/laporan/rentang` yang dihitung langsung di SQL. Di sisi Flutter, dibuat model JSON, `ApiResponseException`, `AktivitasCloudApi`, `LaporanCloudApi`, serta halaman eksplorasi UI beserta unit test `MockClient`.

## I. Pendahuluan dan tujuan

- Merancang endpoint REST (`/kegiatan` dan `/laporan`) dengan method HTTP dan kode status yang tepat (`201`, `204`, `400`, `404`, `422`).
- Memetakan tabel MySQL ke kelas Python menggunakan ORM SQLAlchemy 2 (`Mapped[...]`).
- Mengelola perubahan skema database secara terstruktur menggunakan Alembic.
- Memvalidasi aturan bisnis TabungKu (nominal > 0 dan kategori pengeluaran wajib) dengan Pydantic.
- Menyediakan lapisan layanan API Flutter yang dapat diuji secara terisolasi menggunakan `MockClient`.

## II. Backend FastAPI, SQLAlchemy 2, dan Alembic

- **Model (`backend/app/models.py`)**: Kelas `Kegiatan` dengan kolom `id`, `judul`, `tanggal` (berindeks), `selesai`, `tipe` (`ENUM`), `nominal`, `kategori`, `created_at`, dan `updated_at`.
- **Migrasi (`backend/alembic/versions/0001_buat_tabel_kegiatan.py`)**: Membuat tabel `kegiatan` dan indeks `ix_kegiatan_tanggal`, dijalankan otomatis melalui `start.sh` (`alembic upgrade head`).
- **Validasi (`backend/app/schemas.py`)**: `KegiatanInput` memastikan `judul` tidak kosong setelah `strip()`, `nominal` dipaksa `0` untuk tipe `tanpa`, dan `kategori` harus berasal dari `["Makan", "Transport", "Belajar", "Hiburan", "Lainnya"]` untuk pengeluaran.

## III. Endpoint CRUD dan Latihan Mandiri

- `GET /kegiatan`: Mendukung filter `tanggal`, `tipe`, `selesai` (Latihan Mandiri 1), pencarian `q`, pengurutan `urut=terbaru|terlama` (Latihan Mandiri 2), pagination `limit`/`offset`, serta header `X-Total-Count`.
- `POST /kegiatan`: Mengembalikan `201 Created`.
- `PUT /kegiatan/{id}` & `PATCH /kegiatan/{id}`: Pada `PATCH`, field yang dikirim digabung dengan data lama lalu divalidasi ulang melalui `KegiatanInput` agar aturan bisnis tidak terlewati.
- `DELETE /kegiatan/{id}`: Mengembalikan `204 No Content`.

## IV. Endpoint Laporan SQL dan Lapisan Flutter

- `GET /laporan/harian?tanggal=YYYY-MM-DD`: Menghitung `jumlah_kegiatan`, `selesai`, `pemasukan`, `pengeluaran`, `tabungan`, dan `per_kategori` langsung di SQL (`COUNT`, `SUM(CASE WHEN ...)`, `COALESCE`, `GROUP BY`).
- `GET /laporan/rentang?mulai=...&sampai=...`: Satu query `GROUP BY tanggal`; hari tanpa transaksi diisi `0`. Rentang terbalik atau lebih dari 31 hari ditolak dengan HTTP `400`.
- **Flutter (`lib/pert9/`)**: `AktivitasCloud`, `RingkasanCloud`, `LaporanHarianCloud`, `ApiResponseException`, `AktivitasCloudApi`, `LaporanCloudApi`, serta halaman `Praktikum9Page` dan `Tugas9Page`.

## V.B. Bukti Swagger UI (Hasil Aktual)

Tabel uji Bagian F dijalankan langsung pada Swagger UI (`http://localhost:8000/docs`) setelah database di-reset dan diisi dengan empat data skenario Pertemuan 7. Bukti tangkapan layar disimpan di folder `lib/pert9/Doc Tugas/images/`.

- `pert9_swagger_kegiatan.png`: `GET /kegiatan?tanggal=2026-10-05&limit=1` mengembalikan satu baris dan header `X-Total-Count: 4`.
- `pert9_swagger_laporan_harian.png`: `GET /laporan/harian?tanggal=2026-10-05` mengembalikan `jumlah_kegiatan=4`, `selesai=2`, `pemasukan=50000`, `pengeluaran=25000`, `tabungan=25000`, serta per kategori Makan 15000 dan Transport 10000.
- `pert9_swagger_laporan_rentang.png`: `GET /laporan/rentang?mulai=2026-10-04&sampai=2026-10-05` mengembalikan dua hari; hari tanpa transaksi bernilai 0, dan hari dengan data bernilai sesuai agregat SQL.

## V. Pertanyaan Refleksi (Ringkas)

1. `POST` membalas `201 Created` untuk menandakan resource baru berhasil dibuat, sedangkan `DELETE` membalas `204 No Content` karena operasi berhasil tanpa badan respons.
2. Mengubah skema langsung lewat Adminer membuat riwayat `alembic_version` tidak sinkron dengan database sehingga migrasi berikutnya berisiko gagal.
3. `PATCH` wajib memvalidasi ulang data gabungan agar perubahan parsial (misalnya mengubah `nominal` menjadi `0` pada pengeluaran) tetap ditolak oleh aturan bisnis.
4. Pagination membatasi ukuran payload agar hemat memori/kuota mobile, sedangkan `X-Total-Count` memberi tahu jumlah seluruh data tanpa mengunduh semuanya.
5. Injeksi `http.Client` pada konstruktor memungkinkan pengujian unit cepat dan deterministik menggunakan `MockClient` tanpa menjalankan server.
