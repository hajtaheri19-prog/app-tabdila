import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';

class SimonSaysPage extends StatefulWidget {
  const SimonSaysPage({super.key});

  @override
  State<SimonSaysPage> createState() => _SimonSaysPageState();
}

class _SimonSaysPageState extends State<SimonSaysPage> {
  final List<int> _sequence = [];
  final List<int> _userSequence = [];
  int _score = 0;
  int _highScore = 0;
  bool _isPlayingSequence = false;
  bool _isGameOver = false;
  int? _activePad;
  final Random _random = Random();

  final List<Color> _padColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  final List<Color> _padActiveColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
  ];

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _sequence.clear();
      _userSequence.clear();
      _score = 0;
      _isGameOver = false;
    });
    _nextRound();
  }

  void _nextRound() {
    _userSequence.clear();
    _sequence.add(_random.nextInt(4));
    _playSequence();
  }

  Future<void> _playSequence() async {
    setState(() => _isPlayingSequence = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    for (int pad in _sequence) {
      if (!mounted) return;
      setState(() => _activePad = pad);
      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _activePad = null);
      await Future.delayed(const Duration(milliseconds: 200));
    }
    setState(() => _isPlayingSequence = false);
  }

  void _onPadTap(int index) {
    if (_isPlayingSequence || _isGameOver) return;

    setState(() {
      _activePad = index;
      _userSequence.add(index);
    });

    // Flash the pad
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _activePad = null);
    });

    // Check if correct
    if (_userSequence.last != _sequence[_userSequence.length - 1]) {
      _gameOver();
    } else if (_userSequence.length == _sequence.length) {
      setState(() {
        _score++;
        if (_score > _highScore) _highScore = _score;
      });
      Future.delayed(const Duration(milliseconds: 800), _nextRound);
    }
  }

  void _gameOver() {
    setState(() => _isGameOver = true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = const Color(0xFF8B5CF6);
    final background =
        isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6);
    final surface = isDark ? const Color(0xFF1F2937) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark, primary),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildScoreBoard(isDark, surface, primary),
                ),
                _buildInfoBanner(isDark),
                const Spacer(),
                _buildGamePads(isDark),
                const Spacer(),
              ],
            ),
          ),
          if (_isGameOver) _buildGameOverOverlay(isDark, surface, primary),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close,
                color: isDark ? Colors.white70 : Colors.black54),
          ),
          Row(
            children: [
              Text(
                'بازی سایمون',
                style: GoogleFonts.vazirmatn(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.games, color: primary),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(bool isDark, Color surface, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('امتیاز',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: Colors.grey)),
                Text(_score.toString(),
                    style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: primary)),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.withOpacity(0.2)),
          Expanded(
            child: Column(
              children: [
                Text('رکورد',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: Colors.grey)),
                Text(_highScore.toString(),
                    style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(
            'الگوی رنگ‌ها را به خاطر بسپارید و تکرار کنید.',
            style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: isDark ? Colors.blue[100] : Colors.blue[800]),
          ),
        ],
      ),
    );
  }

  Widget _buildGamePads(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 300,
            height: 300,
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.zero,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(4, (index) {
                return _buildPad(index, isDark);
              }),
            ),
          ),
        ),
        _buildCenterIndicator(),
      ],
    );
  }

  Widget _buildPad(int index, bool isDark) {
    final isActive = _activePad == index;
    final color = _padColors[index];
    final activeColor = _padActiveColors[index];

    BorderRadius borderRadius;
    switch (index) {
      case 0:
        borderRadius = const BorderRadius.only(topRight: Radius.circular(150));
        break;
      case 1:
        borderRadius = const BorderRadius.only(topLeft: Radius.circular(150));
        break;
      case 2:
        borderRadius =
            const BorderRadius.only(bottomRight: Radius.circular(150));
        break;
      case 3:
        borderRadius =
            const BorderRadius.only(bottomLeft: Radius.circular(150));
        break;
      default:
        borderRadius = BorderRadius.zero;
    }

    return GestureDetector(
      onTapDown: (_) => _onPadTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isActive ? activeColor : color.withOpacity(isDark ? 0.6 : 0.4),
          borderRadius: borderRadius,
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildCenterIndicator() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.psychology, color: Color(0xFF8B5CF6)),
          Text(
            _isPlayingSequence ? 'ببینید' : 'نوبت شما',
            style: GoogleFonts.vazirmatn(
                fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverOverlay(bool isDark, Color surface, Color primary) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sentiment_very_dissatisfied,
                  color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'باختی!',
                style: GoogleFonts.vazirmatn(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'امتیاز شما: $_score',
                style: GoogleFonts.vazirmatn(fontSize: 18),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _startNewGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('دوباره سعی کن',
                    style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
