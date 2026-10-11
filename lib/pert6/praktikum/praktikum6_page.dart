import 'package:flutter/material.dart';

class Praktikum6Page extends StatefulWidget {
  const Praktikum6Page({super.key});

  @override
  State<Praktikum6Page> createState() => _Praktikum6PageState();
}

class _Praktikum6PageState extends State<Praktikum6Page> {
  int _score1 = 0;
  int _score2 = 0;
  bool _isNightMode = false;

  void _increaseScore(int team) {
    setState(() {
      if (team == 1) {
        _score1++;
      } else {
        _score2++;
      }
    });
  }

  void _decreaseScore(int team) {
    setState(() {
      if (team == 1 && _score1 > 0) {
        _score1--;
      } else if (team == 2 && _score2 > 0) {
        _score2--;
      }
    });
  }

  void _resetScore() {
    setState(() {
      _score1 = 0;
      _score2 = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isNightMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final cardColor = _isNightMode ? const Color(0xFF334155) : Colors.white;
    final textColor = _isNightMode ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = _isNightMode ? Colors.white70 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Scorekeeper'),
        backgroundColor: _isNightMode ? const Color(0xFF0F172A) : Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Latihan 1: Day & Night Mode Switch di menu bilah aplikasi
          IconButton(
            icon: Icon(_isNightMode ? Icons.wb_sunny : Icons.nightlight_round),
            tooltip: _isNightMode ? 'Day Mode' : 'Night Mode',
            onPressed: () {
              setState(() {
                _isNightMode = !_isNightMode;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isNightMode ? 'Night Mode activated' : 'Day Mode activated'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Score',
            onPressed: _resetScore,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Team 1 Section (RelativeLayout 1 / weight 1 sesuai Modul 6 Hal 7-12)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Team 1',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Minus ImageButton (ic_minus)
                        InkWell(
                          onTap: () => _decreaseScore(1),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red.shade300, width: 2),
                              color: Colors.red.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.remove, size: 36, color: Colors.red),
                          ),
                        ),
                        // Score TextView (score_1)
                        Text(
                          '$_score1',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        // Plus ImageButton (ic_plus)
                        InkWell(
                          onTap: () => _increaseScore(1),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green.shade300, width: 2),
                              color: Colors.green.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.add, size: 36, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Divider or info
            Text(
              'VS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: subTextColor,
                letterSpacing: 2,
              ),
            ),

            // Team 2 Section (RelativeLayout 2 / weight 1 sesuai Modul 6 Hal 7-12)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Team 2',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Minus ImageButton (decreaseTeam2)
                        InkWell(
                          onTap: () => _decreaseScore(2),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red.shade300, width: 2),
                              color: Colors.red.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.remove, size: 36, color: Colors.red),
                          ),
                        ),
                        // Score TextView (score_2)
                        Text(
                          '$_score2',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        // Plus ImageButton (increaseTeam2)
                        InkWell(
                          onTap: () => _increaseScore(2),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green.shade300, width: 2),
                              color: Colors.green.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.add, size: 36, color: Colors.green),
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
    );
  }
}
