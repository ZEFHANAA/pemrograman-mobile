import 'package:flutter/material.dart';

import '../data/tabungku_repository.dart';
import '../models/aktivitas_tabungan.dart';

class AktivitasTabunganFormPage extends StatefulWidget {
  const AktivitasTabunganFormPage({super.key, this.kegiatan});
  final AktivitasTabungan? kegiatan;

  @override
  State<AktivitasTabunganFormPage> createState() => _AktivitasTabunganFormPageState();
}

class _AktivitasTabunganFormPageState extends State<AktivitasTabunganFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late DateTime _date;
  late JenisKeuangan _type;
  late String _category;
  String _catatan = '';
  bool _saving = false;

  static const _categories = ['Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    final existing = widget.kegiatan;
    _titleController = TextEditingController(text: existing?.judul ?? '');
    _amountController = TextEditingController(text: existing == null || existing.nominal == 0 ? '' : '${existing.nominal}');
    _date = DateTime.tryParse(existing?.tanggal ?? '') ?? DateTime.now();
    _type = existing?.tipe ?? JenisKeuangan.tanpa;
    _category = _categories.contains(existing?.kategori) ? existing!.kategori : _categories.first;
    _catatan = existing?.catatan ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _dateText(DateTime value) => '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final amount = _type == JenisKeuangan.tanpa
        ? 0
        : int.parse(_amountController.text.replaceAll('.', '').replaceAll(',', ''));
    final activity = AktivitasTabungan(
      id: widget.kegiatan?.id,
      judul: _titleController.text.trim(),
      tanggal: _dateText(_date),
      selesai: widget.kegiatan?.selesai ?? false,
      tipe: _type,
      nominal: amount,
      kategori: _type == JenisKeuangan.pengeluaran ? _category : '-',
      catatan: _catatan,
    );
    try {
      if (widget.kegiatan == null) {
        await TabungKuRepository.instance.tambah(activity);
      } else {
        await TabungKuRepository.instance.ubah(activity);
      }
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.kegiatan == null ? 'Tambah Aktivitas' : 'Ubah Aktivitas')),
        body: Form(
          key: _formKey,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nama kegiatan', border: OutlineInputBorder(), prefixIcon: Icon(Icons.event_note)),
              validator: (value) => value == null || value.trim().isEmpty ? 'Nama kegiatan wajib diisi' : null,
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(onPressed: _pickDate, icon: const Icon(Icons.calendar_month), label: Text('Tanggal: ${_dateText(_date)}')),
            const SizedBox(height: 14),
            DropdownButtonFormField<JenisKeuangan>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Jenis kegiatan', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: JenisKeuangan.tanpa, child: Text('Tidak melibatkan uang')),
                DropdownMenuItem(value: JenisKeuangan.pemasukan, child: Text('Pemasukan')),
                DropdownMenuItem(value: JenisKeuangan.pengeluaran, child: Text('Pengeluaran')),
              ],
              onChanged: (value) { if (value != null) setState(() => _type = value); },
            ),
            if (_type != JenisKeuangan.tanpa) ...[
              const SizedBox(height: 14),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rupiah)', border: OutlineInputBorder(), prefixText: 'Rp '),
                validator: (value) {
                  final amount = int.tryParse((value ?? '').replaceAll('.', '').replaceAll(',', ''));
                  return amount == null || amount <= 0 ? 'Nominal harus berupa angka lebih dari 0' : null;
                },
              ),
            ],
            if (_type == JenisKeuangan.pengeluaran) ...[
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Kategori pengeluaran', border: OutlineInputBorder()),
                items: _categories.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                onChanged: (value) { if (value != null) setState(() => _category = value); },
              ),
            ],
            const SizedBox(height: 14),
            TextFormField(
              initialValue: widget.kegiatan?.catatan ?? '',
              decoration: const InputDecoration(labelText: 'Catatan (opsional)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.note_alt_outlined)),
              maxLines: 3,
              onChanged: (value) => _catatan = value.trim(),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
              label: Text(_saving ? 'Menyimpan...' : 'Simpan Aktivitas'),
            ),
          ]),
        ),
      );
}
