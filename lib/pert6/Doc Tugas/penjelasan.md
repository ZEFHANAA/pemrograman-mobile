# Laporan Praktikum dan Tugas Pertemuan 6 - Tema, Routing, dan Animasi

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Pertemuan ini menerapkan tema global, pengaturan mode terang atau gelap, navigasi ke detail, serta animasi pada katalog Flutter. Pengaturan tema dan warna aksen dikelola oleh AppThemeController dan disimpan melalui preferensi. Tugas menggunakan grid katalog, Hero, dan AnimatedContainer untuk memberi kesinambungan visual dari daftar ke detail.

## I. Pendahuluan dan tujuan

Tema global membantu menjaga konsistensi warna dan tipografi di seluruh halaman. Navigasi menghubungkan layar yang berbeda, sedangkan animasi dapat menandai perubahan konteks agar perpindahan terasa lebih mudah dipahami.
Tujuan latihan adalah mengatur ThemeData, menyediakan mode terang dan gelap, mempertahankan pilihan pengguna, menggunakan route untuk navigasi, serta menampilkan elemen katalog dengan transisi menuju detail.

- Menyatukan gaya aplikasi dalam satu konfigurasi tema.
- Mempertahankan preferensi tema dan warna aksen.
- Menghubungkan item katalog dengan detail melalui navigasi dan animasi.

## II. Landasan konsep

ThemeData menyediakan warna dan gaya untuk komponen Material. ThemeMode menentukan apakah aplikasi mengikuti tema terang, gelap, atau sistem. Controller bertindak sebagai sumber state preferensi sehingga perubahan dapat diterapkan ke root aplikasi.
Named route memberi nama pada tujuan navigasi, sedangkan Navigator mengelola tumpukan halaman. Hero menghubungkan elemen visual yang berbagi tag antara dua route. AnimatedContainer menganimasikan perubahan properti seperti ukuran, warna, atau dekorasi selama durasi yang ditetapkan.

- Warna aksen harus tetap memiliki kontras yang terbaca.
- Tag Hero harus unik untuk tiap item yang berpindah.
- Preferensi disimpan terpisah dari definisi tampilan halaman.

## III. Pelaksanaan praktikum

Praktikum6Page menyediakan akses ke halaman-halaman latihan dan pengaturan tema. AppThemeController memuat pilihan tema dan seed color dari Shared Preferences. Ketika pengguna mengganti mode atau warna, controller memperbarui state dan root MaterialApp menggunakan ThemeData terbaru.
Penyimpanan preferensi membuat pilihan tidak kembali ke default pada setiap pembukaan aplikasi. Data tetap bersifat preferensi lokal; sinkronisasi antarperangkat tidak menjadi bagian dari implementasi.

- Muat preferensi ketika controller diinisialisasi.
- Perbarui tampilan setelah pengguna memilih mode atau warna.
- Simpan pilihan yang sama ke Shared Preferences.
- Pastikan seluruh halaman merespons perubahan tema global.

## IV. Pembahasan tugas

Tugas6Page menyajikan katalog Flutter, Dart, Material Design, dan Navigator dalam grid. Pemilihan item membuka detail yang menampilkan informasi lebih lengkap. Hero menghubungkan gambar atau elemen utama daftar ke detail, sementara AnimatedContainer memberi transisi pada perubahan visual di halaman detail.
Katalog menggunakan data yang sudah disediakan di aplikasi. Tujuan utamanya adalah menunjukkan pola grid dan navigasi, bukan memuat konten dari server. Desain responsif perlu mempertimbangkan jumlah kolom dan panjang teks agar kartu tetap mudah dibaca.

- Pilih salah satu kartu pada grid.
- Pastikan halaman detail cocok dengan item yang dipilih.
- Amati animasi Hero dan perubahan AnimatedContainer.
- Kembali ke grid dan pastikan katalog tetap dapat dipakai.

## V. Pemeriksaan hasil

Skenario berikut merupakan panduan manual dan belum menjadi hasil pengujian yang tercatat.

- Mode terang dan gelap mengubah warna halaman secara konsisten.
- Pilihan tema dan warna bertahan sesudah aplikasi dibuka ulang.
- Setiap item membuka konten detail yang benar.
- Transisi tidak gagal ketika tag Hero berbeda atau item tidak tersedia.
- Grid tetap terbaca pada ukuran layar kecil.

## VI. Kesimpulan

Controller tema memusatkan preferensi visual, routing menyusun hubungan halaman, dan animasi memberi umpan balik pada perpindahan konteks. Implementasi katalog menggabungkan ketiganya dalam alur daftar ke detail yang dapat dipakai sebagai pola pada aplikasi lebih besar.

- Berkas utama: lib/app_theme_controller.dart, lib/pert6/praktikum/, dan lib/pert6/tugas/tugas6_catalog_page.dart.
- Dokumentasi implementasi: lib/pert6/Doc Tugas/laporan_terkini.md.
