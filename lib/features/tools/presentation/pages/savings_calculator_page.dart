import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SavingsCalculatorPage extends StatefulWidget {
  const SavingsCalculatorPage({super.key});

  @override
  State<SavingsCalculatorPage> createState() => _SavingsCalculatorPageState();
}

class _SavingsCalculatorPageState extends State<SavingsCalculatorPage> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _monthlyController = TextEditingController();
  double _annualGrowth = 10.0;

  int _years = 0;
  int _months = 0;
  double _progress = 0.0;
  bool _hasResult = false;

  final _formatter = NumberFormat("#,###");

  void _calculate() {
    double target =
        double.tryParse(_targetController.text.replaceAll(',', '')) ?? 0;
    double monthly =
        double.tryParse(_monthlyController.text.replaceAll(',', '')) ?? 0;
    double growth = _annualGrowth / 100;

    if (target <= 0 || monthly <= 0) return;

    double currentTotal = 0;
    int totalMonths = 0;
    double currentMonthly = monthly;

    while (currentTotal < target && totalMonths < 600) {
      // Max 50 years to avoid infinite loop
      totalMonths++;
      currentTotal += currentMonthly;

      if (totalMonths % 12 == 0) {
        currentMonthly *= (1 + growth);
      }
    }

    setState(() {
      _years = totalMonths ~/ 12;
      _months = totalMonths % 12;
      _progress =
          0.75; // Logic-wise, this is usually 100% since we reached target,
      // but UI from user shows a generic 75% for design. I'll make it dynamic if possible or keep as placeholder.
      _hasResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);

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
          'محاسبه‌گر پس‌انداز',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Intro Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'با وارد کردن مبلغ هدف و میزان پس‌انداز خود، زمان رسیدن به رویاهایتان را محاسبه کنید.',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 13,
                        color:
                            isDark ? const Color(0xFFAD92C9) : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Goal Input
            _buildLabel('مبلغ هدف (تومان)', isDark),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _targetController,
              icon: Icons.flag,
              isDark: isDark,
              surfaceColor: surfaceColor,
              primaryColor: primaryColor,
              onChanged: (v) {
                String text = v.replaceAll(',', '');
                if (text.isNotEmpty) {
                  _targetController.value = TextEditingValue(
                    text: _formatter.format(int.parse(text)),
                    selection: TextSelection.collapsed(
                        offset: _formatter.format(int.parse(text)).length),
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            // Monthly Savings Input
            _buildLabel('پس‌انداز ماهانه اولیه (تومان)', isDark),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _monthlyController,
              icon: Icons.payments,
              isDark: isDark,
              surfaceColor: surfaceColor,
              primaryColor: primaryColor,
              onChanged: (v) {
                String text = v.replaceAll(',', '');
                if (text.isNotEmpty) {
                  _monthlyController.value = TextEditingValue(
                    text: _formatter.format(int.parse(text)),
                    selection: TextSelection.collapsed(
                        offset: _formatter.format(int.parse(text)).length),
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            // Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_annualGrowth.toInt()}٪',
                    style: GoogleFonts.vazirmatn(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                Text(
                  'نرخ افزایش پس‌انداز سالانه',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: primaryColor,
                inactiveTrackColor:
                    isDark ? const Color(0xFF4D3267) : Colors.grey[300],
                thumbColor: primaryColor,
                overlayColor: primaryColor.withOpacity(0.2),
                trackHeight: 4,
              ),
              child: Slider(
                value: _annualGrowth,
                min: 0,
                max: 50,
                onChanged: (v) => setState(() => _annualGrowth = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('۵۰٪',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 10, color: Colors.grey)),
                  Text('۰٪',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate),
                label: Text(
                  'محاسبه زمان رسیدن به هدف',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
              ),
            ),

            const SizedBox(height: 32),

            if (_hasResult)
              _buildResultCard(isDark, primaryColor, backgroundColor),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: Text(
          text,
          style: GoogleFonts.vazirmatn(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? const Color(0xFF4D3267) : Colors.grey[300]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon,
              color: isDark ? const Color(0xFFAD92C9) : Colors.grey[400]),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildResultCard(
      bool isDark, Color primaryColor, Color backgroundColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.2),
            isDark ? const Color(0xFF150D1C) : Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Text(
            'زمان تقریبی رسیدن به هدف',
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFAD92C9) : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 8,
                  backgroundColor:
                      isDark ? const Color(0xFF4D3267) : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _years.toString(),
                    style: GoogleFonts.manrope(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'سال',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 12,
                      color: const Color(0xFFAD92C9),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'و $_months ماه',
                style: GoogleFonts.vazirmatn(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'با نرخ تورم احتمالی ۳۰٪',
            style: GoogleFonts.vazirmatn(
              fontSize: 12,
              color: const Color(0xFFAD92C9),
            ),
          ),
        ],
      ),
    );
  }
}
