import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({super.key});

  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  static const int columns = 4;
  static const int rows = 5;
  static const int totalCards = columns * rows;

  late List<CardData> _cards;
  int? _firstSelectedIndex;
  bool _isProcessing = false;
  int _moves = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _isGameOver = false;

  final List<IconData> _allIcons = [
    Icons.memory,
    Icons.card_giftcard,
    Icons.psychology,
    Icons.favorite,
    Icons.star,
    Icons.rocket_launch,
    Icons.lightbulb,
    Icons.pets,
    Icons.directions_car,
    Icons.anchor,
  ];

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setupGame() {
    _timer?.cancel();
    _seconds = 0;
    _moves = 0;
    _isGameOver = false;
    _firstSelectedIndex = null;
    _isProcessing = false;

    // We need 10 pairs for 20 cards
    List<IconData> gameIcons = List.from(_allIcons);
    gameIcons.shuffle();
    List<IconData> pairs = [];
    for (int i = 0; i < totalCards ~/ 2; i++) {
      pairs.add(gameIcons[i]);
      pairs.add(gameIcons[i]);
    }
    pairs.shuffle();

    _cards = pairs.map((icon) => CardData(icon: icon)).toList();
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isGameOver) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cards[index].isFlipped || _cards[index].isMatched)
      return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
    } else {
      _moves++;
      int secondIndex = index;
      if (_cards[_firstSelectedIndex!].icon == _cards[secondIndex].icon) {
        // Match found
        setState(() {
          _cards[_firstSelectedIndex!].isMatched = true;
          _cards[secondIndex].isMatched = true;
          _firstSelectedIndex = null;

          if (_cards.every((card) => card.isMatched)) {
            _isGameOver = true;
            _timer?.cancel();
          }
        });
      } else {
        // No match
        _isProcessing = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _cards[_firstSelectedIndex!].isFlipped = false;
              _cards[secondIndex].isFlipped = false;
              _firstSelectedIndex = null;
              _isProcessing = false;
            });
          }
        });
      }
    }
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
          // Background Glows
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primary.withOpacity(isDark ? 0.15 : 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark, primary),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildScoreBoard(isDark, surface),
                        const SizedBox(height: 16),
                        _buildInfoBanner(isDark, primary),
                        const SizedBox(height: 24),
                        _buildGrid(isDark, primary, surface),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                _buildFooter(isDark, surface, primary),
              ],
            ),
          ),

          if (_isGameOver) _buildWinDialog(isDark, surface, primary),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close,
                color: isDark ? Colors.grey[400] : Colors.grey[600]),
            style: IconButton.styleFrom(
              backgroundColor:
                  isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            ),
          ),
          Row(
            children: [
              Text(
                'بازی حافظه',
                style: GoogleFonts.vazirmatn(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.psychology, color: primary, size: 28),
            ],
          ),
          const SizedBox(width: 48), // Balancing
        ],
      ),
    );
  }

  Widget _buildScoreBoard(bool isDark, Color surface) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
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
                Text(
                  'زمان',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  _formatTime(_seconds),
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'حرکت',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                Text(
                  _moves.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'کارت‌های مشابه را پیدا کنید تا صفحه پاک شود.',
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(bool isDark, Color primary, Color surface) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: totalCards,
      itemBuilder: (context, index) {
        return _buildCard(index, isDark, primary, surface);
      },
    );
  }

  Widget _buildCard(int index, bool isDark, Color primary, Color surface) {
    final card = _cards[index];
    final isFlipped = card.isFlipped || card.isMatched;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isFlipped ? surface : primary,
          borderRadius: BorderRadius.circular(16),
          border: isFlipped
              ? Border.all(color: primary.withOpacity(0.5), width: 2)
              : null,
          boxShadow: [
            if (!isFlipped)
              BoxShadow(
                color: primary.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            if (isFlipped && isDark)
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 15,
              ),
          ],
        ),
        child: Center(
          child: isFlipped
              ? Icon(card.icon, color: primary, size: 32)
              : const Icon(Icons.question_mark, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDark, Color surface, Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        border: Border(
            top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
      ),
      child: ElevatedButton.icon(
        onPressed: _setupGame,
        icon: const Icon(Icons.replay),
        label: const Text('شروع مجدد'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary.withOpacity(0.1),
          foregroundColor: primary,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: primary.withOpacity(0.2)),
          ),
          textStyle:
              GoogleFonts.vazirmatn(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildWinDialog(bool isDark, Color surface, Color primary) {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 40,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
              const SizedBox(height: 16),
              Text(
                'تبریک! برنده شدید',
                style: GoogleFonts.vazirmatn(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              _buildResultRow('زمان نهایی:', _formatTime(_seconds), isDark),
              const SizedBox(height: 12),
              _buildResultRow('تعداد حرکات:', _moves.toString(), isDark),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _setupGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('بازی دوباره'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class CardData {
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  CardData({
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
