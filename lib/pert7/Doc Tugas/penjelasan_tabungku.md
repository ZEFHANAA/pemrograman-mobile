# Laporan Praktikum dan Tugas Pertemuan 7 — TabungKu

**Mahasiswa:** Zefhana Ananda | **NIM:** 20240801047 | **Mata Kuliah:** Pemrograman Mobile (CR002)

## 1. Tujuan

TabungKu menggabungkan materi Flutter, form dan validasi, state, SQLite, Shared Preferences, tema, named routes, NavigationBar, dan animasi. Setiap kegiatan dapat dicatat sebagai kegiatan biasa, pemasukan, atau pengeluaran.

## 2. Aturan bisnis

- Kegiatan menyimpan judul, tanggal, status selesai, jenis keuangan, nominal, dan kategori.
- Nominal pemasukan/pengeluaran harus berupa bilangan Rupiah lebih dari nol.
- Kategori pengeluaran: Makan, Transport, Belajar, Hiburan, dan Lainnya.
- Tabungan harian adalah total pemasukan dikurangi total pengeluaran; semua kegiatan tanggal tersebut dihitung, termasuk yang belum selesai.
- Target awal tabungan harian Rp20.000 dan dapat diubah.

## 3. Implementasi

- **Model:** `Kegiatan` menyimpan tipe, tanggal, status, nominal, dan kategori.
- **Penyimpanan:** `TabungKuDatabase` menjalankan CRUD SQLite, ringkasan harian, pengeluaran per kategori, rentang tujuh hari, dan ringkasan bulanan.
- **Pengaturan:** `TabungKuSettings` menyimpan target tabungan, mode gelap, dan warna tema.
- **Navigasi:** Tab Hari Ini, Laporan, dan Pengaturan dibuka melalui `TabungKuShellPage`; form memakai named route.
- **Form:** `KegiatanFormPage` memvalidasi judul, nominal, tanggal, jenis kegiatan, dan kategori.

## 4. Fitur aplikasi

1. Beranda menampilkan jumlah kegiatan selesai, total pemasukan/pengeluaran, nilai tabungan, dan progres target beranimasi.
2. Pengguna dapat menambah, mengubah, menandai selesai, mencari, memfilter, dan menghapus kegiatan dengan konfirmasi.
3. Laporan menampilkan ringkasan tanggal terpilih, pengeluaran per kategori, tujuh hari terakhir, dan ringkasan bulanan.
4. Pengaturan menyimpan target tabungan, tema gelap, dan warna tema.
5. Perubahan data diteruskan ke tab yang sedang terbuka melalui `ValueNotifier`.

## 5. Pengujian manual

Sebelum pengumpulan, uji tambah/ubah/hapus, validasi nominal nol/kosong, kegiatan tanpa uang, perhitungan tabungan positif dan negatif, filter, laporan kategori, persistensi data setelah aplikasi dibuka ulang, serta persistensi pengaturan. **Hasil pengujian belum dicatat dalam dokumen ini; isi berdasarkan pengujian aktual pada perangkat.**

## 6. Batasan

Pertemuan 7 menyimpan kegiatan pada SQLite lokal perangkat. Sinkronisasi ke server tidak termasuk versi ini; pemeriksaan API dan MySQL diperkenalkan pada Pertemuan 8.
