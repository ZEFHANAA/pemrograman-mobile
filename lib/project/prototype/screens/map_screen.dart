import 'package:flutter/material.dart';

import '../models/splw_models.dart';
import '../state/splw_state.dart';
import '../theme/splw_theme.dart';
import '../widgets/form_lokasi_sheet.dart';
import 'detail_screen.dart';

class MapScreen extends StatefulWidget {
  final SplwState state;
  final VoidCallback onRequireLogin;

  const MapScreen({
    super.key,
    required this.state,
    required this.onRequireLogin,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();

  double _mapCenterLat = -7.6079;
  double _mapCenterLng = 110.2038;
  String _activeLocationTitle = 'Candi Borobudur';
  String _activeLocationSubtitle = 'Magelang | -7,6079, 110,2038';

  final List<Map<String, dynamic>> _quickChips = const [
    {
      'label': 'Borobudur',
      'lat': -7.6079,
      'lng': 110.2038,
      'sub': 'Magelang | -7,6079, 110,2038',
      'kat': 'Budaya',
      'desc':
          'Candi Buddha terbesar peninggalan wangsa Syailendra di Magelang, Jawa Tengah.',
    },
    {
      'label': 'Raja Ampat',
      'lat': -0.5367,
      'lng': 130.5594,
      'sub': 'Papua Barat Daya | -0,5367, 130,5594',
      'kat': 'Pantai',
      'desc': 'Surga terumbu karang dan gugusan pulau karst di Papua Barat Daya.',
    },
    {
      'label': 'Gunung Bromo',
      'lat': -7.9425,
      'lng': 112.9530,
      'sub': 'Probolinggo | -7,9425, 112,9530',
      'kat': 'Gunung',
      'desc':
          'Kawah aktif menakjubkan di lautan pasir Taman Nasional Bromo Tengger Semeru.',
    },
    {
      'label': 'Danau Toba',
      'lat': 2.6845,
      'lng': 98.8756,
      'sub': 'Sumatera Utara | 2,6845, 98,8756',
      'kat': 'Alam',
      'desc': 'Danau kaldera raksasa dengan Pulau Samosir di Sumatera Utara.',
    },
  ];

  Map<String, dynamic>? _selectedPoint;
  bool _showSearchResultCard = true;

  @override
  void initState() {
    super.initState();
    final first = _quickChips[0];
    _mapCenterLat = first['lat'] as double;
    _mapCenterLng = first['lng'] as double;
    _activeLocationTitle = first['label'] as String;
    _activeLocationSubtitle = first['sub'] as String;
    _selectedPoint = first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  LokasiModel? _savedLocationForPoint(Map<String, dynamic>? point) {
    if (point == null) return null;
    final savedId = point['savedId'];
    if (savedId is String && savedId.isNotEmpty) {
      for (final lokasi in widget.state.lokasis) {
        if (lokasi.id == savedId) return lokasi;
      }
    }

    final user = widget.state.currentUser;
    final lat = point['lat'];
    final lng = point['lng'];
    if (user == null || lat is! double || lng is! double) return null;
    for (final lokasi in widget.state.lokasis) {
      if (lokasi.userId == user.id &&
          (lokasi.latitude - lat).abs() < 0.0001 &&
          (lokasi.longitude - lng).abs() < 0.0001) {
        return lokasi;
      }
    }
    return null;
  }

  void _selectQuickLocation(Map<String, dynamic> item) {
    setState(() {
      _mapCenterLat = item['lat'] as double;
      _mapCenterLng = item['lng'] as double;
      _activeLocationTitle = item['label'] as String;
      _activeLocationSubtitle = item['sub'] as String;
      _selectedPoint = item;
      _showSearchResultCard = true;
      _searchController.text = item['label'] as String;
    });
    widget.state.addSearchHistory(item['label'] as String);
  }

  void _onSearchSubmitted(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return;

    widget.state.addSearchHistory(query);

    final matchedQuick = _quickChips.firstWhere(
      (chip) => (chip['label'] as String).toLowerCase().contains(q),
      orElse: () => <String, dynamic>{},
    );

    if (matchedQuick.isNotEmpty) {
      _selectQuickLocation(matchedQuick);
      return;
    }

    final matchedSaved = widget.state.lokasis.firstWhere(
      (lokasi) =>
          lokasi.namaLokasi.toLowerCase().contains(q) ||
          lokasi.kategori.toLowerCase().contains(q),
      orElse: () => LokasiModel(
        id: '',
        userId: '',
        namaLokasi: '',
        latitude: 0,
        longitude: 0,
        deskripsi: '',
      ),
    );

    if (matchedSaved.id.isNotEmpty) {
      setState(() {
        _mapCenterLat = matchedSaved.latitude;
        _mapCenterLng = matchedSaved.longitude;
        _activeLocationTitle = matchedSaved.namaLokasi;
        _activeLocationSubtitle =
            '${matchedSaved.kategori} | ${matchedSaved.latitude.toStringAsFixed(4)}, ${matchedSaved.longitude.toStringAsFixed(4)}';
        _selectedPoint = {
          'label': matchedSaved.namaLokasi,
          'lat': matchedSaved.latitude,
          'lng': matchedSaved.longitude,
          'kat': matchedSaved.kategori,
          'desc': matchedSaved.deskripsi,
          'savedId': matchedSaved.id,
        };
        _showSearchResultCard = true;
      });
      return;
    }

    setState(() {
      _mapCenterLat = -6.9025;
      _mapCenterLng = 107.6187;
      _activeLocationTitle = query;
      _activeLocationSubtitle = 'Hasil Nominatim | -6,9025, 107,6187';
      _selectedPoint = {
        'label': query,
        'lat': _mapCenterLat,
        'lng': _mapCenterLng,
        'kat': 'Lainnya',
        'desc': 'Hasil pencarian OpenStreetMap Nominatim untuk: "$query".',
      };
      _showSearchResultCard = true;
    });
  }

  Future<void> _triggerGpsLocation() async {
    final allowed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Izinkan akses lokasi?'),
        content: const Text(
          'GPS bersifat opsional (BR-11). Jika ditolak, pencarian dan fitur lain tetap dapat digunakan.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            key: const Key('gps_deny'),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tolak'),
          ),
          ElevatedButton(
            key: const Key('gps_allow'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.primaryTeal,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Izinkan'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (allowed != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Izin lokasi ditolak. Fitur peta dan pencarian tetap dapat digunakan (BR-11).',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _mapCenterLat = -6.1895;
      _mapCenterLng = 106.7681;
      _activeLocationTitle = 'Posisi Anda Saat Ini';
      _activeLocationSubtitle = 'Jakarta Barat | -6,1895, 106,7681';
      _selectedPoint = {
        'label': 'Posisi Anda Saat Ini',
        'lat': -6.1895,
        'lng': 106.7681,
        'kat': 'Kota',
        'desc': 'Koordinat terdeteksi melalui GPS satelit (fitur opsional).',
      };
      _showSearchResultCard = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GPS: Posisi Anda berhasil dipusatkan pada peta!'),
        backgroundColor: SplwTheme.primaryTeal,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openSaveBottomSheet() {
    if (!widget.state.isLoggedIn) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Login Diperlukan (BR-01)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Pengunjung wajib masuk sebelum dapat menyimpan lokasi ke daftar favorit Anda.',
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              key: const Key('map_save_login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SplwTheme.primaryTeal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(ctx);
                widget.onRequireLogin();
              },
              child: const Text('Masuk'),
            ),
          ],
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FormLokasiBottomSheet(
          initialNama: _selectedPoint?['label'] as String?,
          initialLat: _selectedPoint?['lat'] as double? ?? _mapCenterLat,
          initialLng: _selectedPoint?['lng'] as double? ?? _mapCenterLng,
          initialKategori: _selectedPoint?['kat'] as String?,
          onSave: (nama, lat, lng, desc, kategori) {
            final error = widget.state.saveLokasi(
              nama: nama,
              lat: lat,
              lng: lng,
              deskripsi: desc,
              kategori: kategori,
            );
            if (error == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lokasi "$nama" berhasil disimpan!'),
                  backgroundColor: SplwTheme.successGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return error;
          },
        );
      },
    );
  }

  void _openSearchHistorySheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SplwTheme.cardOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final history = widget.state.searchHistory;
            final textPrimary = SplwTheme.textPrimaryOf(context);
            final textSecondary = SplwTheme.textSecondaryOf(context);
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: SplwTheme.borderOf(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Pencarian',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      if (history.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            widget.state.clearSearchHistory();
                            setModalState(() {});
                          },
                          child: const Text(
                            'Hapus semua',
                            style: TextStyle(
                              color: SplwTheme.primaryTeal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 12),
                  if (history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'Belum ada riwayat pencarian',
                          style: TextStyle(color: textSecondary),
                        ),
                      ),
                    )
                  else
                    ...history.map((item) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.history,
                          size: 20,
                          color: textSecondary,
                        ),
                        title: Text(
                          item,
                          style: TextStyle(fontSize: 14, color: textPrimary),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, size: 16, color: textSecondary),
                          onPressed: () {
                            widget.state.removeSearchHistory(item);
                            setModalState(() {});
                          },
                        ),
                        onTap: () {
                          Navigator.pop(ctx);
                          _searchController.text = item;
                          _onSearchSubmitted(item);
                        },
                      );
                    }),
                  const SizedBox(height: 12),
                  Text(
                    'Maksimal 6 kata kunci, disimpan di perangkat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: SplwTheme.textMutedOf(context),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = SplwTheme.isDark(context);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final savedLocation = _savedLocationForPoint(_selectedPoint);

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Container(
            color: SplwTheme.primaryTeal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SPLW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Icon(Icons.more_horiz, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14, right: 8),
                        child: Icon(
                          Icons.search,
                          color: textSecondary,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: const Key('map_search_field'),
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: _onSearchSubmitted,
                          style: TextStyle(fontSize: 13, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Cari lokasi wisata...',
                            hintStyle: TextStyle(
                              color: SplwTheme.textMutedOf(context),
                              fontSize: 13,
                            ),
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        key: const Key('map_history'),
                        icon: Icon(
                          Icons.history,
                          color: textSecondary,
                          size: 20,
                        ),
                        tooltip: 'Riwayat Pencarian (S-11)',
                        onPressed: _openSearchHistorySheet,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickChips.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (ctx, index) {
                      final chip = _quickChips[index];
                      final isSelected =
                          chip['label'] == _activeLocationTitle;
                      return GestureDetector(
                        key: Key('quick_chip_${chip['label']}'),
                        onTap: () => _selectQuickLocation(chip),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? SplwTheme.primaryDark : card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? SplwTheme.primaryDark
                                  : border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              chip['label'] as String,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!widget.state.isLoggedIn) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    key: const Key('map_login_banner'),
                    onTap: widget.onRequireLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Masuk atau daftar untuk menyimpan lokasi',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: textSecondary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: isDark ? const Color(0xFF0B1220) : const Color(0xFFE5EDE8),
                  child: CustomPaint(
                    painter: _OsmRealisticMapPainter(isDark: isDark),
                    size: Size.infinite,
                  ),
                ),
              ),
              Positioned(
                bottom: 120,
                left: 100,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _activeLocationTitle,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.location_on,
                      size: 44,
                      color: SplwTheme.primaryTeal,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: _showSearchResultCard ? 130 : 20,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      key: const Key('map_gps'),
                      heroTag: 'map_gps',
                      backgroundColor: card,
                      foregroundColor: textPrimary,
                      elevation: 3,
                      onPressed: _triggerGpsLocation,
                      child: const Icon(Icons.my_location, size: 20),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      key: const Key('map_zoom'),
                      heroTag: 'map_zoom',
                      backgroundColor: card,
                      foregroundColor: textPrimary,
                      elevation: 3,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Peta dipusatkan ke seluruh wilayah Indonesia.',
                            ),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Icon(Icons.crop_free, size: 20),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 12,
                bottom: _showSearchResultCard ? 130 : 16,
                child: GestureDetector(
                  key: const Key('map_osm_attribution'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Atribusi Peta'),
                        content: const Text(
                          '© OpenStreetMap contributors\nData peta pada prototipe ini disimulasikan dengan CustomPaint.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: card.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(fontSize: 9.5, color: textSecondary),
                    ),
                  ),
                ),
              ),
              if (_showSearchResultCard)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: SplwTheme.primaryTeal,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _activeLocationTitle,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _activeLocationSubtitle,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                key: const Key('map_save_button'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: SplwTheme.primaryTeal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  elevation: 0,
                                ),
                                onPressed: _openSaveBottomSheet,
                                child: const Text(
                                  'Simpan Lokasi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                key: const Key('map_detail_button'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: SplwTheme.primaryTeal,
                                  side: const BorderSide(
                                    color: SplwTheme.primaryTeal,
                                    width: 1.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(
                                        state: widget.state,
                                        nama: _activeLocationTitle,
                                        latitude: _selectedPoint?['lat']
                                                as double? ??
                                            _mapCenterLat,
                                        longitude: _selectedPoint?['lng']
                                                as double? ??
                                            _mapCenterLng,
                                        kategori: _selectedPoint?['kat']
                                                as String? ??
                                            'Budaya',
                                        deskripsi: _selectedPoint?['desc']
                                                as String? ??
                                            'Informasi destinasi wisata unggulan nusantara.',
                                        savedId: savedLocation?.id ??
                                            _selectedPoint?['savedId']
                                                as String?,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Detail',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OsmRealisticMapPainter extends CustomPainter {
  final bool isDark;

  const _OsmRealisticMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final background =
        isDark ? const Color(0xFF0B1220) : const Color(0xFFF1F5F3);
    final park = isDark ? const Color(0xFF12261F) : const Color(0xFFD9EADB);
    final road = isDark ? const Color(0xFF1E293B) : Colors.white;
    final roadBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFD4DDD6);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = background,
    );

    final parkPaint = Paint()..color = park;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.25, size.height * 0.2),
        width: 140,
        height: 80,
      ),
      parkPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.65),
        width: 180,
        height: 110,
      ),
      parkPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.2, size.height * 0.75),
        width: 120,
        height: 70,
      ),
      parkPaint,
    );

    final roadPaint = Paint()
      ..color = road
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final roadBorderPaint = Paint()
      ..color = roadBorder
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.5, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.25);

    final path2 = Path()
      ..moveTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.5, size.height * 0.45)
      ..lineTo(size.width * 0.7, size.height);

    final path3 = Path()
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width * 0.6, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.85);

    canvas.drawPath(path1, roadBorderPaint);
    canvas.drawPath(path1, roadPaint);
    canvas.drawPath(path2, roadBorderPaint);
    canvas.drawPath(path2, roadPaint);
    canvas.drawPath(path3, roadBorderPaint);
    canvas.drawPath(path3, roadPaint);

    final pinPaint = Paint()..color = SplwTheme.primaryTeal.withValues(alpha: 0.8);
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.45),
      6,
      pinPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.35),
      6,
      pinPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.6),
      7,
      pinPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _OsmRealisticMapPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
