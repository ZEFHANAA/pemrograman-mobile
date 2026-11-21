# TabungKu Cloud — Pertemuan 8

Kerangka ini menjalankan Flutter, FastAPI, MySQL 8.4, dan Adminer. P8 hanya menyediakan health check; endpoint CRUD TabungKu dikembangkan pada pertemuan berikutnya.

## Menjalankan backend

1. Salin `.env.example` menjadi `.env` dan ubah kedua password.
2. Jalankan `docker compose up -d --build` dari folder ini (`lib/pert8/tabungku-cloud`).
3. Periksa `docker compose ps`. Tunggu sampai `mysql` berstatus `healthy`.
4. Buka `http://localhost:8000/docs`, `http://localhost:8000/health`, dan `http://localhost:8081`.

Di Adminer, gunakan server `mysql`, database `tabungku`, dan kredensial dari `.env`.

## Menjalankan Flutter

Jalankan aplikasi utama dari folder proyek dengan emulator Android. URL bawaan adalah `http://10.0.2.2:8000`. Untuk HP fisik, jalankan Flutter dengan `--dart-define=API_URL=http://IP-LAPTOP:8000`, dan pastikan kedua perangkat berada pada Wi-Fi yang sama.

Halaman Pengaturan TabungKu memiliki tautan ke Status Server. Halaman tersebut membedakan API aktif dari database yang tidak tersedia dan menyediakan tombol periksa ulang.

## Kode Flutter

Kode Flutter Pertemuan 8 berada di `lib/pert8` dan dijalankan dari aplikasi utama PEMMOB. Backend dan Docker berada di folder ini.

## Perintah Docker

- `docker compose logs -f api` melihat log backend.
- `docker compose stop mysql` menguji kondisi API aktif/database mati.
- `docker compose up -d mysql` menyalakan database kembali.
- `docker compose down` menghentikan layanan; volume data tetap tersimpan.
- Jangan membagikan atau meng-commit berkas `.env`.
