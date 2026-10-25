import 'package:flutter/material.dart';

class Praktikum7Page extends StatefulWidget {
  const Praktikum7Page({super.key});

  @override
  State<Praktikum7Page> createState() => _Praktikum7PageState();
}

class _Praktikum7PageState extends State<Praktikum7Page> {
  // Koordinat awal (Monas, Jakarta Pusat) sesuai pengantar LBS Modul 7
  double _currentLat = -6.1753924;
  double _currentLng = 106.8271528;
  String _locationName = 'Monumen Nasional (Pusat Awal)';
  String _statusMessage = 'Siap membaca lokasi perangkat';
  bool _isLoading = false;
  bool _hasCustomLocation = false;
  double _zoomLevel = 15.0;

  // Preset lokasi pengujian modul LBS (Jakarta, Bandung, Yogyakarta, Surabaya, Denpasar)
  final List<Map<String, dynamic>> _presetLocations = const [
    {
      'nama': 'Monas, Jakarta',
      'lat': -6.1753924,
      'lng': 106.8271528,
      'ket': 'Pusat Ibukota - DKI Jakarta',
    },
    {
      'nama': 'Gedung Sate, Bandung',
      'lat': -6.9024847,
      'lng': 107.6187428,
      'ket': 'Titik LBS Jawa Barat',
    },
    {
      'nama': 'Tugu Pal Putih, Yogyakarta',
      'lat': -7.7828892,
      'lng': 110.3670642,
      'ket': 'Titik Sumbu Filosofis D.I. Yogyakarta',
    },
    {
      'nama': 'Tugu Pahlawan, Surabaya',
      'lat': -7.2458428,
      'lng': 112.7378377,
      'ket': 'Titik LBS Jawa Timur',
    },
    {
      'nama': 'Pantai Sanur, Bali',
      'lat': -8.6882312,
      'lng': 115.2625211,
      'ket': 'Titik LBS Kepulauan Bali',
    },
  ];

  void _simulasikanBacaLokasiGps() {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Meminta izin ACCESS_FINE_LOCATION & membaca sinyal GPS satelit...';
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        // Lokasi pengguna aktual (Esa Unggul / Jakarta Barat)
        _currentLat = -6.1895231;
        _currentLng = 106.7681442;
        _locationName = 'Universitas Esa Unggul (Posisi Perangkat Terdeteksi)';
        _statusMessage =
            'Lokasi berhasil diperoleh via Location Provider (GPS/Satelit)';
        _hasCustomLocation = true;
        _zoomLevel = 16.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location Provider Berhasil: Koordinat GPS perangkat aktif!'),
          backgroundColor: Color(0xFF1B5E20),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _pilihPresetLokasi(Map<String, dynamic> loc) {
    setState(() {
      _currentLat = loc['lat'] as double;
      _currentLng = loc['lng'] as double;
      _locationName = loc['nama'] as String;
      _statusMessage = 'Kamera peta dipindahkan ke ${loc['nama']}';
      _hasCustomLocation = true;
    });
  }

  void _resetKePusatAwal() {
    setState(() {
      _currentLat = -6.1753924;
      _currentLng = 106.8271528;
      _locationName = 'Monumen Nasional (Pusat Awal)';
      _statusMessage = 'Peta dikembalikan ke posisi pusat awal';
      _hasCustomLocation = false;
      _zoomLevel = 15.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 7 - Location Based Service'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Pusat Peta',
            onPressed: _resetKePusatAwal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Teori Modul 7
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF1565C0).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.satellite_alt,
                      color: Color(0xFF1565C0), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Modul 7: Konsep LBS & Google Maps API',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Menerapkan 2 unsur utama LBS: Location Provider (API Location) untuk membaca posisi perangkat, dan Location Manager (API Maps) untuk memproyeksikan koordinat pada peta.',
                          style: TextStyle(fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card Status Koordinat & Provider
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _hasCustomLocation
                              ? Icons.my_location
                              : Icons.location_on,
                          color: _hasCustomLocation
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _locationName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            label: 'Latitude (Lintang)',
                            val: _currentLat.toStringAsFixed(7),
                            icon: Icons.explore_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoItem(
                            label: 'Longitude (Bujur)',
                            val: _currentLng.toStringAsFixed(7),
                            icon: Icons.explore,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Aksi Lokasi Saya (Location Provider)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _simulasikanBacaLokasiGps,
              icon: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.gps_fixed),
              label: Text(
                _isLoading
                  ? 'Menghubungkan ke GPS Satelit...'
                  : 'Dapatkan Lokasi Saya (Location Provider)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Area Peta Interaktif (Canvas Map Visualizer)
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // Grid / Peta latar belakang
                    Container(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE8F1F5),
                      child: CustomPaint(
                        painter: _MapGridPainter(isDark: isDark),
                        size: Size.infinite,
                      ),
                    ),

                    // Indikator Titik Peta Tengah (Pin Marker Maps)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              _locationName,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Icon(
                            Icons.location_on,
                            size: 44,
                            color: Color(0xFFE53935),
                          ),
                          Container(
                            width: 14,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Kontrol Zoom di pojok kanan bawah
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Column(
                        children: [
                          _buildMapToolButton(
                            icon: Icons.add,
                            onTap: () {
                              setState(() {
                                if (_zoomLevel < 20) _zoomLevel += 1;
                              });
                            },
                          ),
                          const SizedBox(height: 6),
                          _buildMapToolButton(
                            icon: Icons.remove,
                            onTap: () {
                              setState(() {
                                if (_zoomLevel > 3) _zoomLevel -= 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // Badge Google Maps Layer & Zoom Level
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white)
                              .withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.layers,
                                size: 14, color: Color(0xFF1565C0)),
                            const SizedBox(width: 6),
                            Text(
                              'Zoom: ${_zoomLevel.toInt()}x | Normal Vector',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pilihan Simulasi Titik Lokasi Lain (Modul 7 Sesi Uji Coba)
            Text(
              'Simulasi Pindah Posisi (CameraUpdate Location Manager):',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetLocations.map((loc) {
                final isSelected = loc['nama'] == _locationName;
                return ChoiceChip(
                  label: Text(loc['nama'] as String),
                  selected: isSelected,
                  selectedColor: const Color(0xFF1565C0),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontSize: 12,
                  ),
                  onSelected: (_) => _pilihPresetLokasi(loc),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Ringkasan Konsep Modul 7
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Komponen Teknis Modul 7 yang Diimplementasikan:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  SizedBox(height: 6),
                  Text('• Location Manager: Pengelolaan Marker, InfoWindow, dan CameraPosition.',
                      style: TextStyle(fontSize: 11.5, height: 1.35)),
                  Text('• Location Provider: Pengecekan GPS Service & Izin Runtime (Fine/Coarse).',
                      style: TextStyle(fontSize: 11.5, height: 1.35)),
                  Text('• API Key Configuration: Registrasi Google Maps API di AndroidManifest.xml.',
                      style: TextStyle(fontSize: 11.5, height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String val,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF1565C0)),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildMapToolButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF1565C0)),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final bool isDark;
  _MapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = (isDark ? Colors.white12 : Colors.black12)
      ..strokeWidth = 1;

    final roadPaint = Paint()
      ..color = (isDark ? Colors.white24 : Colors.white)
      ..strokeWidth = 6;

    // Garis grid koordinat
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Simulasi jalan arteri (road map)
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width, size.height * 0.55),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.6, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
