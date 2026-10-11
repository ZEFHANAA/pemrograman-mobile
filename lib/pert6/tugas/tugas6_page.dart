import 'package:flutter/material.dart';
import '../praktikum/praktikum6_page.dart';

class Tugas6Page extends StatelessWidget {
  const Tugas6Page({super.key});

  final List<Map<String, dynamic>> _sports = const [
    {
      'title': 'Badminton',
      'news': 'Badminton tournament season is starting now. Check out the match schedules and score updates.',
      'color': Color(0xFF10B981),
      'icon': Icons.sports_tennis,
    },
    {
      'title': 'Basketball',
      'news': 'National basketball league playoffs are heating up with intense competition.',
      'color': Color(0xFFF59E0B),
      'icon': Icons.sports_basketball,
    },
    {
      'title': 'Bowling',
      'news': 'Weekly bowling championship results and high score achievements from local leagues.',
      'color': Color(0xFF8B5CF6),
      'icon': Icons.sports_volleyball,
    },
    {
      'title': 'Soccer / Football',
      'news': 'Premier league derby match score summaries and standings.',
      'color': Color(0xFF3B82F6),
      'icon': Icons.sports_soccer,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Me - Sports News'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _sports.length,
        itemBuilder: (context, index) {
          final sport = _sports[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  height: 110,
                  width: double.infinity,
                  color: sport['color'] as Color,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        sport['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        sport['icon'] as IconData,
                        size: 48,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ],
                  ),
                ),
                // Card Body
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport['news'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sports News & Highlights',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Praktikum6Page(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.scoreboard, size: 16),
                            label: const Text('BUKA SCOREKEEPER'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: sport['color'] as Color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Praktikum6Page(),
            ),
          );
        },
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.scoreboard),
        label: const Text('Catat Skor Sekarang'),
      ),
    );
  }
}
