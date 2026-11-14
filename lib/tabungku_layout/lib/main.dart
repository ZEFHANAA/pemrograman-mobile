import 'package:flutter/material.dart';

const Color _navy = Color(0xFF0B1F3A);
const Color _navyLight = Color(0xFF1E3A8A);
const Color _blue = Color(0xFF2563EB);
const Color _amber = Color(0xFFF59E0B);
const Color _amberDark = Color(0xFFB45309);
const Color _emerald = Color(0xFF047857);
const Color _coral = Color(0xFFC2410C);
const Color _canvas = Color(0xFFF4F7FB);
const Color _ink = Color(0xFF172033);
const Color _muted = Color(0xFF667085);
const Color _border = Color(0xFFE4E7EC);
const Color _softAmber = Color(0xFFFEF3C7);

void main() {
  runApp(const TabungKuApp());
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _navy),
        scaffoldBackgroundColor: _canvas,
        appBarTheme: const AppBarTheme(
          backgroundColor: _navy,
          foregroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 76,
          centerTitle: false,
          titleSpacing: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const RingkasanPage(),
    );
  }
}

class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  static const List<_TransactionData> _transactions = [
    _TransactionData(
      title: 'Sisa gaji Oktober',
      date: '01 Nov 2026',
      amount: '+Rp 1.200.000',
      icon: Icons.work_rounded,
      isIncome: true,
    ),
    _TransactionData(
      title: 'Beli lensa kamera',
      date: '27 Okt 2026',
      amount: '-Rp 650.000',
      icon: Icons.camera_alt_rounded,
      isIncome: false,
    ),
    _TransactionData(
      title: 'Freelance desain',
      date: '21 Okt 2026',
      amount: '+Rp 800.000',
      icon: Icons.brush_rounded,
      isIncome: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul utama dan sapaan pendek.
      appBar: AppBar(
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.savings_rounded, size: 20),
            ),
          ),
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan Tabungan'),
            SizedBox(height: 2),
            Text(
              'Kelola targetmu, sedikit demi sedikit',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Notifikasi',
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 700;
            final double sidePadding = isTablet ? 32 : 16;

            // Semua ukuran layar memakai satu kolom vertikal agar isi
            // menyesuaikan lebar layar tanpa terbagi menjadi kolom kecil.
            final Widget content = Column(
              children: [
                const _BalanceCard(),
                const SizedBox(height: 16),
                _QuickActionsPanel(isTablet: isTablet),
                const SizedBox(height: 16),
                const _TransactionsPanel(),
              ],
            );

            // Area scroll menjaga layout tetap aman di layar pendek.
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(sidePadding, 16, sidePadding, 28),
              child: Center(
                child: ConstrainedBox(
                  // Di tablet konten melebar hingga 720 px lalu terpusat.
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: content,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    // Kartu utama berisi nama tabungan, saldo, target, dan progres.
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_navy, _navyLight],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -45,
              right: -25,
              child: _DecorativeCircle(size: 150, color: Color(0x14FFFFFF)),
            ),
            const Positioned(
              bottom: -50,
              left: -30,
              child: _DecorativeCircle(size: 130, color: Color(0x0DFFFFFF)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama tabungan dan status.
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          color: _amber,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tabungan Kamera',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Target utama',
                              style: TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _StatusDot(),
                            SizedBox(width: 5),
                            Text(
                              'Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  // Saldo saat ini.
                  const Text(
                    'Saldo tersedia',
                    style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Rp 4.250.000',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 31,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Target dan cincin progres.
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target tabungan',
                              style: TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Rp 12.000.000',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ProgressRing(value: 0.35),
                    ],
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

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              color: _amber,
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(color: _amber, shape: BoxShape.circle),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel({required this.isTablet});

  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    // Satu panel berisi tiga tombol aksi dalam satu Row.
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                _SectionAccent(),
                SizedBox(width: 8),
                Text(
                  'Menu Cepat',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.add_rounded,
                    label: 'Menabung',
                    color: _blue,
                    isTablet: isTablet,
                  ),
                ),
                const _ActionDivider(),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.south_west_rounded,
                    label: 'Tarik',
                    color: _coral,
                    isTablet: isTablet,
                  ),
                ),
                const _ActionDivider(),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.receipt_long_rounded,
                    label: 'Riwayat',
                    color: _amberDark,
                    isTablet: isTablet,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isTablet,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    // Ikon sedikit lebih besar di tablet agar tidak terlihat kecil.
    final double iconBoxSize = isTablet ? 52 : 40;
    final double iconSize = isTablet ? 24 : 20;
    final double labelSize = isTablet ? 13 : 12;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        child: Column(
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: iconSize),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _ink,
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionDivider extends StatelessWidget {
  const _ActionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 42, color: _border);
  }
}

class _TransactionsPanel extends StatelessWidget {
  const _TransactionsPanel();

  @override
  Widget build(BuildContext context) {
    // Semua transaksi dibungkus dalam satu Card dengan pemisah.
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: _border),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Aktivitas Terakhir',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _softAmber,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    '3 transaksi',
                    style: TextStyle(
                      color: _amberDark,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            for (var i = 0; i < RingkasanPage._transactions.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: _border),
              _TransactionRow(data: RingkasanPage._transactions[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.data});

  final _TransactionData data;

  @override
  Widget build(BuildContext context) {
    final Color accent = data.isIncome ? _emerald : _coral;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(data.icon, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.date,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data.amount,
            style: TextStyle(
              color: accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionAccent extends StatelessWidget {
  const _SectionAccent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 18,
      decoration: BoxDecoration(
        color: _amber,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _TransactionData {
  const _TransactionData({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
    required this.isIncome,
  });

  final String title;
  final String date;
  final String amount;
  final IconData icon;
  final bool isIncome;
}
