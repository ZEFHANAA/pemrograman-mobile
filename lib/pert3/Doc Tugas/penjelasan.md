# Laporan Praktikum dan Tugas Pertemuan 3 - Form, Validasi, dan Provider

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Pertemuan ini menggabungkan form input dengan pengelolaan state daftar belanja. Input divalidasi sebelum ditambahkan, sedangkan ChangeNotifier dan Provider memisahkan data aplikasi dari widget. Tugas mencakup penambahan item, perubahan status dibeli, dan penghapusan item dengan tampilan yang mengikuti perubahan state.

## I. Pendahuluan dan tujuan

Form menjadi pintu masuk data pengguna sehingga masukan perlu diperiksa sebelum disimpan. Setelah data diterima, perubahan harus diteruskan ke bagian UI yang menampilkan daftar. Menempatkan seluruh data di dalam widget dapat membuat logika halaman sulit dikelola ketika fitur bertambah.
Tujuan latihan adalah mengumpulkan masukan melalui TextFormField, menggunakan validator, menyimpan daftar pada model state, serta memahami bagaimana perubahan ChangeNotifier diberitahukan ke widget melalui Provider.

- Memastikan masukan wajib tidak kosong.
- Memisahkan operasi daftar dari kode presentasi.
- Menampilkan ulang UI ketika item ditambah, ditandai, atau dihapus.

## II. Landasan konsep

Form mengelompokkan field dan dapat menggunakan GlobalKey<FormState> untuk menjalankan validasi. Validator mengembalikan pesan ketika data tidak memenuhi syarat; proses simpan hanya diteruskan jika seluruh field valid.
ChangeNotifier menyediakan notifikasi perubahan. Provider membuat model tersedia pada bagian widget turunannya. Widget yang membaca model akan membangun ulang tampilan ketika model memberi notifikasi. Pola ini menjaga sumber state tetap terpusat dan mengurangi pengiriman callback melewati banyak widget.

- Validasi dilakukan sebelum mutasi data.
- Operasi tambah, toggle, dan hapus ditempatkan dalam ShoppingListModel.
- State pada versi ini bersifat memori; penyimpanan setelah aplikasi ditutup tidak diasumsikan.

## III. Pelaksanaan praktikum

Praktikum3Page menyediakan input nama barang dan daftar hasil. Ketika tombol simpan ditekan, form memeriksa nilai melalui validator. Jika valid, nama diteruskan ke model daftar belanja. Model memperbarui koleksi dan memanggil notifikasi sehingga UI membaca daftar terbaru.
Dengan pola tersebut, widget berperan mengumpulkan dan menampilkan data, sementara model mengatur perubahan. Validasi mencegah entri kosong masuk ke daftar. Pemisahan ini juga membuat operasi data lebih mudah diperiksa secara terpisah.

- Isi nama barang lalu kirim form.
- Kosongkan field untuk melihat pesan validasi.
- Periksa bahwa item valid muncul pada daftar sesudah disimpan.

## IV. Pembahasan tugas

Tugas3Page menerapkan daftar belanja yang mendukung tambah item, mengubah status sudah dibeli, dan menghapus item. Setiap operasi melalui ShoppingListModel. UI menampilkan indikator status agar item yang sudah selesai dapat dibedakan dari item yang masih perlu dibeli.
Status selesai sebaiknya tidak menghapus teks item; informasi tetap tersedia untuk konteks. Penghapusan merupakan tindakan berbeda dan perlu dilakukan secara eksplisit. Pembagian operasi tersebut memperjelas makna kontrol yang ditampilkan pada tiap baris.

- Create: item baru dimasukkan sesudah validasi.
- Update: status item berubah saat kontrol selesai ditekan.
- Delete: item dihilangkan dari daftar setelah kontrol hapus dipilih.
- Read: daftar selalu berasal dari state model.

## V. Pemeriksaan hasil

Panduan pemeriksaan ini tidak menyatakan bahwa tes telah dijalankan.

- Masukan kosong ditolak dan menampilkan pesan yang sesuai.
- Item valid muncul satu kali pada daftar.
- Menandai selesai hanya mengubah status item yang dipilih.
- Menghapus satu item tidak mengubah item lain.
- Periksa perilaku setelah menutup dan membuka ulang aplikasi; versi memori seharusnya tidak diperlakukan sebagai penyimpanan permanen.

## VI. Kesimpulan

Form dan validator menjaga kualitas masukan, sedangkan Provider bersama ChangeNotifier memisahkan pengelolaan state dari tampilan. Implementasi ini memberi fondasi pola CRUD dalam memori sebelum materi penyimpanan lokal pada pertemuan berikutnya.

- Berkas utama: lib/pert3/data/shopping_list_model.dart, lib/pert3/praktikum/praktikum3_provider_page.dart, dan lib/pert3/tugas/tugas3_shopping_page.dart.
- Dokumentasi implementasi: lib/pert3/Doc Tugas/laporan_terkini.md.
