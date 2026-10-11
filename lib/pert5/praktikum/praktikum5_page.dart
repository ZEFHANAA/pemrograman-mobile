import 'package:flutter/material.dart';

class Praktikum5Page extends StatefulWidget {
  const Praktikum5Page({super.key});

  @override
  State<Praktikum5Page> createState() => _Praktikum5PageState();
}

class _Praktikum5PageState extends State<Praktikum5Page> {
  String _selectedOrder = 'Belum ada pesanan';

  void _displayToast(String message) {
    setState(() {
      _selectedOrder = message;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Droid Cafe'),
        backgroundColor: const Color(0xFFD81B60),
        foregroundColor: Colors.white,
        actions: [
          // Action icon shortcut
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Order',
            onPressed: () => _displayToast('You selected Order.'),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Status',
            onPressed: () => _displayToast('You selected Status.'),
          ),
          // Overflow Menu (titik tiga) sesuai Modul 5 Hal 15-18
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _displayToast('You selected $value.'),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'Order', child: Text('Order')),
              const PopupMenuItem(value: 'Status', child: Text('Status')),
              const PopupMenuItem(value: 'Favorites', child: Text('Favorites')),
              const PopupMenuItem(value: 'Contact', child: Text('Contact')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title intro_text: "Droid Desserts" / "Pilihan Makanan"
            const Text(
              'Droid Desserts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ketuk salah satu gambar makanan untuk memilih pesanan:',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),

            // Item 1: Donut
            _buildDessertItem(
              name: 'Donuts',
              description: 'Donuts are glazed and sprinkled with candy.',
              color: const Color(0xFFF472B6),
              icon: Icons.donut_large,
              onTap: () => _displayToast('You ordered a donut.'),
            ),
            const SizedBox(height: 16),

            // Item 2: Ice Cream
            _buildDessertItem(
              name: 'Ice Cream Sandwiches',
              description: 'Ice cream sandwiches have chocolate wafers and vanilla filling.',
              color: const Color(0xFF38BDF8),
              icon: Icons.icecream,
              onTap: () => _displayToast('You ordered an ice cream sandwich.'),
            ),
            const SizedBox(height: 16),

            // Item 3: FroYo
            _buildDessertItem(
              name: 'FroYo',
              description: 'FroYo is premium self-serve frozen yogurt.',
              color: const Color(0xFFA78BFA),
              icon: Icons.cake,
              onTap: () => _displayToast('You ordered a FroYo.'),
            ),

            const SizedBox(height: 28),

            // Order Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFCE7F3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF472B6)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long, color: Color(0xFFD81B60)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Status Terpilih: $_selectedOrder',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF831843),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD81B60),
        foregroundColor: Colors.white,
        tooltip: 'Keranjang Pesanan',
        onPressed: () => _displayToast('Membuka detail keranjang pesanan...'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Widget _buildDessertItem({
    required String name,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular image avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.18),
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(width: 16),
            // Descriptions sesuai Modul 5 Hal 14
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF475569),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
