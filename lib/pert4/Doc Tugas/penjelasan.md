# Laporan Praktikum dan Tugas Pertemuan 4 - REST API dan Pengelolaan Data Asinkron

**Mahasiswa:** Zefhana Ananda  
**NIM:** 20240801047  
**Mata kuliah:** Pemrograman Mobile (CR002)  

## Ringkasan

Laporan menjelaskan pengambilan daftar post dari JSONPlaceholder, pemetaan JSON ke model Dart, serta penanganan status memuat, sukses, dan gagal. Tugas menghubungkan daftar post dengan komentar pada halaman detail. Aplikasi menggunakan layanan HTTP publik; implementasi ini bukan demonstrasi Android Intent native.

## I. Pendahuluan dan tujuan

Data dari layanan web tidak tersedia seketika. Aplikasi perlu mengirim permintaan, menunggu respons, memeriksa hasil, dan memberi umpan balik selama proses berlangsung. Respons JSON perlu dipetakan ke objek agar UI tidak bergantung pada akses key yang tersebar.
Tujuan latihan adalah memahami pola REST sederhana, menjalankan permintaan HTTP secara asinkron, mengubah respons menjadi model Post dan PostComment, serta menampilkan daftar dan detail dengan keadaan UI yang sesuai.

- Menangani Future dan respons jaringan.
- Memisahkan model, klien API, dan halaman.
- Memberi tampilan loading, error, data, dan aksi coba lagi.

## II. Landasan konsep

REST API menyediakan resource melalui endpoint HTTP. GET digunakan untuk membaca data. JSON yang diterima harus dipastikan status responsnya sebelum diparse; respons sukses dapat dipetakan menjadi objek, sementara kegagalan perlu menghasilkan error yang dapat ditangani UI.
FutureBuilder memantau satu Future dan membangun UI sesuai AsyncSnapshot. Future yang belum selesai menampilkan indikator loading, error menampilkan pesan dan opsi pemulihan, dan data menampilkan hasil. Pemisahan lapisan membuat layanan API tidak bercampur dengan komponen visual.

- Model Post memuat identitas dan konten posting.
- Model komentar menghubungkan komentar dengan post melalui identifier.
- Coba lagi membuat permintaan baru; error tidak boleh tampil sebagai daftar kosong yang menyesatkan.

## III. Pelaksanaan praktikum

Praktikum4Page meminta daftar post dari JSONPlaceholder melalui PostApi. Layanan menggunakan paket http untuk mengirim GET. Setelah status respons dinyatakan sukses, data JSON diparse ke model Post dan diteruskan ke FutureBuilder untuk ditampilkan.
FutureBuilder menangani empat keadaan penting: menunggu, gagal, data kosong, dan data tersedia. Dengan membedakan keadaan ini, pengguna mengetahui apakah aplikasi sedang bekerja atau mengalami kendala jaringan. Permintaan ulang disediakan sebagai jalan pemulihan.

- Mulai permintaan saat halaman dibuat atau saat pengguna meminta muat ulang.
- Tampilkan CircularProgressIndicator selama menunggu.
- Render daftar setelah data berhasil dipetakan.
- Tampilkan error dan tombol coba lagi saat permintaan gagal.

## IV. Pembahasan tugas

Tugas4Page menampilkan daftar post, kemudian membuka detail ketika satu post dipilih. Halaman detail meminta komentar yang berkaitan dengan post tersebut dan menampilkannya sebagai daftar. Penggunaan identifier menghindari pemuatan komentar yang tidak berhubungan.
Kegagalan permintaan komentar perlu ditangani terpisah dari keberhasilan pemuatan post. Dengan demikian, masalah pada satu bagian tidak harus menghilangkan konteks post yang telah dipilih. UI juga perlu menjaga agar indikator dan pesan error tidak tertutup oleh konten lama.

- Pilih satu post dan pastikan judul detail sesuai.
- Pastikan parameter post yang benar dipakai saat mengambil komentar.
- Uji respons lambat, jaringan gagal, dan respons tanpa komentar.
- Navigasi kembali membawa pengguna ke daftar post.

## V. Ruang lingkup dan batasan

Sumber data pada latihan ini adalah JSONPlaceholder, yaitu API publik untuk data contoh. Data tidak dikelola oleh aplikasi dan perubahan lokal tidak berarti data server berubah. Kode ini menguji konsumsi REST API, bukan integrasi native Android Intent, backend milik sendiri, atau autentikasi.

- Teks laporan harus menyebut layanan contoh yang benar.
- Jangan menyatakan data tersimpan permanen jika hanya dibaca dari API.
- Jika perangkat tidak memiliki jaringan, tampilan error dan coba lagi menjadi bagian dari alur yang perlu diperiksa.

## VI. Pemeriksaan dan kesimpulan

Skenario berikut merupakan panduan manual dan belum menjadi hasil uji yang tercatat. Latihan ini menunjukkan bahwa model, API client, dan widget asinkron memiliki peran berbeda. Pemisahan tersebut meningkatkan keterbacaan dan membuat kegagalan jaringan lebih mudah ditangani.

- API sukses menampilkan daftar post.
- API gagal menampilkan pesan error serta aksi ulang.
- Detail memuat komentar yang sesuai dengan post pilihan.
- Berkas utama: lib/pert4/data/post_api.dart, lib/pert4/data/post_models.dart, dan halaman praktikum/tugas di lib/pert4/.
- Dokumentasi implementasi: lib/pert4/Doc Tugas/laporan_terkini.md.
