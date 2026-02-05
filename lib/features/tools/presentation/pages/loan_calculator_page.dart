import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class LoanCalculatorPage extends StatefulWidget {
  const LoanCalculatorPage({super.key});

  @override
  State<LoanCalculatorPage> createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  bool _isCompound = true;
  double _monthlyPayment = 0;
  double _totalInterest = 0;
  double _totalRepayment = 0;

  final _formatter = NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    double p = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    double r = double.tryParse(_rateController.text) ?? 0;
    int n = int.tryParse(_monthsController.text) ?? 0;

    if (p <= 0 || r <= 0 || n <= 0) return;

    setState(() {
      if (_isCompound) {
        // Compound Interest (Banking Formula)
        double monthlyRate = (r / 100) / 12;
        _monthlyPayment = (p * monthlyRate * pow(1 + monthlyRate, n)) /
            (pow(1 + monthlyRate, n) - 1);
        _totalRepayment = _monthlyPayment * n;
        _totalInterest = _totalRepayment - p;
      } else {
        // Simple Interest
        _totalInterest = (p * n * r) / 1200;
        _totalRepayment = p + _totalInterest;
        _monthlyPayment = _totalRepayment / n;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);
    final mutedText = isDark ? const Color(0xFFAD92C9) : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_forward,
              color: isDark ? Colors.white : Colors.black87),
        ),
        title: Text(
          'محاسبه اقساط وام',
          style: GoogleFonts.notoSansArabic(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input
            _buildLabel('مبلغ وام (تومان)', mutedText!),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _amountController,
              isDark: isDark,
              surfaceColor: surfaceColor,
              primaryColor: primaryColor,
              prefixIcon: Icons.attach_money,
              onChanged: (v) {
                // Re-format with commas
                String text = v.replaceAll(',', '');
                if (text.isNotEmpty) {
                  _amountController.value = TextEditingValue(
                    text: _formatter.format(int.parse(text)),
                    selection: TextSelection.collapsed(
                        offset: _formatter.format(int.parse(text)).length),
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            // Rate & Duration
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('نرخ سود (%)', mutedText),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _rateController,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        primaryColor: primaryColor,
                        prefixIcon: Icons.percent,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('مدت (ماه)', mutedText),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _monthsController,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        primaryColor: primaryColor,
                        prefixIcon: Icons.calendar_month,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF261933) : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        isDark ? const Color(0xFF4D3267) : Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  _buildToggleButton('سود ساده', !_isCompound, primaryColor),
                  _buildToggleButton('سود مرکب', _isCompound, primaryColor),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Calculate Button
            _buildCalculateButton(primaryColor),

            const SizedBox(height: 32),

            // Results Card
            _buildResultsCard(isDark, primaryColor),

            const SizedBox(height: 20),
            Center(
              child: Text(
                'مقادیر بالا تقریبی بوده و بر اساس فرمول بانک مرکزی محاسبه شده است.',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 10,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        text,
        style: GoogleFonts.notoSansArabic(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    required IconData prefixIcon,
    TextAlign textAlign = TextAlign.right,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? const Color(0xFF4D3267) : Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        textAlign: textAlign,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: GoogleFonts.notoSansArabic(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon,
              color: isDark ? const Color(0xFFAD92C9) : primaryColor),
          border: InputBorder.none,
          hintText: '۰',
          hintStyle: GoogleFonts.notoSansArabic(
            fontSize: 18,
            color: isDark ? Colors.white10 : Colors.black12,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, Color primaryColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _isCompound = label == 'سود مرکب';
          _calculate();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.notoSansArabic(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculateButton(Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _calculate,
        icon: const Icon(Icons.calculate, size: 24),
        label: Text(
          'محاسبه کن',
          style: GoogleFonts.notoSansArabic(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildResultsCard(bool isDark, Color primaryColor) {
    return Stack(
      children: [
        // Glow Background
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.1),
                Colors.pink.withOpacity(0.1)
              ],
            ),
          ),
        ),
        // Glass Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Text(
                'قسط ماهیانه شما',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    _formatter.format(_monthlyPayment.round()),
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'تومان',
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildResultItem(
                      'کل سود وام',
                      _formatter.format(_totalInterest.round()),
                      Colors.pinkAccent,
                      isDark,
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.white10),
                  Expanded(
                    child: _buildResultItem(
                      'مجموع بازپرداخت',
                      _formatter.format(_totalRepayment.round()),
                      Colors.greenAccent,
                      isDark,
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

  Widget _buildResultItem(
      String title, String value, Color color, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 6,
                height: 6,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.notoSansArabic(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.notoSansArabic(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          'تومان',
          style: GoogleFonts.notoSansArabic(
            fontSize: 10,
            color: isDark ? Colors.white38 : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
