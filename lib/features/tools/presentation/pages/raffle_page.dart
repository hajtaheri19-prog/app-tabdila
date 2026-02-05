import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RafflePage extends StatefulWidget {
  const RafflePage({super.key});

  @override
  State<RafflePage> createState() => _RafflePageState();
}

class _RafflePageState extends State<RafflePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _namesController = TextEditingController();
  late AnimationController _wheelController;
  late Animation<double> _wheelAnimation;
  String _lastWinner = '';
  int _participantCount = 0;
  double _currentRotation = 0.0;

  @override
  void initState() {
    super.initState();
    _wheelController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _wheelAnimation = CurvedAnimation(
      parent: _wheelController,
      curve: Curves.easeOutCubic,
    );

    _namesController.addListener(_updateParticipantCount);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    _namesController.removeListener(_updateParticipantCount);
    _namesController.dispose();
    super.dispose();
  }

  void _updateParticipantCount() {
    final names = _getParticipantList();
    setState(() {
      _participantCount = names.length;
    });
  }

  List<String> _getParticipantList() {
    return _namesController.text
        .split(RegExp(r'[\n,]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _spinWheel() {
    final names = _getParticipantList();
    if (names.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'لطفاً ابتدا نام شرکت‌کنندگان را وارد کنید',
            style: GoogleFonts.vazirmatn(),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_wheelController.isAnimating) return;

    // Pick a winner early but reveal late
    final random = Random();
    final winnerIndex = random.nextInt(names.length);
    final winner = names[winnerIndex];

    // Determine target rotation (at least 5 full spins + extra)
    final double extraSpins = 5 + random.nextDouble() * 5;
    final double targetRotation = _currentRotation + extraSpins * 2 * pi;

    _wheelAnimation = Tween<double>(
      begin: _currentRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: _wheelController,
      curve: Curves.easeOutCubic,
    ));

    _wheelController.forward(from: 0).then((_) {
      setState(() {
        _lastWinner = winner;
        _currentRotation = targetRotation % (2 * pi);
      });
      _showWinnerDialog(winner);
    });
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF261933),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
            const SizedBox(height: 16),
            Text(
              'برنده قرعه‌کشی',
              style: GoogleFonts.vazirmatn(color: Colors.amber, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              winner,
              style: GoogleFonts.vazirmatn(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F13EC),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('تبریک!', style: GoogleFonts.vazirmatn()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'قرعه‌کشی آنلاین',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Wheel Section
                    _buildWheel(primaryColor, surfaceDark),
                    const SizedBox(height: 40),
                    // Winner Result Card
                    if (_lastWinner.isNotEmpty)
                      _buildWinnerCard(primaryColor, backgroundDark),
                    const SizedBox(height: 24),
                    // Input Section
                    _buildInputHeader(),
                    const SizedBox(height: 12),
                    _buildInputArea(primaryColor, surfaceDark, isDark),
                    const SizedBox(height: 8),
                    _buildParticipantCount(primaryColor),
                  ],
                ),
              ),
            ),
            // Footer Action
            _buildFooterAction(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel(Color primary, Color surface) {
    return AnimatedBuilder(
      animation: _wheelAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
              ),
            ),
            // The Wheel
            Transform.rotate(
              angle: _wheelAnimation.value,
              child: CustomPaint(
                size: const Size(280, 280),
                painter: WheelPainter(primary: primary, surface: surface),
              ),
            ),
            // Indicator
            Positioned(
              top: -10,
              child: Transform.rotate(
                angle: 0,
                child: const Icon(Icons.arrow_drop_down,
                    color: Colors.amber, size: 48),
              ),
            ),
            // Center Hub
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 3),
                boxShadow: [
                  BoxShadow(
                      color: Colors.amber.withOpacity(0.5), blurRadius: 10)
                ],
              ),
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.amber, shape: BoxShape.circle),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWinnerCard(Color primary, Color background) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [primary, const Color(0xFF4C1D95), background]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background.withOpacity(0.6),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                  color: Colors.amber, shape: BoxShape.circle),
              child: const Icon(Icons.emoji_events,
                  color: Color(0xFF4C1D95), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'آخرین برنده',
                    style: GoogleFonts.vazirmatn(
                        color: Colors.amber.withOpacity(0.8), fontSize: 11),
                  ),
                  Text(
                    _lastWinner,
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Opacity(
              opacity: 0.2,
              child: Icon(Icons.celebration, color: Colors.white, size: 40),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.groups, color: Color(0xFF7F13EC), size: 20),
            const SizedBox(width: 8),
            Text(
              'شرکت‌کنندگان',
              style: GoogleFonts.vazirmatn(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            _namesController.clear();
            setState(() => _lastWinner = '');
          },
          icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
          label: Text(
            'پاک کردن',
            style: GoogleFonts.vazirmatn(color: Colors.redAccent, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea(Color primary, Color surface, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.2)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: TextField(
        controller: _namesController,
        maxLines: 5,
        style: GoogleFonts.vazirmatn(fontSize: 16),
        decoration: InputDecoration(
          hintText:
              'نام‌ها را اینجا وارد کنید (با کاما یا خط جدید جدا کنید)...\nعلی\nزهرا\nمحمد',
          hintStyle: GoogleFonts.vazirmatn(
              color: Colors.grey.withOpacity(0.5), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildParticipantCount(Color primary) {
    return Row(
      children: [
        Text(
          'تعداد شرکت‌کنندگان: ',
          style: GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey),
        ),
        Text(
          _participantCount.toString(),
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterAction(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: GestureDetector(
          onTap: _spinWheel,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sync, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  'چرخاندن گردونه',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final Color primary;
  final Color surface;

  WheelPainter({required this.primary, required this.surface});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final List<Color> colors = [
      primary,
      const Color(0xFF191022),
      const Color(0xFFFBBF24),
      const Color(0xFF4C1D95),
      primary,
      const Color(0xFF191022),
      const Color(0xFFFBBF24),
      const Color(0xFF4C1D95),
    ];

    final double sweepAngle = 2 * pi / colors.length;

    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, i * sweepAngle, sweepAngle, true, paint);
    }

    // Border
    final borderPaint = Paint()
      ..color = const Color(0xFF191022)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, borderPaint);

    // Divider lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    for (int i = 0; i < colors.length; i++) {
      final double angle = i * sweepAngle;
      canvas.drawLine(
        center,
        Offset(
            center.dx + radius * cos(angle), center.dy + radius * sin(angle)),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
