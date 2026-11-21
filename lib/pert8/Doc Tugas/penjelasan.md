# Laporan Praktikum dan Tugas Pertemuan 8 - TabungKu Cloud - Docker Compose, MySQL, dan FastAPI

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Pertemuan ini menyiapkan layanan MySQL, FastAPI, dan Adminer menggunakan Docker Compose, lalu menghubungkan aplikasi Flutter ke endpoint health check. Implementasi menguji ketersediaan API dan koneksi database; aplikasi belum menyimpan transaksi TabungKu ke MySQL dan belum memiliki autentikasi cloud.

## I. Pendahuluan dan tujuan

Aplikasi yang menggunakan layanan backend perlu membedakan dua kondisi: apakah API dapat dijangkau dan apakah API dapat mengakses database. Docker Compose membantu menjalankan beberapa layanan yang saling bergantung melalui konfigurasi yang dapat diulang.
Tujuan pertemuan adalah menjalankan MySQL, API, dan antarmuka administrasi sebagai layanan terpisah, memeriksa konektivitas melalui endpoint health check, serta menampilkan status tersebut dari Flutter. Fokus implementasi berada pada orkestrasi dan pemeriksaan koneksi.

- Menjalankan service dengan Docker Compose.
- Menggunakan health check untuk kesiapan MySQL.
- Memeriksa API dan query database secara terpisah.
- Mengonfigurasi URL API yang dapat dipakai emulator atau perangkat.

## II. Arsitektur layanan

Komposisi terdiri dari tiga service. MySQL 8.4 menyimpan database dan memakai volume bernama agar data tidak hanya hidup di filesystem sementara container. FastAPI berjalan pada port host 8000. Adminer berjalan pada port host 8081 untuk memeriksa database melalui browser.
Di jaringan antarcontainer, API dan Adminer mengakses service MySQL dengan nama service dan port internal 3306. Port host 3307 dipakai untuk akses MySQL dari komputer host. Port internal dan port host memiliki tujuan berbeda dan tidak boleh tertukar.
API menyediakan GET /health dan dokumentasi /docs. Endpoint health menjalankan SELECT VERSION() ke MySQL. Bila query berhasil, respons berisi status sehat, versi MySQL, dan waktu server. Bila database tidak tersedia, API mengembalikan HTTP 503. Health check Compose menahan service yang bergantung sampai MySQL siap.

- Flutter -> GET /health -> FastAPI:8000.
- FastAPI -> MySQL:3306 melalui jaringan Compose.
- Adminer:8081 -> MySQL:3306.
- Komputer host mengakses MySQL melalui port 3307.

## III. Konfigurasi dan backend

Konfigurasi kredensial dibaca dari environment Docker Compose. Berkas .env.example memberi contoh variabel yang dibutuhkan, sedangkan .env lokal perlu dibuat untuk menjalankan stack dan tidak dimasukkan ke Git. Password contoh tidak layak dipakai sebagai rahasia produksi.
Pemeriksaan health menguji dependency database dengan query sederhana, bukan hanya memastikan proses API aktif. Karena itu, hasil HTTP 503 membedakan API yang masih berjalan tetapi kehilangan koneksi database dari API yang sama sekali tidak dapat dijangkau.
Adminer membantu mengamati database secara langsung. Untuk koneksi dari Adminer, host adalah mysql dan port 3306. Nilai host localhost dari dalam container akan menunjuk ke container Adminer sendiri, sehingga bukan host yang tepat untuk MySQL.

- Salin .env.example menjadi .env dan ganti credential lokal.
- Bangun dan jalankan layanan dengan docker compose up -d --build.
- Periksa kesiapan MySQL sebelum menilai endpoint API.
- Gunakan Adminer dengan server mysql dan port 3306.

## IV. Integrasi Flutter

Halaman status Flutter menggunakan HealthService dan FutureBuilder untuk meminta /health dan menampilkan status API, status database, waktu server, serta latensi. Tombol pemeriksaan ulang mengirim permintaan baru. URL API dapat diubah dan disimpan melalui Shared Preferences.
Pada emulator Android, alamat 10.0.2.2 mengarah ke komputer host. Pada perangkat fisik, pengguna perlu memasukkan alamat IP komputer yang dapat dijangkau pada jaringan yang sama. Alamat localhost di perangkat menunjuk ke perangkat itu sendiri, bukan otomatis ke laptop.
Konfigurasi awal dapat diberikan melalui dart-define API_URL. Setelah itu, pilihan URL yang diubah dari aplikasi disimpan agar pemeriksaan berikutnya menggunakan alamat yang sama.

- Emulator: gunakan http://10.0.2.2:8000.
- Perangkat fisik: gunakan IP komputer pada jaringan yang sama.
- Periksa bahwa firewall mengizinkan akses ke port API.
- Jangan menaruh password database di source Flutter.

## V. Pemeriksaan manual

Skenario berikut menyatakan hasil yang diharapkan, bukan hasil uji yang telah dijalankan. Bukti status aktual perlu diambil dari stack yang benar-benar berjalan.

- API dan MySQL aktif: /health mengembalikan sukses dan aplikasi menampilkan kedua status terhubung.
- MySQL dihentikan: API masih dapat merespons tetapi health mengembalikan HTTP 503 dan UI menyatakan database tidak terhubung.
- API dihentikan atau URL keliru: Flutter menunjukkan kegagalan koneksi dan menyediakan aksi coba lagi.
- URL diganti: pilihan tersimpan setelah aplikasi ditutup dan dibuka kembali.
- Adminer: database dapat diperiksa melalui service mysql pada port internal 3306.

## VI. Ruang lingkup dan kesimpulan

Versi ini berfokus pada orkestrasi service dan health check. Endpoint untuk membuat, membaca, mengubah, atau menghapus transaksi TabungKu di MySQL belum tersedia. Autentikasi, sinkronisasi transaksi dari SQLite, dan kebijakan deployment produksi juga belum menjadi bagian implementasi yang dijelaskan.
Docker Compose menyediakan lingkungan lokal yang konsisten. FastAPI memeriksa layanan dan Flutter menampilkan status koneksi.
