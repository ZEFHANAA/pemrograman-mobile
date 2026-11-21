# Laporan Praktikum dan Tugas Pertemuan 7 - TabungKu - Kegiatan Harian dan Ringkasan Keuangan

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

TabungKu menggabungkan daftar kegiatan harian dengan pencatatan pemasukan dan pengeluaran. Aplikasi menyimpan kegiatan pada SQLite, menghitung ringkasan dan target tabungan, serta menyimpan preferensi tema dan target. Laporan membedakan perilaku yang memang diterapkan dari kemampuan cloud yang belum termasuk pada tahap ini.

## I. Pendahuluan dan tujuan

Aplikasi mini proyek ini menggabungkan beberapa materi sebelumnya menjadi satu alur: model data, form, validasi, penyimpanan lokal, preferensi, navigasi, filter, laporan, dan animasi. TabungKu membantu pengguna mencatat kegiatan beserta dampak keuangannya pada hari tertentu.
Tujuan utamanya adalah membangun aplikasi yang tetap konsisten ketika data bertambah atau berubah. Aturan perhitungan harus jelas agar nilai pemasukan, pengeluaran, tabungan harian, dan progres target dapat dijelaskan serta diperiksa.

- Mencatat kegiatan biasa, pemasukan, atau pengeluaran.
- Mengelola siklus tambah, baca, ubah, hapus, dan status selesai.
- Membentuk ringkasan harian dan laporan dari data lokal.
- Menjaga preferensi target dan tema setelah aplikasi dimulai ulang.

## II. Model data dan aturan bisnis

Setiap Kegiatan menyimpan judul, tanggal, status selesai, tipe keuangan, nominal, dan kategori yang relevan. Tipe kegiatan menentukan bagaimana nominal diperlakukan: kegiatan biasa tidak menambah pemasukan atau pengeluaran, pemasukan menambah saldo, dan pengeluaran mengurangi saldo.
Nominal untuk pemasukan atau pengeluaran perlu berupa bilangan Rupiah yang lebih besar dari nol. Pengeluaran dikelompokkan ke kategori Makan, Transport, Belajar, Hiburan, dan Lainnya. Target awal tabungan harian adalah Rp20.000 dan dapat diubah melalui pengaturan.
Tabungan harian dihitung sebagai total pemasukan dikurangi total pengeluaran pada tanggal yang dipilih. Sesuai aturan implementasi, seluruh entri pada tanggal tersebut ikut dihitung walaupun status kegiatan belum selesai. Status selesai mengukur penyelesaian aktivitas, bukan apakah transaksi finansialnya sudah direkam.

- Saldo positif berarti pemasukan hari itu lebih besar daripada pengeluaran.
- Saldo negatif berarti pengeluaran melebihi pemasukan.
- Kegiatan tanpa uang tidak memengaruhi saldo.

## III. Arsitektur dan penyimpanan

TabungKuShellPage menjadi kerangka navigasi dengan tiga tab: Hari Ini, Laporan, dan Pengaturan. Halaman form dibuka melalui named route. Perubahan data diteruskan ke bagian yang aktif menggunakan ValueNotifier sehingga ringkasan dapat dimuat kembali setelah operasi database selesai.
TabungKuDatabase menggunakan SQLite untuk CRUD kegiatan dan query agregasi. Query laporan mencakup ringkasan harian, pengeluaran per kategori, rentang tujuh hari, dan ringkasan bulanan. TabungKuSettings menyimpan target, mode gelap, serta warna tema melalui preferensi lokal.

- SQLite: data kegiatan dan laporan terstruktur.
- Shared Preferences: target tabungan dan pilihan tampilan.
- ValueNotifier: pemberitahuan perubahan di antara halaman aplikasi.
- Named route: navigasi ke form tambah atau ubah kegiatan.

## IV. Fitur dan alur pengguna

Beranda menampilkan jumlah kegiatan yang selesai, total pemasukan dan pengeluaran, nilai tabungan, serta progres target dengan animasi. Pengguna dapat menambah, mengubah, mencari, memfilter, menandai selesai, dan menghapus kegiatan; penghapusan meminta konfirmasi agar tidak terjadi tindakan tanpa sengaja.
Laporan menggunakan tanggal yang dipilih untuk menghitung ringkasan. Pengeluaran dapat dipilah menurut kategori, dibandingkan untuk tujuh hari terakhir, dan dilihat dalam ringkasan bulanan. Pengaturan memberi kontrol target dan tema tanpa mengubah struktur transaksi.
Alur perubahan yang penting adalah form memvalidasi masukan, database menyimpan perubahan, lalu notifier memberi tahu UI untuk membaca ringkasan baru. Dengan urutan ini, angka dashboard tidak seharusnya hanya berubah lokal sementara data di database berbeda.

- Tentukan tanggal dan tipe kegiatan.
- Masukkan nominal dan kategori hanya bila jenisnya finansial.
- Simpan perubahan ke SQLite.
- Muat ulang daftar serta ringkasan pada tab yang relevan.

## V. Skenario pemeriksaan

Daftar berikut adalah rencana verifikasi manual. Tidak ada hasil perangkat yang diklaim dalam dokumen ini. Catat nilai aktual saat menjalankan aplikasi sebelum menyerahkan bukti praktikum.

- Validasi: nominal kosong, nol, negatif, dan teks tidak valid harus ditolak untuk transaksi finansial.
- Perhitungan: contoh pemasukan Rp50.000 dan pengeluaran Rp20.000 menghasilkan saldo harian Rp30.000.
- Kegiatan biasa tidak mengubah saldo; entri belum selesai tetap mengikuti aturan hitung yang dijelaskan.
- CRUD: tambah, ubah, hapus, dan status selesai hanya memengaruhi kegiatan yang dipilih.
- Persistensi: kegiatan, target, dan tema tetap terbaca setelah aplikasi dimulai ulang.
- Laporan: tanggal, kategori, rentang mingguan, dan ringkasan bulanan menampilkan agregat sesuai data.

## VI. Ruang lingkup dan kesimpulan

Pertemuan 7 menyimpan kegiatan pada perangkat melalui SQLite. Sinkronisasi server, login, dan CRUD cloud bukan bagian dari versi ini. Pemeriksaan konektivitas API dan MySQL dicatat pada pertemuan berikutnya, sehingga kedua cakupan tersebut tidak boleh dicampur dalam penjelasan implementasi P7.
TabungKu menunjukkan bagaimana fitur kecil dari beberapa pertemuan dapat dirangkai menjadi aplikasi yang utuh. Konsistensi model, aturan hitung, penyimpanan, dan pembaruan UI menjadi bagian penting agar laporan keuangan tidak hanya menarik secara visual tetapi juga dapat dipercaya. Kode inti berada di folder lib/pert7/models, lib/pert7/data, dan lib/pert7/pages; dokumentasi proyek tersedia di lib/pert7/Doc Tugas/penjelasan_tabungku.md.
