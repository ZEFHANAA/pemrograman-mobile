import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/splw_models.dart';
import '../state/splw_state.dart';
import '../theme/splw_theme.dart';
import '../widgets/form_lokasi_sheet.dart';

class DetailScreen extends StatefulWidget {
  final SplwState state;
  final String nama;
  final double latitude;
  final double longitude;
  final String kategori;
  final String deskripsi;
  final String? savedId;

  const DetailScreen({
    super.key,
    required this.state,
    required this.nama,
    required this.latitude,
    required this.longitude,
    required this.kategori,
    required this.deskripsi,
    this.savedId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String _currentNama;
  late double _currentLat;
  late double _currentLng;
  late String _currentKat;
  late String _currentDesc;

  @override
  void initState() {
    super.initState();
    _currentNama = widget.nama;
    _currentLat = widget.latitude;
    _currentLng = widget.longitude;
    _currentKat = widget.kategori;
    _currentDesc = widget.deskripsi;
  }

  LokasiModel? get _savedItem {
    if (widget.savedId == null) return null;
    for (final lokasi in widget.state.lokasis) {
      if (lokasi.id == widget.savedId) return lokasi;
    }
    return null;
  }

  void _copyCoordinate() {
    final coordStr =
        '${_currentLat.toStringAsFixed(4)}, ${_currentLng.toStringAsFixed(4)}';
    Clipboard.setData(ClipboardData(text: coordStr));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Koordinat ($coordStr) disalin ke clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openGoogleMaps() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Membuka rute ke https://www.google.com/maps/dir/?api=1&destination=$_currentLat,$_currentLng',
        ),
        backgroundColor: SplwTheme.primaryTeal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showShareDialog(LokasiModel item) {
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
            final currentItem = widget.state.lokasis.firstWhere(
              (l) => l.id == item.id,
              orElse: () => item,
            );
            final isShared = currentItem.shareToken != null;
            final url = isShared
                ? 'https://splw.app/lokasi/${currentItem.shareToken}'
                : '';
            final textPrimary = SplwTheme.textPrimaryOf(context);
            final textSecondary = SplwTheme.textSecondaryOf(context);

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                        'Bagikan Lokasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isShared
                              ? SplwTheme.successGreen
                              : SplwTheme.textMutedOf(context),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          isShared ? 'Tautan aktif' : 'Tautan nonaktif',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tautan publik memungkinkan siapa pun melihat detail lokasi ini tanpa login. Anda dapat mencabut tautan kapan saja (BR-14).',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (isShared) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: SplwTheme.softPrimaryOf(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        url,
                        key: const Key('share_url_text'),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: textPrimary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      key: const Key('share_copy_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SplwTheme.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: url));
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Tautan berhasil disalin ke clipboard!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Salin Tautan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      key: const Key('share_revoke_button'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SplwTheme.dangerRed,
                        side: const BorderSide(
                          color: SplwTheme.dangerRed,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        final error =
                            widget.state.revokeShareLokasi(currentItem.id);
                        if (error != null) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: SplwTheme.dangerRed,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        setModalState(() {});
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Tautan publik dicabut (BR-14).'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Cabut Tautan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ] else
                    ElevatedButton(
                      key: const Key('share_create_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SplwTheme.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {
                        final error =
                            widget.state.enableShareLokasi(currentItem.id);
                        if (error != null) {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: SplwTheme.dangerRed,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        setModalState(() {});
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Tautan publik berhasil dibuat!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text(
                        'Buat Tautan Publik',
                        style: TextStyle(fontWeight: FontWeight.bold),
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

  void _openEditSheet(LokasiModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FormLokasiBottomSheet(
          lokasiToEdit: item,
          onSave: (nama, lat, lng, desc, kat) {
            final error = widget.state.updateLokasi(
              id: item.id,
              nama: nama,
              lat: lat,
              lng: lng,
              deskripsi: desc,
              kategori: kat,
            );
            if (error != null) return error;

            setState(() {
              _currentNama = nama;
              _currentLat = lat;
              _currentLng = lng;
              _currentDesc = desc;
              _currentKat = kat;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lokasi "$nama" berhasil diperbarui!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return null;
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(LokasiModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus lokasi?'),
        content: Text(
          '"${item.namaLokasi}" akan dihapus dari daftar tersimpan. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            key: const Key('detail_delete_confirm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: SplwTheme.dangerRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    final messenger = ScaffoldMessenger.of(context);
    final error = widget.state.deleteLokasi(item.id);
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: SplwTheme.dangerRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Lokasi "${item.namaLokasi}" berhasil dihapus.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _savedItem;
    final user = widget.state.currentUser;
    final isOwner =
        item != null && (item.userId == user?.id || widget.state.isAdmin);
    final katColor = SplwTheme.getCategoryColor(_currentKat);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final card = SplwTheme.cardOf(context);
    final border = SplwTheme.borderOf(context);
    final isDark = SplwTheme.isDark(context);

    return Scaffold(
      backgroundColor: SplwTheme.surfaceOf(context),
      appBar: AppBar(
        title: const Text('Detail Lokasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF12261F)
                    : const Color(0xFFDCE7E1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: _MountainLandscapePainter(isDark: isDark),
                    size: const Size(double.infinity, 140),
                  ),
                  Positioned(
                    top: 14,
                    child: Text(
                      'THUMBNAIL WIKIPEDIA',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _currentNama,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: katColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _currentKat,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Koordinat',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_currentLat.toStringAsFixed(4)}, ${_currentLng.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 13, color: textSecondary),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  key: const Key('detail_copy_coordinate'),
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
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                  onPressed: _copyCoordinate,
                  icon: const Icon(Icons.copy, size: 14),
                  label: const Text('Salin', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _currentDesc.isNotEmpty
                  ? _currentDesc
                  : 'Tidak ada deskripsi tersedia.',
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0B1220)
                    : const Color(0xFFE5EDE8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    painter: _MiniMapPainter(isDark: isDark),
                    size: Size.infinite,
                  ),
                  Center(
                    child: Icon(Icons.location_on, color: katColor, size: 32),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: card.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        '© OpenStreetMap contributors',
                        style: TextStyle(fontSize: 9, color: textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('detail_google_maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: SplwTheme.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
              ),
              onPressed: _openGoogleMaps,
              child: const Text(
                'Buka di Google Maps',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const Key('detail_share_button'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(color: border, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {
                      if (item == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Simpan lokasi terlebih dahulu untuk membagikan tautan publik.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      if (!isOwner) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Hanya pemilik yang dapat membagikan lokasi ini.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      _showShareDialog(item);
                    },
                    child: const Text(
                      'Bagikan',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    key: const Key('detail_edit_button'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textPrimary,
                      side: BorderSide(color: border, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: isOwner
                        ? () => _openEditSheet(item)
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Hanya pemilik yang dapat mengubah lokasi.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    child: const Text(
                      'Ubah',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    key: const Key('detail_delete_button'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SplwTheme.dangerRed,
                      side: BorderSide(color: border, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: isOwner
                        ? () => _confirmDelete(item)
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Hanya pemilik yang dapat menghapus lokasi.',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    child: const Text(
                      'Hapus',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: SplwTheme.dangerRed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Ubah dan Hapus hanya untuk pemilik lokasi',
                style: TextStyle(
                  fontSize: 11,
                  color: SplwTheme.textMutedOf(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MountainLandscapePainter extends CustomPainter {
  final bool isDark;

  const _MountainLandscapePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final mountainPaint = Paint()
      ..color = isDark ? const Color(0xFF1E3A32) : const Color(0xFFBACCC3);
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..lineTo(size.width * 0.6, size.height * 0.75)
      ..lineTo(size.width * 0.85, size.height * 0.35)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, mountainPaint);
  }

  @override
  bool shouldRepaint(covariant _MountainLandscapePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

class _MiniMapPainter extends CustomPainter {
  final bool isDark;

  const _MiniMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.7);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _MiniMapPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
