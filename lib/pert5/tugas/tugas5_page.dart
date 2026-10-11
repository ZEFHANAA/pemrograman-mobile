import 'package:flutter/material.dart';

class Tugas5Page extends StatefulWidget {
  const Tugas5Page({super.key});

  @override
  State<Tugas5Page> createState() => _Tugas5PageState();
}

class _Tugas5PageState extends State<Tugas5Page> {
  String _deliveryOption = 'Next day ground delivery';
  final _nameController = TextEditingController(text: 'Zefhana Ananda');
  final _addressController = TextEditingController(text: 'Jakarta Barat, DKI Jakarta');
  final _phoneController = TextEditingController(text: '081234567890');
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pesanan Berhasil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${_nameController.text}'),
            Text('Alamat: ${_addressController.text}'),
            Text('No. Telp: ${_phoneController.text}'),
            const SizedBox(height: 8),
            Text('Metode Pengiriman: $_deliveryOption', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Activity'),
        backgroundColor: const Color(0xFFD81B60),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFCE7F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zefhana Ananda (20240801047)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF831843)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tugas Modul 5: Formulir Pemesanan Droid Cafe (Radio Buttons & Controls)',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9D174D)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form inputs
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                isDense: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                isDense: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                isDense: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Catatan pesanan tambahan...',
                isDense: true,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 24),

            // Radio Button Delivery Options sesuai DroidCafe standard
            const Text(
              'Choose a delivery method:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            RadioListTile<String>(
              title: const Text('Same day messenger service'),
              value: 'Same day messenger service',
              groupValue: _deliveryOption,
              dense: true,
              activeColor: const Color(0xFFD81B60),
              onChanged: (val) => setState(() => _deliveryOption = val!),
            ),
            RadioListTile<String>(
              title: const Text('Next day ground delivery'),
              value: 'Next day ground delivery',
              groupValue: _deliveryOption,
              dense: true,
              activeColor: const Color(0xFFD81B60),
              onChanged: (val) => setState(() => _deliveryOption = val!),
            ),
            RadioListTile<String>(
              title: const Text('Pick up'),
              value: 'Pick up',
              groupValue: _deliveryOption,
              dense: true,
              activeColor: const Color(0xFFD81B60),
              onChanged: (val) => setState(() => _deliveryOption = val!),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.check_circle),
                label: const Text('SUBMIT ORDER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD81B60),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
