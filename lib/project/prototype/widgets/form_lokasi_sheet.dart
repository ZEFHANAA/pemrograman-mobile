import 'package:flutter/material.dart';

import '../models/splw_models.dart';
import '../theme/splw_theme.dart';

class FormLokasiBottomSheet extends StatefulWidget {
  final LokasiModel? lokasiToEdit;
  final double? initialLat;
  final double? initialLng;
  final String? initialNama;
  final String? initialKategori;
  final String? Function(
    String nama,
    double lat,
    double lng,
    String deskripsi,
    String kategori,
  ) onSave;

  const FormLokasiBottomSheet({
    super.key,
    this.lokasiToEdit,
    this.initialLat,
    this.initialLng,
    this.initialNama,
    this.initialKategori,
    required this.onSave,
  });

  @override
  State<FormLokasiBottomSheet> createState() => _FormLokasiBottomSheetState();
}

class _FormLokasiBottomSheetState extends State<FormLokasiBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _deskripsiController;
  late double _lat;
  late double _lng;
  late String _selectedKategori;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final edit = widget.lokasiToEdit;
    _namaController = TextEditingController(
      text: edit?.namaLokasi ?? widget.initialNama ?? '',
    );
    _lat = edit?.latitude ?? widget.initialLat ?? -7.6079;
    _lng = edit?.longitude ?? widget.initialLng ?? 110.2038;
    _deskripsiController = TextEditingController(
      text: edit?.deskripsi ?? '',
    );
    final initial = edit?.kategori ?? widget.initialKategori;
    _selectedKategori = kPilihanKategoriInput.contains(initial)
        ? initial!
        : 'Lainnya';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final error = widget.onSave(
      _namaController.text.trim(),
      _lat,
      _lng,
      _deskripsiController.text.trim(),
      _selectedKategori,
    );
    if (error != null) {
      setState(() => _errorText = error);
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.lokasiToEdit != null;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final cardColor = SplwTheme.cardOf(context);
    final textPrimary = SplwTheme.textPrimaryOf(context);
    final textSecondary = SplwTheme.textSecondaryOf(context);
    final border = SplwTheme.borderOf(context);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Ubah Lokasi' : 'Simpan Lokasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nama Lokasi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('form_nama'),
                controller: _namaController,
                maxLength: 255,
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Candi Borobudur',
                  counterText: '',
                  hintStyle: TextStyle(
                    color: SplwTheme.textMutedOf(context),
                    fontSize: 13,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama lokasi wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              Text(
                'Koordinat (hanya-baca)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: SplwTheme.softPrimaryOf(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_lat.toStringAsFixed(4)}, ${_lng.toStringAsFixed(4)}',
                      style: TextStyle(fontSize: 13, color: textPrimary),
                    ),
                    Icon(
                      Icons.lock_outline,
                      size: 16,
                      color: textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: const Key('form_kategori'),
                    value: _selectedKategori,
                    isExpanded: true,
                    dropdownColor: cardColor,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: textSecondary,
                    ),
                    items: kPilihanKategoriInput.map((kategori) {
                      final dotColor = SplwTheme.getCategoryColor(kategori);
                      return DropdownMenuItem(
                        value: kategori,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              kategori,
                              style: TextStyle(
                                fontSize: 13,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedKategori = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                key: const Key('form_deskripsi'),
                controller: _deskripsiController,
                maxLines: 3,
                maxLength: 2000,
                style: TextStyle(fontSize: 13, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Candi Buddha terbesar...',
                  hintStyle: TextStyle(
                    color: SplwTheme.textMutedOf(context),
                    fontSize: 13,
                  ),
                ),
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Container(
                  key: const Key('form_error_text'),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SplwTheme.dangerRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: SplwTheme.dangerRed.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    _errorText!,
                    style: const TextStyle(
                      color: SplwTheme.dangerRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                key: const Key('form_save_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SplwTheme.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                onPressed: _submit,
                child: Text(
                  isEdit ? 'Perbarui Lokasi' : 'Simpan',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
