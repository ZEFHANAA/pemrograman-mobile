import 'package:flutter/material.dart';
import '../data/wisata_data.dart';
import 'wisata_detail_page.dart';

class Tugas7Page extends StatefulWidget {
  const Tugas7Page({super.key});

  @override
  State<Tugas7Page> createState() => _Tugas7PageState();
}

class _Tugas7PageState extends State<Tugas7Page> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Posisi simulasi pengguna (Default: Jakarta Barat / Universitas Esa Unggul)
  double _userLat = -6.1895231;
  double _userLng = 106.7681442;
  String _userLocationLabel = 'Universitas Esa Unggul (Jakarta Barat)';
  bool _isLocating = false;

  Wisata? _selectedWisata;

  List<Wisata> get _filteredWisataList {
    return daftarWisata.where((w) {
      final matchesCategory =
          _selectedCategory == 'Semua' || w.kategori == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          w.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.daerah.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          w.kategori.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) {
        final distA = a.hitungJarakKm(_userLat, _userLng);
        final distB = b.hitungJarakKm(_userLat, _userLng);
        return distA.compareTo(distB);
      });
  }

  void _simulasikanUpdateLokasi() {
    setState(() {
      _isLocating = true;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isLocating = false;
        // Lokasi pengguna diperbarui ke Tugu Jogja untuk demo kalkulasi jarak dinamis
        _userLat = -7.7828892;
        _userLng = 110.3670642;
        _userLocationLabel = 'Tugu Pal Putih (Yogyakarta)';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location Provider: Posisi diperbarui ke Yogyakarta! Jarak destinasi dihitung ulang.'),
          backgroundColor: Color(0xFF2E7D32),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _tampilkanBottomSheetWisata(Wisata wisata) {
    setState(() {
      _selectedWisata = wisata;
    });

    final jarak = wisata.hitungJarakKm(_userLat, _userLng);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      wisata.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1565C0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      wisata.kategori,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 15, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    wisata.daerah,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.near_me,
                        size: 18, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 8),
                    Text(
                      'Jarak: ${jarak.toStringAsFixed(1)} km dari posisi Anda',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                wisata.deskripsi,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                      label: const Text('Tutup'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WisataDetailPage(
                              wisata: wisata,
                              userLat: _userLat,
                              userLng: _userLng,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info),
                      label: const Text('Lihat Detail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final list = _filteredWisataList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PetaWisata Indonesia - LBS'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Bar Informasi Posisi Pengguna & Tombol Refresh Lokasi
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            color: const Color(0xFF1565C0).withValues(alpha: 0.08),
            child: Row(
              children: [
                const Icon(Icons.my_location,
                    color: Color(0xFF1565C0), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Titik Acuan LBS (Posisi Pengguna):',
                        style: TextStyle(fontSize: 10.5, color: Colors.grey),
                      ),
                      Text(
                        _userLocationLabel,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: _isLocating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync, color: Color(0xFF1565C0)),
                  tooltip: 'Sinkron Lokasi GPS Baru',
                  onPressed: _isLocating ? null : _simulasikanUpdateLokasi,
                ),
              ],
            ),
          ),

          // Peta Destinasi Wisata Interaktif (Visual Map Viewer)
          Container(
            height: 200,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // Latar Belakang Peta Nusantara
                  Container(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFE0F2FE),
                    child: CustomPaint(
                      painter: _IndonesiaMapPainter(isDark: isDark),
                      size: Size.infinite,
                    ),
                  ),

                  // Plot Marker Destinasi Wisata
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        return Stack(
                          children: list.take(8).map((w) {
                            // Proyeksi koordinat Indonesia ke bidang canvas sederhana
                            // Indonesia: Lat -11 s/d 6, Lng 95 s/d 141
                            final leftPercent =
                                ((w.bujur - 95.0) / (141.0 - 95.0)).clamp(0.05, 0.95);
                            final topPercent =
                                ((6.0 - w.lintang) / (6.0 - (-11.0))).clamp(0.1, 0.9);

                            final isSelected = _selectedWisata?.nama == w.nama;

                            return Positioned(
                              left: constraints.maxWidth * leftPercent - 14,
                              top: constraints.maxHeight * topPercent - 14,
                              child: GestureDetector(
                                onTap: () => _tampilkanBottomSheetWisata(w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: isSelected ? 30 : 22,
                                      color: isSelected
                                          ? const Color(0xFFE53935)
                                          : const Color(0xFF1565C0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                  // Overlay Info Peta
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Peta Sebaran: ${list.length} Destinasi Terdeteksi',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari destinasi, kota, atau kategori...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          const SizedBox(height: 8),

          // Filter Kategori
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: daftarKategori.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (ctx, index) {
                final cat = daftarKategori[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: const Color(0xFF1565C0),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontSize: 12,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Daftar Destinasi Wisata Terurut Berdasarkan Jarak
          Expanded(
            child: list.isEmpty
                ? const Center(
                    child: Text('Tidak ada destinasi yang cocok dengan pencarian.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: list.length,
                    itemBuilder: (ctx, index) {
                      final item = list[index];
                      final jarak = item.hitungJarakKm(_userLat, _userLng);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          leading: CircleAvatar(
                            backgroundColor:
                                const Color(0xFF1565C0).withValues(alpha: 0.15),
                            child: Icon(
                              _getCategoryIcon(item.kategori),
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                          title: Text(
                            item.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.5,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(item.daerah,
                                  style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${jarak.toStringAsFixed(1)} km',
                                      style: const TextStyle(
                                        color: Color(0xFF2E7D32),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tiket: ${item.tiket.split(" / ")[0]}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WisataDetailPage(
                                  wisata: item,
                                  userLat: _userLat,
                                  userLng: _userLng,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case 'Candi':
        return Icons.account_balance;
      case 'Gunung':
        return Icons.landscape;
      case 'Pantai':
        return Icons.beach_access;
      case 'Danau':
        return Icons.water;
      case 'Kota':
        return Icons.location_city;
      default:
        return Icons.place;
    }
  }
}

class _IndonesiaMapPainter extends CustomPainter {
  final bool isDark;
  _IndonesiaMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final islandPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFBAE6FD)
      ..style = PaintingStyle.fill;

    // Gambar siluet kepulauan Indonesia sederhana
    // Sumatera
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.08, size.height * 0.25, size.width * 0.22, size.height * 0.4),
      islandPaint,
    );
    // Jawa
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.25, size.height * 0.65, size.width * 0.35, size.height * 0.15),
      islandPaint,
    );
    // Kalimantan
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.35, size.height * 0.2, size.width * 0.22, size.height * 0.38),
      islandPaint,
    );
    // Sulawesi
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.6, size.height * 0.3, size.width * 0.14, size.height * 0.35),
      islandPaint,
    );
    // Bali & Nusa Tenggara
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.6, size.height * 0.72, size.width * 0.2, size.height * 0.12),
      islandPaint,
    );
    // Papua
    canvas.drawOval(
      Rect.fromLTWH(
          size.width * 0.78, size.height * 0.35, size.width * 0.2, size.height * 0.38),
      islandPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
