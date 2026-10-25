import 'dart:math' as math;

class Wisata {
  final String nama;
  final String daerah;
  final String kategori;
  final String deskripsi;
  final String tiket;
  final String jamBuka;
  final double lintang;
  final double bujur;

  const Wisata({
    required this.nama,
    required this.daerah,
    required this.kategori,
    required this.deskripsi,
    required this.tiket,
    required this.jamBuka,
    required this.lintang,
    required this.bujur,
  });

  /// Menghitung jarak garis lurus (haversine) dalam kilometer
  double hitungJarakKm(double userLat, double userLng) {
    const double r = 6371; // Jari-jari bumi (km)
    final double dLat = _deg2rad(lintang - userLat);
    final double dLng = _deg2rad(bujur - userLng);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(userLat)) *
            math.cos(_deg2rad(lintang)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return r * c;
  }

  static double _deg2rad(double deg) => deg * (math.pi / 180.0);
}

const List<String> daftarKategori = [
  'Semua',
  'Candi',
  'Gunung',
  'Pantai',
  'Danau',
  'Kota',
];

const List<Wisata> daftarWisata = [
  Wisata(
    nama: 'Candi Borobudur',
    daerah: 'Magelang, Jawa Tengah',
    kategori: 'Candi',
    deskripsi:
        'Candi Buddha terbesar di dunia yang merupakan mahakarya arsitektur abad ke-8 dan warisan budaya dunia UNESCO.',
    tiket: 'Rp 50.000 / orang',
    jamBuka: '06.30 - 16.30 WIB',
    lintang: -7.6078738,
    bujur: 110.2037513,
  ),
  Wisata(
    nama: 'Candi Prambanan',
    daerah: 'Sleman, D.I. Yogyakarta',
    kategori: 'Candi',
    deskripsi:
        'Kompleks candi Hindu terindah dan termegah di Indonesia yang dipersembahkan untuk Trimurti.',
    tiket: 'Rp 50.000 / orang',
    jamBuka: '06.30 - 17.00 WIB',
    lintang: -7.7520206,
    bujur: 110.4914674,
  ),
  Wisata(
    nama: 'Gunung Bromo',
    daerah: 'Probolinggo, Jawa Timur',
    kategori: 'Gunung',
    deskripsi:
        'Gunung berapi aktif dengan panorama kawah dramatis, lautan pasir berbisik, dan pesona matahari terbit spektakuler.',
    tiket: 'Rp 29.000 - Rp 34.000 / orang',
    jamBuka: '24 Jam',
    lintang: -7.9424936,
    bujur: 112.9530122,
  ),
  Wisata(
    nama: 'Gunung Rinjani',
    daerah: 'Lombok Utara, NTB',
    kategori: 'Gunung',
    deskripsi:
        'Gunung berapi tertinggi kedua di Indonesia dengan pemandangan Danau Segara Anak yang memukau.',
    tiket: 'Rp 20.000 / orang / hari',
    jamBuka: '07.00 - 15.00 WITA (Pos Registrasi)',
    lintang: -8.4112952,
    bujur: 116.4573199,
  ),
  Wisata(
    nama: 'Pantai Kuta',
    daerah: 'Badung, Bali',
    kategori: 'Pantai',
    deskripsi:
        'Pantai pasir putih legendaris di Pulau Dewata yang terkenal dengan ombak selancar dan pemandangan sunset mempesona.',
    tiket: 'Gratis',
    jamBuka: '24 Jam',
    lintang: -8.7184924,
    bujur: 115.1686202,
  ),
  Wisata(
    nama: 'Pantai Pink (Tangsi)',
    daerah: 'Lombok Timur, NTB',
    kategori: 'Pantai',
    deskripsi:
        'Salah satu pantai berpasir merah muda langka di dunia akibat pecahan terumbu karang foraminifera.',
    tiket: 'Rp 10.000 / orang',
    jamBuka: '08.00 - 17.00 WITA',
    lintang: -8.8475518,
    bujur: 116.4886675,
  ),
  Wisata(
    nama: 'Danau Toba',
    daerah: 'Sumatera Utara',
    kategori: 'Danau',
    deskripsi:
        'Danau vulkanik terbesar di Asia Tenggara dengan Pulau Samosir di tengahnya, menyimpan kekayaan budaya Batak.',
    tiket: 'Rp 10.000 - Rp 15.000 (Spot Wisata)',
    jamBuka: '24 Jam',
    lintang: 2.6845347,
    bujur: 98.8755914,
  ),
  Wisata(
    nama: 'Danau Kelimutu',
    daerah: 'Ende, Flores, NTT',
    kategori: 'Danau',
    deskripsi:
        'Danau tiga warna ajaib di puncak kawah Gunung Kelimutu yang dapat berubah warna secara periodik.',
    tiket: 'Rp 20.000 / orang',
    jamBuka: '05.00 - 18.00 WITA',
    lintang: -8.7669444,
    bujur: 121.8194444,
  ),
  Wisata(
    nama: 'Monumen Nasional (Monas)',
    daerah: 'Jakarta Pusat, DKI Jakarta',
    kategori: 'Kota',
    deskripsi:
        'Ikon kebanggaan Indonesia setinggi 132 meter yang melambangkan perjuangan kemerdekaan rakyat Indonesia.',
    tiket: 'Rp 5.000 - Rp 15.000 / orang',
    jamBuka: '08.00 - 16.00 WIB (Selasa - Minggu)',
    lintang: -6.1753924,
    bujur: 106.8271528,
  ),
  Wisata(
    nama: 'Kota Tua Jakarta',
    daerah: 'Jakarta Barat, DKI Jakarta',
    kategori: 'Kota',
    deskripsi:
        'Kawasan cagar budaya dengan gedung-gedung bergaya kolonial Belanda, Museum Fatahillah, dan sepeda ontel.',
    tiket: 'Gratis kawasan (Museum Rp 5.000)',
    jamBuka: '08.00 - 21.00 WIB',
    lintang: -6.1352002,
    bujur: 106.8133005,
  ),
  Wisata(
    nama: 'Labuan Bajo & Pulau Komodo',
    daerah: 'Manggarai Barat, NTT',
    kategori: 'Pantai',
    deskripsi:
        'Gerbang utama menuju habitat asli komodo, laut jernih penuh terumbu karang, dan pemandangan pulau eksotis.',
    tiket: 'Rp 50.000 - Rp 150.000 (Taman Nasional)',
    jamBuka: '06.00 - 18.00 WITA',
    lintang: -8.4538889,
    bujur: 119.8727778,
  ),
  Wisata(
    nama: 'Kawah Ijen',
    daerah: 'Banyuwangi, Jawa Timur',
    kategori: 'Gunung',
    deskripsi:
        'Kawah asam terbesar dengan fenomena api biru (blue fire) langka yang hanya ada dua di dunia.',
    tiket: 'Rp 5.000 - Rp 7.500 / orang',
    jamBuka: '02.00 - 12.00 WIB',
    lintang: -8.0583333,
    bujur: 114.2416667,
  ),
  Wisata(
    nama: 'Candi Muaro Jambi',
    daerah: 'Muaro Jambi, Jambi',
    kategori: 'Candi',
    deskripsi:
        'Kompleks percandian bata merah peninggalan Kerajaan Sriwijaya dan Melayu Kuno terluas di Asia Tenggara.',
    tiket: 'Rp 10.000 / orang',
    jamBuka: '08.00 - 18.00 WIB',
    lintang: -1.4786111,
    bujur: 103.6672222,
  ),
  Wisata(
    nama: 'Danau Maninjau',
    daerah: 'Agam, Sumatera Barat',
    kategori: 'Danau',
    deskripsi:
        'Danau kaldera tenang yang dikelilingi perbukitan hijau dengan jalur jalan berkelok legendaris Kelok 44.',
    tiket: 'Gratis',
    jamBuka: '24 Jam',
    lintang: -0.3166667,
    bujur: 100.1833333,
  ),
  Wisata(
    nama: 'Kawasan Malioboro',
    daerah: 'Kota Yogyakarta, D.I. Yogyakarta',
    kategori: 'Kota',
    deskripsi:
        'Pusat wisata belanja cinderamata, batik, kuliner khas gudeg, dan kesenian jalanan jantung budaya Jogja.',
    tiket: 'Gratis',
    jamBuka: '24 Jam',
    lintang: -7.7925927,
    bujur: 110.3658442,
  ),
];
