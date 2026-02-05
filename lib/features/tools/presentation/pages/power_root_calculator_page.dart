import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../../../core/utils/digit_utils.dart';

class CalculationHistory {
  final String title;
  final String result;
  final String timeAgo;
  final bool isPower;

  CalculationHistory({
    required this.title,
    required this.result,
    required this.timeAgo,
    required this.isPower,
  });
}

class PowerRootCalculatorPage extends StatefulWidget {
  const PowerRootCalculatorPage({super.key});

  @override
  State<PowerRootCalculatorPage> createState() =>
      _PowerRootCalculatorPageState();
}

class _PowerRootCalculatorPageState extends State<PowerRootCalculatorPage> {
  bool _isPower = true;
  final TextEditingController _baseController =
      TextEditingController(text: '0');
  final TextEditingController _exponentController =
      TextEditingController(text: 'n');

  String _result = '0';
  final List<CalculationHistory> _history = [
    CalculationHistory(
        title: 'جذر عدد 144',
        result: '12',
        timeAgo: '۲ دقیقه پیش',
        isPower: false),
    CalculationHistory(
        title: '5 به توان 3',
        result: '125',
        timeAgo: '۱۰ دقیقه پیش',
        isPower: true),
    CalculationHistory(
        title: '2 به توان 8',
        result: '256',
        timeAgo: '۱ ساعت پیش',
        isPower: true),
  ];

  void _calculate() {
    double base = DigitUtils.parseDouble(_baseController.text);
    double exponent =
        DigitUtils.parseDouble(_exponentController.text.replaceFirst('n', '2'));

    double res;
    String title;
    if (_isPower) {
      res = math.pow(base, exponent).toDouble();
      title =
          '${DigitUtils.toFarsi(base.toString())} به توان ${DigitUtils.toFarsi(exponent.toString())}';
    } else {
      res = math.pow(base, 1 / exponent).toDouble();
      title =
          'جذر ${DigitUtils.toFarsi(exponent.toString())} عدد ${DigitUtils.toFarsi(base.toString())}';
    }

    setState(() {
      _result = res.toString().endsWith('.0')
          ? res.toInt().toString()
          : res.toStringAsFixed(4);
      _history.insert(
          0,
          CalculationHistory(
            title: title,
            result: DigitUtils.toFarsi(_result),
            timeAgo: 'همین حالا',
            isPower: _isPower,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const secondaryColor = Color(0xFF00F2FE);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF281A36);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: backgroundDark.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'محاسبه جذر و توان',
          style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings, size: 20, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSegmentedControl(surfaceDark, primaryColor),
              const SizedBox(height: 32),
              _buildInputSection(surfaceDark, primaryColor, secondaryColor),
              const SizedBox(height: 32),
              _buildResultCard(primaryColor, secondaryColor),
              const SizedBox(height: 32),
              _buildCalculateButton(primaryColor),
              const SizedBox(height: 48),
              _buildHistorySection(primaryColor, secondaryColor, surfaceDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(Color surface, Color primary) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildSegmentButton('توان (Power)', _isPower,
              () => setState(() => _isPower = true), primary),
          _buildSegmentButton('جذر (Root)', !_isPower,
              () => setState(() => _isPower = false), primary),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(
      String label, bool active, VoidCallback onTap, Color primary) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [BoxShadow(color: primary.withOpacity(0.4), blurRadius: 8)]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.grey[400],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(Color surface, Color primary, Color secondary) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isPower ? 'BASE / پایه' : 'NUMBER / عدد',
                style: GoogleFonts.vazirmatn(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: primary,
                ),
              ),
              TextField(
                controller: _baseController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.manrope(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                ),
                onChanged: (_) => _calculate(),
              ),
            ],
          ),
        ),
        Positioned(
          left: 24,
          top: 24,
          child: Column(
            children: [
              Text(
                _isPower ? 'EXPONENT' : 'ROOT',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: secondary,
                ),
              ),
              const SizedBox(height: 4),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: secondary.withOpacity(0.5), width: 2),
                    ),
                    child: TextField(
                      controller: _exponentController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondary),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'n',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onChanged: (_) => _calculate(),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                          color: secondary, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('نتیجه نهایی',
                      style: GoogleFonts.vazirmatn(
                          color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  Text(
                    DigitUtils.toFarsi(_result),
                    style: GoogleFonts.manrope(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.functions, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('محاسبه با دقت بالا',
                  style: GoogleFonts.vazirmatn(
                      color: Colors.white.withOpacity(0.6), fontSize: 11)),
              Row(
                children: [
                  Icon(Icons.schedule,
                      color: Colors.white.withOpacity(0.6), size: 14),
                  const SizedBox(width: 4),
                  Text('همین حالا',
                      style: GoogleFonts.vazirmatn(
                          color: Colors.white.withOpacity(0.6), fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton(Color primary) {
    return GestureDetector(
      onTap: _calculate,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: primary.withOpacity(0.6),
                blurRadius: 25,
                offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('محاسبه مجدد',
                style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(width: 12),
            const Icon(Icons.calculate, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(Color primary, Color secondary, Color surface) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('تاریخچه محاسبات',
                style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            TextButton(
              onPressed: () => setState(() => _history.clear()),
              child: Text('پاک کردن همه',
                  style: GoogleFonts.vazirmatn(color: primary, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._history
            .map((h) => _buildHistoryItem(h, primary, secondary, surface))
            .toList(),
      ],
    );
  }

  Widget _buildHistoryItem(
      CalculationHistory h, Color primary, Color secondary, Color surface) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (h.isPower ? primary : secondary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  h.isPower ? Icons.data_object : Icons.square_foot,
                  color: h.isPower ? primary : secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.title,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(h.timeAgo,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Text(h.result,
              style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: h.isPower ? primary : secondary)),
        ],
      ),
    );
  }
}

// Removed extension as it caused confusion and wasn't strictly needed for premium design
