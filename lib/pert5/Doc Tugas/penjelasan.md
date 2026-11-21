# Laporan Praktikum dan Tugas Pertemuan 5 - Shared Preferences dan Database SQLite

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Pertemuan ini membedakan penyimpanan preferensi kecil dengan penyimpanan data terstruktur. Aplikasi catatan pengeluaran menggunakan SQLite untuk operasi CRUD dan menyimpan pilihan mata uang melalui Shared Preferences. Laporan menerangkan bentuk data, alur pembacaan dan perubahan, serta skenario pemeriksaan yang dapat dijalankan.

## I. Pendahuluan dan tujuan

Aplikasi yang perlu mempertahankan daftar transaksi setelah ditutup membutuhkan penyimpanan lokal. Preferensi sederhana seperti pilihan tampilan tidak memerlukan tabel relasional, sedangkan catatan pengeluaran memiliki beberapa atribut dan membutuhkan operasi query.
Tujuan pertemuan adalah memahami perbedaan kedua media tersebut, menggunakan SQLite untuk catatan pengeluaran, dan memakai Shared Preferences untuk pilihan mata uang. Implementasi juga melatih validasi input dan penyegaran UI sesudah data berubah.

- Membuat dan membaca tabel lokal.
- Melakukan Create, Read, Update, dan Delete pada catatan.
- Menyimpan nilai preferensi sederhana secara persisten.

## II. Landasan konsep

SQLite merupakan basis data relasional lokal. Tabel expenses menyimpan id, title, amount, dan date. Primary key mengidentifikasi setiap baris; operasi update dan delete memakai id agar perubahan diarahkan ke catatan tertentu.
Shared Preferences menyimpan pasangan key-value sederhana, misalnya string IDR atau USD. Pengaturan ini berbeda dari tabel transaksi: nilainya hanya satu preferensi kecil, tidak memerlukan query terhadap kumpulan catatan.

- amount harus dapat dikonversi menjadi angka yang bermakna.
- Tanggal perlu disimpan dalam format yang konsisten agar pemfilteran dapat dilakukan.
- Operasi database dijalankan asinkron supaya UI tetap responsif.

## III. Pelaksanaan praktikum

Praktikum5Page berinteraksi dengan ExpenseDatabase untuk memuat daftar transaksi dan mengubahnya. Saat halaman dibuka, data dibaca dari tabel lokal. Setiap penambahan, perubahan, atau penghapusan diteruskan ke database, lalu daftar dimuat ulang agar jumlah dan total yang terlihat mencerminkan keadaan terbaru.
Form pengeluaran meminta judul dan jumlah. Tanggal transaksi ditetapkan otomatis dari waktu saat catatan disimpan. Validasi menolak judul kosong serta nilai nominal yang tidak bisa dibaca. Umpan balik setelah simpan atau hapus membantu pengguna memahami apakah tindakan selesai.

- Buka halaman untuk memuat transaksi tersimpan.
- Tambah catatan dengan judul, nominal, dan tanggal.
- Ubah catatan tertentu dan simpan hasilnya.
- Hapus dengan kontrol yang sesuai dan perbarui ringkasan.

## IV. Pembahasan tugas

Tugas5Page mengembangkan pencatatan pengeluaran dengan pengaturan mata uang. Nilai mata uang disimpan menggunakan SharedPreferencesAsync pada key expense_currency. Pilihan IDR atau USD digunakan saat menampilkan nilai, sedangkan data transaksi tetap berada pada tabel SQLite.
Pemisahan ini mencegah informasi transaksi tercampur dengan preferensi tampilan. Total pengeluaran dapat dihitung dari baris transaksi dan ditampilkan kembali setelah setiap perubahan. Bila pengguna mengganti mata uang, nilai pilihan perlu tetap terbaca setelah aplikasi dibuka ulang.

- Create menambahkan baris expense baru.
- Read memuat semua expense untuk daftar dan total.
- Update mengubah catatan berdasarkan id.
- Delete menghapus catatan yang dipilih.
- Preferensi mata uang dibaca saat halaman dimulai dan ditulis saat pilihan berubah.

## V. Pemeriksaan hasil

Daftar berikut adalah skenario verifikasi yang perlu dijalankan, bukan pernyataan bahwa hasil perangkat sudah diperoleh.

- Tambah, ubah, dan hapus memengaruhi item yang tepat.
- Judul kosong dan nominal tidak valid ditolak.
- Total berubah sesuai operasi CRUD.
- Pilihan IDR/USD bertahan setelah aplikasi dibuka kembali.
- Data transaksi tetap tersedia setelah aplikasi dimulai ulang.

## VI. Kesimpulan

SQLite sesuai untuk transaksi terstruktur yang membutuhkan operasi CRUD. Shared Preferences sesuai untuk preferensi sederhana seperti mata uang. Penggunaan media yang tepat membuat data lebih terorganisir dan memudahkan aplikasi memulihkan keadaan setelah dimulai ulang.

- Berkas utama mencakup ExpenseDatabase, model Expense, praktikum5_page.dart, dan tugas5_page.dart di lib/pert5/.
- Dokumentasi implementasi: lib/pert5/Doc Tugas/laporan_terkini.md.
