import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/utils/digit_utils.dart';

class GoldBubbleCalculatorPage extends StatefulWidget {
  const GoldBubbleCalculatorPage({super.key});

  @override
  State<GoldBubbleCalculatorPage> createState() =>
      _GoldBubbleCalculatorPageState();
}

class _GoldBubbleCalculatorPageState extends State<GoldBubbleCalculatorPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _marketPriceController =
      TextEditingController(text: '32,650,000');
  final TextEditingController _globalGoldController =
      TextEditingController(text: '2,034');
  final TextEditingController _dollarRateController =
      TextEditingController(text: '58,400');

  String _selectedCoin = 'تمام سکه بهار آزادی (امامی)';
  final List<String> _coinTypes = [
    'تمام سکه بهار آزادی (امامی)',
    'نیم سکه',
    'ربع سکه',
    'سکه گرمی',
  ];

  late AnimationController _chartController;
  late Animation<double> _chartAnimation;

  double _bubblePercent = 12.5;
  double _intrinsicValue = 28450000;
  double _bubbleAmount = 4200000;

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _chartAnimation =
        CurvedAnimation(parent: _chartController, curve: Curves.easeOutBack);
    _chartController.forward();
    _calculate();
  }

  @override
  void dispose() {
    _chartController.dispose();
    _marketPriceController.dispose();
    _globalGoldController.dispose();
    _dollarRateController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      double marketPrice =
          double.tryParse(_marketPriceController.text.replaceAll(',', '')) ?? 0;
      double globalGold =
          double.tryParse(_globalGoldController.text.replaceAll(',', '')) ?? 0;
      double dollarRate =
          double.tryParse(_dollarRateController.text.replaceAll(',', '')) ?? 0;

      double weight = 8.133; // Default Full Coin
      if (_selectedCoin == 'نیم سکه') weight = 4.066;
      if (_selectedCoin == 'ربع سکه') weight = 2.033;
      if (_selectedCoin == 'سکه گرمی') weight = 1.011;

      // Purity is usually 0.9 for coins (21.6k)
      // Intrinsic Value = ((Global Gold * Dollar Rate) / 31.1035) * Weight * 0.9
      _intrinsicValue = ((globalGold * dollarRate) / 31.1035) * weight * 0.9;

      // Add a small minting fee estimate
      _intrinsicValue += 50000;

      _bubbleAmount = marketPrice - _intrinsicValue;
      _bubblePercent = (_bubbleAmount / _intrinsicValue) * 100;

      _chartController.reset();
      _chartController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const goldColor = Color(0xFFFBBF24);
    const backgroundDark = Color(0xFF0F0816);
    const surfaceDark = Color(0xFF1A1025);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ColorFilter.mode(
                    Colors.black.withOpacity(0), BlendMode.dst),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        _buildGaugeCard(surfaceDark, goldColor, primaryColor),
                        const SizedBox(height: 24),
                        _buildParamsSection(
                            surfaceDark, primaryColor, goldColor),
                        const SizedBox(height: 24),
                        _buildMethodCard(surfaceDark, goldColor),
                        const SizedBox(height: 24),
                        _buildCalculateButton(goldColor),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          Text(
            'محاسبه حباب سکه',
            style: GoogleFonts.vazirmatn(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGaugeCard(Color surface, Color gold, Color primary) {
    String riskText = 'حباب معمول (ریسک متوسط)';
    Color riskColor = Colors.orange;
    if (_bubblePercent < 5) {
      riskText = 'حباب کم (ریسک پایین)';
      riskColor = const Color(0xFF10B981);
    } else if (_bubblePercent > 10) {
      riskText = 'حباب زیاد (ریسک بالا)';
      riskColor = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: primary.withOpacity(0.05), blurRadius: 20)
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: GaugePainter(
                      percent: _bubblePercent,
                      animationValue: _chartAnimation.value),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _bubblePercent.toStringAsFixed(1),
                            style: GoogleFonts.manrope(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 2),
                            child: Text('%',
                                style: GoogleFonts.manrope(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: gold)),
                          ),
                        ],
                      ),
                      Text('نسبت حباب',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 12, color: Colors.white60)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: riskColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: riskColor),
                ),
                const SizedBox(width: 8),
                Text(riskText,
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: riskColor.withOpacity(0.8))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoSmall(
                    'ارزش واقعی سکه',
                    '${intl.NumberFormat('#,###').format(_intrinsicValue.toInt())} تومان',
                    Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoSmall(
                    'میزان اختلاف (حباب)',
                    '+${intl.NumberFormat('#,###').format(_bubbleAmount.abs().toInt())} تومان',
                    gold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSmall(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0816).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  GoogleFonts.vazirmatn(fontSize: 10, color: Colors.white38)),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(DigitUtils.toFarsi(value),
                style: GoogleFonts.vazirmatn(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: valueColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildParamsSection(Color surface, Color primary, Color gold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('پارامترهای محاسبه',
                style: GoogleFonts.vazirmatn(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            TextButton(
              onPressed: () {
                _marketPriceController.clear();
                _globalGoldController.clear();
                _dollarRateController.clear();
              },
              child: Text('پاک کردن فرم',
                  style: GoogleFonts.vazirmatn(fontSize: 12, color: gold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            children: [
              _buildDropdownField('نوع سکه', surface),
              const SizedBox(height: 20),
              _buildInputField(
                  'قیمت بازار سکه', _marketPriceController, 'تومان', gold),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: _buildInputField('قیمت انس جهانی طلا',
                          _globalGoldController, r'$', primary,
                          small: true)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildInputField('نرخ دلار (تتر)',
                          _dollarRateController, 'تومان', primary,
                          small: true)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(fontSize: 12, color: Colors.white38)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCoin,
              isExpanded: true,
              dropdownColor: surface,
              icon: const Icon(Icons.expand_more, color: Colors.white38),
              items: _coinTypes
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t,
                            style: GoogleFonts.vazirmatn(
                                color: Colors.white, fontSize: 13)),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCoin = val);
                  _calculate();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, String unit, Color accent,
      {bool small = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(
                fontSize: small ? 11 : 12, color: Colors.white38)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.left,
          style: GoogleFonts.manrope(
              fontSize: small ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.03),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, top: 14),
              child: Text(unit,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 11, color: Colors.white24)),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: accent.withOpacity(0.5))),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton(Color gold) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [gold, gold.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: gold.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: ElevatedButton(
        onPressed: _calculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, color: Colors.black, size: 24),
            const SizedBox(width: 8),
            Text('محاسبه مجدد',
                style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(Color surface, Color gold) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: gold, size: 18),
              const SizedBox(width: 8),
              Text('شیوه محاسبه حباب',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'ارزش ذاتی سکه بر اساس فرمول استاندارد زیر محاسبه می‌شود:',
            style: GoogleFonts.vazirmatn(fontSize: 12, color: Colors.white38),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildFormulaLine(
                    'ارزش ذاتی = (قیمت انس طلای جهانی × نرخ دلار) / ۳۱.۱۰۳ × وزن سکه × عیار سکه'),
                const Divider(color: Colors.white10, height: 20),
                _buildFormulaLine('حباب سکه = قیمت بازار - ارزش ذاتی'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '* عیار سکه بهار آزادی ۲۲ (۹۰۰ از ۱۰۰۰) و وزن تمام سکه ۸.۱۳۳ گرم می‌باشد.',
            style: GoogleFonts.vazirmatn(
                fontSize: 11,
                color: gold.withOpacity(0.5),
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaLine(String text) {
    return Text(
      DigitUtils.toFarsi(text),
      style: GoogleFonts.vazirmatn(
          fontSize: 11, color: Colors.white60, height: 1.6),
      textAlign: TextAlign.center,
    );
  }
}

class GaugePainter extends CustomPainter {
  final double percent;
  final double animationValue;
  GaugePainter({required this.percent, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width * 0.45;
    const startAngle = math.pi;
    const sweepAngle = math.pi;

    final basePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, basePaint);

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi,
      colors: [
        const Color(0xFF10B981),
        const Color(0xFFFBBF24),
        const Color(0xFFEF4444)
      ],
      stops: [0.0, 0.5, 1.0],
      transform: const GradientRotation(math.pi),
    );

    final activePaint = Paint()
      ..shader =
          gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    // Map percent (0-30%) to sweep (0-PI)
    double progress = (percent.clamp(0.0, 30.0) / 30.0) * math.pi;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        progress * animationValue, false, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
