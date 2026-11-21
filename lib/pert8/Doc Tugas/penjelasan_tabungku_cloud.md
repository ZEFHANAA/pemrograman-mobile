# Laporan Pertemuan 8 — TabungKu Cloud

**Nama:** Zefhana Ananda | **NIM:** 20240801047 | **Mata kuliah:** Pemrograman Mobile (CR002)

## Tujuan

Pertemuan ini menghubungkan aplikasi Flutter dengan layanan backend yang dijalankan menggunakan Docker Compose. Backend menggunakan FastAPI, database MySQL, serta Adminer untuk memeriksa isi database. Aplikasi Flutter memeriksa ketersediaan API dan koneksi databasenya melalui endpoint health check.

## Arsitektur

```text
Flutter -- GET /health --> FastAPI (port 8000)
                              -- SQL --> MySQL 8.4 (container port 3306)
Adminer (host port 8081) -----------------------> MySQL
Host komputer memublikasikan MySQL pada port 3307.
```

Docker Compose mengatur tiga layanan: `mysql`, `api`, dan `adminer`. MySQL memakai volume bernama agar datanya tetap tersedia setelah container dihentikan. Layanan API dan Adminer menunggu status health check MySQL sebelum mulai.

## Implementasi backend

- FastAPI menyediakan `GET /health` dan dokumentasi interaktif pada `/docs`.
- Endpoint mencoba menjalankan `SELECT VERSION()` ke MySQL.
- Jika database terhubung, API mengembalikan status sehat beserta versi MySQL dan waktu server.
- Jika database belum tersedia, API mengembalikan HTTP 503 agar gangguan database dapat dibedakan dari API yang mati.
- Kredensial dibaca dari environment Docker Compose. Berkas `.env` lokal tidak dimasukkan ke Git; nilai awal tersedia pada `.env.example`.

## Implementasi Flutter

Halaman status menggunakan `FutureBuilder` dan `HealthService` untuk menampilkan status API, status MySQL, waktu server, dan latensi. Pengguna dapat mencoba pemeriksaan ulang serta mengubah alamat API. Alamat yang dipilih disimpan dengan Shared Preferences.

Pada emulator Android, `10.0.2.2` mengarah ke host komputer. Untuk perangkat fisik, alamat API perlu diisi dengan IP komputer pada jaringan yang sama. Nilai awal dapat ditetapkan dengan `--dart-define=API_URL=http://IP-KOMPUTER:8000`.

## Menjalankan aplikasi

1. Masuk ke folder `tabungku-cloud`.
2. Salin `.env.example` menjadi `.env` dan ganti password contoh dengan password lokal.
3. Jalankan `docker compose up -d --build`.
4. Pastikan layanan MySQL siap, lalu buka `http://localhost:8000/health`, `http://localhost:8000/docs`, dan `http://localhost:8081`.
5. Jalankan aplikasi Flutter dan buka menu Pertemuan 8. Untuk perangkat selain emulator Android, simpan alamat API komputer pada halaman status.

Di Adminer gunakan server `mysql`, port `3306`, dan kredensial dari `.env`. Port `3307` adalah port MySQL yang dipublikasikan ke host komputer; komunikasi antarkontainer menggunakan port `3306`.

## Pemeriksaan manual

| Kondisi | Hasil yang diharapkan |
| --- | --- |
| API dan MySQL hidup | Status API dan database menunjukkan terhubung. |
| MySQL dihentikan | API masih dapat dijangkau, tetapi status database menunjukkan tidak terhubung. |
| API dihentikan atau alamat salah | Flutter menampilkan kegagalan koneksi dan menyediakan tombol pemeriksaan ulang. |

Perintah untuk menghentikan MySQL saat pemeriksaan adalah `docker compose stop mysql`. Setelah selesai, hidupkan kembali dengan `docker compose start mysql`.

## Batasan implementasi

Fokus implementasi ini adalah orkestrasi layanan dan pemeriksaan konektivitas. Endpoint CRUD cloud, autentikasi, dan sinkronisasi data TabungKu ke MySQL belum dibuat. Laporan ini menjelaskan implementasi saat ini dan tidak mengklaim fitur-fitur tersebut sudah tersedia.

## Kesimpulan

Docker Compose menjalankan MySQL, FastAPI, dan Adminer sebagai layanan yang saling terhubung. Flutter dapat membedakan kondisi API dan database melalui health check, memberi umpan balik koneksi, serta menyimpan alamat backend yang dipakai.
