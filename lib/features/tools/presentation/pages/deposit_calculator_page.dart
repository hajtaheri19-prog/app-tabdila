import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/digit_utils.dart';

class DepositCalculatorPage extends StatefulWidget {
  const DepositCalculatorPage({super.key});

  @override
  State<DepositCalculatorPage> createState() => _DepositCalculatorPageState();
}

class _DepositCalculatorPageState extends State<DepositCalculatorPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  bool _isCompound = false;
  double _totalInterest = 0;
  double _finalAmount = 0;
  double _monthlyInterest = 0;

  final _formatter = NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    double p = DigitUtils.parseDouble(_amountController.text);
    double r = DigitUtils.parseDouble(_rateController.text);
    int n = DigitUtils.parseInt(_monthsController.text);

    if (p <= 0 || r <= 0 || n <= 0) return;

    setState(() {
      if (_isCompound) {
        // Compound Interest
        // A = P(1 + r/n)^nt -> here r is annual, so A = P(1 + r/12)^n
        double monthlyRate = (r / 100) / 12;
        _finalAmount = p * pow(1 + monthlyRate, n);
        _totalInterest = _finalAmount - p;
        _monthlyInterest = _totalInterest / n;
      } else {
        // Simple Interest
        // I = P * r * t
        _totalInterest = (p * (r / 100) * n) / 12;
        _finalAmount = p + _totalInterest;
        _monthlyInterest = _totalInterest / n;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF2A1E36) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);
    final mutedText = isDark ? const Color(0xFFAD92C9) : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.white, size: 28),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      Text(
                        'محاسبه سود سپرده',
                        style: GoogleFonts.notoSansArabic(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount Input
                        _buildLabel('مبلغ سپرده (تومان)', mutedText!),
                        const SizedBox(height: 8),
                        _buildInputField(
                          controller: _amountController,
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          primaryColor: primaryColor,
                          icon: Icons.account_balance_wallet,
                          textAlign: TextAlign.left,
                          onChanged: (v) {
                            String text = v.replaceAll(',', '');
                            if (text.isNotEmpty) {
                              _amountController.value = TextEditingValue(
                                text: DigitUtils.toFarsi(_formatter
                                    .format(DigitUtils.parseInt(text))),
                                selection: TextSelection.collapsed(
                                    offset: DigitUtils.toFarsi(_formatter
                                            .format(DigitUtils.parseInt(text)))
                                        .length),
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
                                  _buildLabel('مدت (ماه)', mutedText),
                                  const SizedBox(height: 8),
                                  _buildSmallInputField(
                                    controller: _monthsController,
                                    isDark: isDark,
                                    surfaceColor: surfaceColor,
                                    primaryColor: primaryColor,
                                    suffixText: 'ماه',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('نرخ سود (%)', mutedText),
                                  const SizedBox(height: 8),
                                  _buildSmallInputField(
                                    controller: _rateController,
                                    isDark: isDark,
                                    surfaceColor: surfaceColor,
                                    primaryColor: primaryColor,
                                    suffixText: '%',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Mode Toggle
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: surfaceColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Row(
                            children: [
                              _buildModeButton(
                                  'سود مرکب', _isCompound, primaryColor),
                              _buildModeButton(
                                  'سود ساده', !_isCompound, primaryColor),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Main Result Card
                        _buildMainResultCard(primaryColor, isDark),

                        const SizedBox(height: 16),

                        // Secondary Results
                        _buildSecondaryResult(
                          icon: Icons.savings,
                          label: 'مبلغ نهایی سپرده',
                          value: DigitUtils.toFarsi(
                              _formatter.format(_finalAmount.round())),
                          color: Colors.greenAccent,
                        ),
                        const SizedBox(height: 12),
                        _buildSecondaryResult(
                          icon: Icons.calendar_view_month,
                          label: 'سود ماهیانه تقریبی',
                          value: DigitUtils.toFarsi(
                              _formatter.format(_monthlyInterest.round())),
                          color: Colors.blueAccent,
                        ),

                        const SizedBox(height: 40),

                        // Calculate Button
                        _buildCalculateButton(primaryColor),
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
    required IconData icon,
    TextAlign textAlign = TextAlign.right,
    Function(String)? onChanged,
  }) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        textAlign: textAlign,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryColor.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSmallInputField({
    required TextEditingController controller,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    required String suffixText,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          Positioned(
            right: 12,
            top: 20,
            child: Text(
              suffixText,
              style:
                  TextStyle(color: primaryColor.withOpacity(0.4), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String label, bool isSelected, Color primaryColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _isCompound = label == 'سود مرکب';
          _calculate();
        }),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.notoSansArabic(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainResultCard(Color primaryColor, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1E36).withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(
            'سود کل دوره',
            style: GoogleFonts.notoSansArabic(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Colors.white70],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  DigitUtils.toFarsi(_formatter.format(_totalInterest.round())),
                  style: GoogleFonts.manrope(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'تومان',
                  style: GoogleFonts.notoSansArabic(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryResult({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1E36).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.notoSansArabic(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton(Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _calculate,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check, color: Color(0xFF7F13EC)),
              const SizedBox(width: 12),
              Text(
                'محاسبه کن',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7F13EC),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
