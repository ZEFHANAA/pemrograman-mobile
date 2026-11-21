enum JenisKeuangan { tanpa, pemasukan, pengeluaran }

class AktivitasTabungan {
  const AktivitasTabungan({
    this.id,
    required this.judul,
    required this.tanggal,
    required this.selesai,
    required this.tipe,
    required this.nominal,
    required this.kategori,
    this.catatan = '',
  });

  final int? id;
  final String judul;
  final String tanggal;
  final bool selesai;
  final JenisKeuangan tipe;
  final int nominal;
  final String kategori;
  final String catatan;

  Map<String, Object?> toMap() => {
        'id': id,
        'judul': judul,
        'tanggal': tanggal,
        'selesai': selesai ? 1 : 0,
        'tipe': tipe.name,
        'nominal': nominal,
        'kategori': kategori,
        'catatan': catatan,
      };

  factory AktivitasTabungan.fromMap(Map<String, Object?> map) => AktivitasTabungan(
        id: map['id'] as int,
        judul: map['judul'] as String,
        tanggal: map['tanggal'] as String,
        selesai: (map['selesai'] as int) == 1,
        tipe: JenisKeuangan.values.byName(map['tipe'] as String),
        nominal: map['nominal'] as int,
        kategori: map['kategori'] as String,
        catatan: (map['catatan'] as String?) ?? '',
      );
}

class RingkasanHari {
  const RingkasanHari({required this.jumlah, required this.selesai, required this.pemasukan, required this.pengeluaran});
  final int jumlah;
  final int selesai;
  final int pemasukan;
  final int pengeluaran;
  int get tabungan => pemasukan - pengeluaran;
}
