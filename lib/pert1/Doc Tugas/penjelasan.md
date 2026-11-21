# Laporan Praktikum dan Tugas Pertemuan 1 - Widget Flutter dan Interaksi Dasar

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Pertemuan ini membangun dasar membaca struktur aplikasi Flutter melalui tampilan pengenalan dan counter interaktif. Praktikum memperlihatkan hubungan antara widget, state, dan pembaruan tampilan. Tugas menerapkan susunan widget untuk menyajikan kartu perkenalan. Fokus laporan adalah alur yang terlihat pada implementasi saat ini, bukan klaim bahwa setiap konsep Android native sudah dibuat.

## I. Pendahuluan dan tujuan

Antarmuka Flutter tersusun dari widget yang dapat digabungkan menjadi halaman. Memahami peran widget dasar membuat pengembangan berikutnya lebih mudah: halaman menyediakan kerangka, layout mengatur posisi, dan widget interaktif menerima tindakan pengguna.
Tujuan pembelajaran pada latihan ini adalah mengenali peran MaterialApp dan Scaffold, membedakan widget yang statis dengan widget yang memiliki state, serta menghubungkan penekanan tombol dengan perubahan data dan tampilan. Tujuan tugas adalah menyusun informasi perkenalan dalam kartu yang mudah dibaca.

- Mengenali struktur entry point dan halaman Flutter.
- Menggunakan Column, Card, Padding, Text, dan tombol untuk membentuk UI.
- Memperbarui nilai counter secara lokal melalui setState.

## II. Landasan konsep

Widget merupakan deskripsi konfigurasi antarmuka. StatelessWidget cocok untuk bagian yang tidak menyimpan perubahan internal. StatefulWidget dipakai ketika suatu nilai berubah selama halaman aktif. setState memberi tahu Flutter bahwa state berubah sehingga bagian terkait perlu dibangun kembali.
Scaffold menyediakan struktur halaman Material seperti AppBar dan body. Card memberi batas visual pada kelompok informasi, sementara Padding dan Column membantu menjaga jarak serta urutan vertikal. Pemisahan widget membuat setiap bagian lebih mudah dibaca dan dirawat.

- State awal counter harus konsisten dengan angka yang terlihat.
- Tindakan tombol mengubah nilai state, bukan hanya mengganti teks statis.
- Widget perkenalan menerima identitas dari data yang ditetapkan di kode.

## III. Pelaksanaan praktikum

Halaman Praktikum1Page memuat teks pengenalan Flutter dan sebuah counter. Saat tombol ditekan, callback memperbarui counter di dalam setState. Flutter kemudian membangun ulang tampilan sehingga angka terbaru terlihat. Pola ini memperlihatkan alur sederhana dari input, perubahan state, sampai render ulang.
Komponen tampilan disusun sebagai pohon widget. Scaffold menjadi akar halaman; bagian isi berisi susunan teks, kartu, dan kontrol. Penggunaan const pada widget yang tidak berubah dapat membantu menandai bagian yang tidak membutuhkan konfigurasi ulang.

- Jalankan halaman praktikum dan amati nilai awal.
- Tekan tombol beberapa kali dan bandingkan perubahan angka dengan pesan status.
- Kembali ke halaman awal untuk memastikan halaman lain tetap dapat dibuka.

## IV. Pembahasan tugas

Tugas1Page menyusun kartu perkenalan menggunakan widget Material. Kartu menempatkan identitas seperti nama dan NIM bersama informasi profil yang disediakan pada implementasi. Susunan ini melatih hierarki visual: informasi utama ditampilkan lebih dahulu, lalu keterangan tambahan.
Widget kartu perkenalan dipisahkan dari halaman tugas agar tanggung jawab tampilan lebih terfokus. Jika data profil berubah, nilai teks dapat disesuaikan pada satu tempat tanpa mengubah kerangka navigasi aplikasi. Isian program studi dan hobi harus ditinjau langsung pada berkas tugas sebelum pengumpulan agar sesuai dengan data pribadi.

- Kartu harus menampilkan teks tanpa terpotong pada lebar layar kecil.
- Jarak antarjudul, identitas, dan keterangan perlu konsisten.
- Pastikan nama dan NIM yang tampil sesuai dengan identitas mahasiswa.

## V. Pemeriksaan hasil

Daftar berikut merupakan skenario pemeriksaan yang dapat dijalankan pada emulator atau perangkat. Laporan ini tidak menyatakan skenario telah dijalankan; hasil aktual sebaiknya dicatat setelah aplikasi dibuka.

- Counter: nilai meningkat satu angka untuk setiap ketukan.
- Navigasi: halaman praktikum dan tugas dapat dibuka tanpa menampilkan layar kosong.
- Kartu: informasi utama terbaca dan tidak overflow pada ukuran layar berbeda.

## VI. Kesimpulan

Latihan ini menghubungkan komposisi widget dengan interaksi state. Counter memberi contoh perubahan state paling sederhana, sementara kartu perkenalan melatih penyusunan informasi dalam layout Material. Pemahaman ini menjadi dasar untuk daftar, form, navigasi, dan penyimpanan data pada pertemuan berikutnya.

- Berkas utama: lib/pert1/praktikum/praktikum1_page.dart, lib/pert1/tugas/tugas1_page.dart, dan lib/pert1/tugas/tugas1_intro_card.dart.
- Dokumentasi implementasi: lib/pert1/Doc Tugas/laporan_terkini.md.
