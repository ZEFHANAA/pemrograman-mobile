# Pemrograman Mobile (CR002)

Repository untuk tugas, praktikum, dan project akhir mata kuliah Pemrograman Mobile.

### Data Mahasiswa
- **Nama:** Zefhana Ananda
- **NIM:** 20240801047
- **Dosen Pengampu:** Jefry Sunupurwa Asri, S.Kom., M.Kom.
- **Program Studi:** Teknik Informatika
- **Fakultas:** Fakultas Ilmu Komputer, Universitas Esa Unggul

---

### Daftar Pertemuan

#### Pertemuan 1 - Konsep Dasar Android & Tools
- **Praktikum:** Hello Android Studio
- **Tugas:** Kartu Profil & Arsitektur Android
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_1.pdf](lib/pert1/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_1.pdf)

#### Pertemuan 2 - Pengenalan Flutter & Dart
- **Praktikum:** Hello World Flutter (`hello_app`)
- **Tugas:** Profil Mahasiswa & Counter Reaktif (`StatefulWidget`)
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_2.pdf](lib/pert2/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_2.pdf)

#### Pertemuan 3 - Model Layout Android & Flutter
- **Praktikum:** LinearLayout (Form Pesan) & RelativeLayout (Form Registrasi)
- **Tugas:** Form Pendaftaran Mahasiswa dengan Validasi Input
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_3.pdf](lib/pert3/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_3.pdf)

#### Pertemuan 4 - Pemodelan Activity & Intent
- **Praktikum:** Explicit Intent (Kirim Pesan Antar Activity)
- **Tugas:** Implicit Intent (Action Browser, Maps, & Share)
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_4.pdf](lib/pert4/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_4.pdf)

#### Pertemuan 5 - User Interface & User Experience (Droid Cafe)
- **Praktikum:** Droid Cafe dengan Hidangan Interaktif (Donut, Ice Cream Sandwiches, FroYo) & Overflow Menu
- **Tugas:** Order Activity dengan Form Pelanggan & Radio Button Metode Pengiriman
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_5.pdf](lib/pert5/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_5.pdf)

#### Pertemuan 6 - Material Design, Theme, & Scorekeeper
- **Praktikum:** Scorekeeper App (Team 1 & Team 2, Plus/Minus Score, & Day/Night Mode Switch)
- **Tugas:** Material Me Sports Card Catalog & Navigasi ke Papan Skor
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_6.pdf](lib/pert6/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_6.pdf)

#### Pertemuan 7 - Mini Proyek Terpadu: TabungKu
- **Praktikum:** TabungKu dengan SQLite, Provider, navigasi, tema, dan laporan harian
- **Tugas:** Mini proyek TabungKu dengan aktivitas, keuangan, laporan, dan pengaturan
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_7.pdf](lib/pert7/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_7.pdf)

#### Pertemuan 8 - TabungKu Cloud: Docker, MySQL, dan FastAPI
- **Praktikum:** FastAPI, MySQL, Docker Compose, dan pemeriksaan status server
- **Tugas:** Adminer, endpoint health dengan cek database, dan konfigurasi API
- **Backend:** [lib/pert8/tabungku-cloud](lib/pert8/tabungku-cloud)
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_8.pdf](lib/pert8/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_8.pdf)

#### Pertemuan 9 - REST API CRUD & Endpoint Laporan SQL
- **Praktikum:** FastAPI, SQLAlchemy 2, Alembic, Pydantic CRUD `/kegiatan` & `AktivitasCloudApi`
- **Tugas:** Endpoint `/laporan/harian` & `/laporan/rentang` di SQL, `LaporanCloudApi`, & unit test `MockClient`
- **Backend:** [lib/pert9/tabungku-cloud](lib/pert9/tabungku-cloud)
- **Laporan:** [Laporan_Praktikum_dan_Tugas_Pertemuan_9.pdf](lib/pert9/Doc%20Tugas/Laporan_Praktikum_dan_Tugas_Pertemuan_9.pdf)

---
## Tugas Tambahan - TabungKu Layout
- **Lokasi:** [lib/tabungku_layout](lib/tabungku_layout)
- **Link:** https://github.com/ZEFHANAA/pemrograman-mobile/tree/main/lib/tabungku_layout
- **Laporan:** [lib/tabungku_layout/README.md](lib/tabungku_layout/README.md)

---
## Project Akhir - SPLW Mobile

Prototype **Sistem Pencarian dan Penyimpanan Lokasi Wisata (SPLW) Mobile** berbasis Flutter.

- **Dokumen BRD/PRD:** [lib/project/README.md](lib/project/README.md)
- **Prototype & akun demo:** [lib/project/prototype/README.md](lib/project/prototype/README.md)
- **Screenshot:** [lib/project/prototype/screenshots](lib/project/prototype/screenshots)
- **Prototype Figma:** [SPLW Mobile — UI/UX Design](https://www.figma.com/design/aVvksZdQLvnRKnkHQ4DP51/SPLW-Mobile-%E2%80%94-UI-UX-Design?node-id=82-1804)

```bash
flutter pub get
flutter run -d chrome -t lib/project/prototype/main.dart
```

Prototype memakai data mock in-memory; backend, peta live, GPS perangkat, dan ekspor `.xlsx` belum diimplementasikan. Status lengkap dan batasan dijelaskan di README prototype.

---

### Cara Menjalankan Tugas Mingguan
```bash
flutter pub get
flutter run
```
