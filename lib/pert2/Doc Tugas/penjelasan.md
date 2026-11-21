# Laporan Praktikum dan Tugas Pertemuan 2 - Layout, Daftar Kontak, dan Navigasi

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Laporan ini membahas pemodelan data kontak, penayangan koleksi dalam daftar, pencarian, dan perpindahan dari daftar menuju detail. Praktikum menampilkan pola daftar dan detail, sedangkan tugas mengembangkan alur tersebut dengan pencarian dan filter. Penekanan diberikan pada pemisahan data dari UI dan pengiriman objek yang dipilih ke halaman berikutnya.

## I. Pendahuluan dan tujuan

Aplikasi mobile sering menampilkan kumpulan data yang ukurannya dapat berubah. Daftar yang dibuat dengan widget pembangun item membantu menyusun data dengan pola yang konsisten. Pengguna juga perlu cara untuk menemukan entri tertentu serta melihat informasi yang lebih lengkap.
Pertemuan ini bertujuan menyusun layout yang mudah dibaca, memetakan data ke model Contact, menampilkan item secara berulang, memfilter data berdasarkan kata kunci, dan membuka halaman detail melalui Navigator.

- Memisahkan representasi kontak dari komponen tampilan.
- Menggunakan ListView.builder untuk daftar dinamis.
- Menerapkan pencarian dan navigasi menuju detail kontak.

## II. Landasan konsep

Model data mendefinisikan atribut yang dimiliki setiap kontak, misalnya nama dan informasi pendukung. Bentuk model yang jelas mengurangi ketergantungan UI pada map bebas dan membuat pemakaian data lebih konsisten.
ListView.builder membuat item sesuai kebutuhan tampilan. Navigator.push menambahkan halaman baru pada tumpukan navigasi, sedangkan Navigator.pop kembali ke halaman sebelumnya. TextField menerima kata kunci; daftar hasil dibentuk dari data yang sesuai dengan pencarian.

- Pencarian tanpa huruf besar-kecil memberi pengalaman yang lebih toleran.
- Kondisi tanpa hasil perlu menampilkan pesan yang informatif.
- Halaman detail menerima kontak yang dipilih, bukan selalu memakai data tetap.

## III. Pelaksanaan praktikum

Praktikum2Page menampilkan daftar kontak menggunakan ListView. Setiap baris berfungsi sebagai titik interaksi. Ketika item dipilih, aplikasi menjalankan Navigator.push dan membuka halaman detail yang menampilkan informasi kontak tersebut.
Data kontak dipusatkan dalam model Contact. Dengan pola ini, widget daftar membaca properti model untuk menampilkan nama atau ringkasan, dan halaman detail memakai objek yang sama. Tidak diperlukan pengambilan data dari server pada latihan ini.

- Siapkan beberapa objek Contact sebagai data latihan.
- Buat item daftar dari kumpulan tersebut.
- Kirim objek yang dipilih ke route detail dan tampilkan atributnya.

## IV. Pembahasan tugas

Tugas2Page mengembangkan contoh menjadi daftar yang bisa dicari. Teks dari kolom pencarian dipakai untuk membentuk kumpulan hasil sebelum item dirender. Ketika hasil dipilih, detail ditampilkan melalui halaman terpisah. Alur ini menggabungkan input, transformasi data sederhana, dan navigasi.
Pemisahan data, daftar, dan detail menghindari satu widget memuat seluruh logika. Jika daftar kosong karena kata kunci tidak cocok, UI sebaiknya menjelaskan bahwa tidak ada kontak yang ditemukan dan memberi cara untuk menghapus kata kunci.

- Daftar awal menampilkan semua kontak contoh.
- Pencarian nama mempersempit hasil ketika pengguna mengetik.
- Menghapus kata kunci mengembalikan semua data.
- Memilih hasil membuka detail yang sesuai dengan baris tersebut.

## V. Pemeriksaan hasil

Skenario berikut adalah panduan pemeriksaan manual, bukan catatan hasil eksekusi.

- Daftar: jumlah dan label item sesuai dengan data contoh.
- Pencarian: masukan parsial menemukan hasil dan kata kunci tanpa hasil menampilkan empty state.
- Navigasi: tombol kembali mengembalikan pengguna ke daftar dan kata kunci tetap masuk akal.
- Layar sempit: teks panjang tidak menyebabkan overflow horizontal.

## VI. Kesimpulan

Model Contact, ListView.builder, TextField, dan Navigator membentuk alur dasar aplikasi berbasis daftar. Latihan ini mempersiapkan struktur untuk halaman yang memakai data asinkron maupun penyimpanan lokal.

- Berkas utama: lib/pert2/data/contact.dart, lib/pert2/praktikum/praktikum2_contacts_page.dart, dan lib/pert2/tugas/tugas2_contacts_page.dart.
- Dokumentasi implementasi: lib/pert2/Doc Tugas/laporan_terkini.md.
