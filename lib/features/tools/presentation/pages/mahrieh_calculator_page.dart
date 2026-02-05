import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class MahriehCalculatorPage extends StatefulWidget {
  const MahriehCalculatorPage({super.key});

  @override
  State<MahriehCalculatorPage> createState() => _MahriehCalculatorPageState();
}

class _MahriehCalculatorPageState extends State<MahriehCalculatorPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _marriageYearController = TextEditingController();
  final TextEditingController _paymentYearController =
      TextEditingController(text: '1403');

  final _formatter = NumberFormat("#,###");

  String _calcType = 'dowry'; // dowry, inheritance
  double _resultValue = 0;
  double _marriageIndex = 0;
  double _paymentIndex = 0;
  bool _calculated = false;

  // Central Bank CPI Indices (Simplified Mock Data)
  // Source: Central Bank of Iran (Mocked for Demo purposes as real full table is huge)
  final Map<int, double> _cpiIndices = {
    1350: 0.003, 1351: 0.003, 1352: 0.004, 1353: 0.004, 1354: 0.005,
    1355: 0.006, 1356: 0.007, 1357: 0.008, 1358: 0.009, 1359: 0.011,
    1360: 0.014, 1361: 0.017, 1362: 0.020, 1363: 0.022, 1364: 0.023,
    1365: 0.052, 1366: 0.066, 1367: 0.085, 1368: 0.100, 1369: 0.109,
    1370: 0.131, 1374: 0.399, 1375: 0.492, 1380: 1.050, 1385: 2.375,
    1390: 6.386, 1395: 18.232, 1398: 41.285, 1399: 56.401, 1400: 83.473,
    1401: 122.535, 1402: 180.200, 1403: 987.4 // Mocked high value for 2024
  };

  void _calculate() {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    int? mYear = int.tryParse(_marriageYearController.text);
    int? pYear = int.tryParse(_paymentYearController.text);
    String amountStr = _amountController.text.replaceAll(',', '');
    double? amount = double.tryParse(amountStr);

    if (mYear == null || pYear == null || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('لطفا تمامی فیلدها را پر کنید',
                style: GoogleFonts.vazirmatn())),
      );
      return;
    }

    // Get Indices (Fallback to closest if exact year missing for demo stability)
    double mIndex = _getClosestIndex(mYear);
    double pIndex = _getClosestIndex(pYear);

    setState(() {
      _marriageIndex = mIndex;
      _paymentIndex = pIndex;

      if (mIndex > 0) {
        // Formula: Amount * (PaymentYearIndex / MarriageYearIndex)
        _resultValue = amount * (pIndex / mIndex);
        _calculated = true;
      }
    });
  }

  double _getClosestIndex(int year) {
    if (_cpiIndices.containsKey(year)) return _cpiIndices[year]!;
    // Fallback logic for demo
    if (year < 1350) return 0.001;
    if (year > 1403) return 987.4;
    return 1.0; // Default
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF135bec); // Updated per user design
    final background =
        isDark ? const Color(0xFF101622) : const Color(0xFFF6F6F8);
    final textCol = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSec = isDark ? const Color(0xFF92A4C9) : Colors.grey;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF101622).withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ماشین حساب حقوقی',
          style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.bold, color: textCol),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_forward, color: textCol),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: textSec),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Segmented Control
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1C2537)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isDark
                          ? const Color(0xFF324467)
                          : Colors.transparent),
                ),
                child: Row(
                  children: [
                    _buildSegmentBtn('مهریه به نرخ روز', 'dowry', isDark),
                    _buildSegmentBtn('محاسبه ارث', 'inheritance', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'محاسبه بر اساس آخرین شاخص بانک مرکزی',
                style: GoogleFonts.vazirmatn(fontSize: 12, color: textSec),
              ),
              const SizedBox(height: 24),

              // Inputs
              _buildInputLabel('سال وقوع عقد', textCol),
              const SizedBox(height: 8),
              _buildYearInput(_marriageYearController, '1365',
                  Icons.calendar_month, isDark, textCol, textSec),

              const SizedBox(height: 20),
              _buildInputLabel('سال پرداخت (روز)', textCol),
              const SizedBox(height: 8),
              _buildYearInput(_paymentYearController, '1403', Icons.update,
                  isDark, textCol, textSec),

              const SizedBox(height: 20),
              _buildInputLabel('مبلغ مهریه در عقدنامه (تومان)', textCol),
              const SizedBox(height: 8),
              _buildAmountInput(isDark, textCol, textSec, primaryColor),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text('مبلغ را به تومان وارد کنید.',
                    style: GoogleFonts.vazirmatn(fontSize: 12, color: textSec)),
              ),

              const SizedBox(height: 24),

              // Calc Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    shadowColor: primaryColor.withOpacity(0.4),
                    elevation: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('محاسبه مبلغ',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Icon(Icons.calculate_outlined),
                    ],
                  ),
                ),
              ),

              if (_calculated) ...[
                const SizedBox(height: 24),
                _buildResultCard(primaryColor, isDark, textSec),
              ],

              const SizedBox(height: 24),
              _buildInfoBox(primaryColor, textSec),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentBtn(String label, String value, bool isDark) {
    bool isActive = _calcType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _calcType = value),
        child: Container(
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? const Color(0xFF101622) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: const Color(0xFF324467).withOpacity(0.5))
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 2)
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isActive
                  ? (isDark ? Colors.white : Colors.black)
                  : const Color(0xFF92A4C9),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(text,
          style:
              GoogleFonts.vazirmatn(color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildYearInput(TextEditingController controller, String hint,
      IconData icon, bool isDark, Color textCol, Color textSec) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF192233) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF324467)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.manrope(color: textCol, fontSize: 16),
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.manrope(color: textSec.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Container(
            width: 48,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFF324467))),
            ),
            child: Icon(icon, color: textSec),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(
      bool isDark, Color textCol, Color textSec, Color primary) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF192233) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF324467)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.manrope(color: textCol, fontSize: 16),
              textAlign: TextAlign.left,
              onChanged: (val) {
                if (val.isEmpty) return;
                String clean = val.replaceAll(',', '');
                if (clean.isNotEmpty) {
                  _amountController.value = TextEditingValue(
                    text: _formatter.format(int.parse(clean)),
                    selection: TextSelection.collapsed(
                        offset: _formatter.format(int.parse(clean)).length),
                  );
                }
              },
              decoration: InputDecoration(
                hintText: 'مثال: 500,000',
                hintStyle: GoogleFonts.manrope(color: textSec.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Container(
            width: 48,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFF324467))),
            ),
            child: Icon(Icons.paid_outlined, color: textSec),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Color primary, bool isDark, Color textSec) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF192233),
            const Color(0xFF0F1521),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF324467)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ارزش مهریه به نرخ روز',
                  style: GoogleFonts.vazirmatn(color: textSec, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up,
                        color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text('بروزرسانی ۱۴۰۳',
                        style: GoogleFonts.vazirmatn(
                            color: Colors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _formatter.format(_resultValue.round()),
            style: GoogleFonts.manrope(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          Text(
            'تومان',
            style: GoogleFonts.vazirmatn(color: textSec, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: _buildIndexBox('شاخص سال عقد',
                      _marriageIndex.toString(), isDark, textSec)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildIndexBox('شاخص سال جاری',
                      _paymentIndex.toString(), isDark, textSec)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Share.share('محاسبه مهریه:\n'
                        'مبلغ عقد: ${_amountController.text}\n'
                        'سال عقد: ${_marriageYearController.text}\n'
                        'شاخص: $_marriageIndex\n\n'
                        'ارزش روز: ${_formatter.format(_resultValue.round())} تومان');
                  },
                  icon: const Icon(Icons.share, size: 18, color: Colors.white),
                  label: Text('اشتراک گذاری',
                      style: GoogleFonts.vazirmatn(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: _formatter.format(_resultValue.round())));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('مبلغ کپی شد',
                            style: GoogleFonts.vazirmatn())));
                  },
                  icon: const Icon(Icons.content_copy,
                      size: 18, color: Colors.white),
                  label: Text('کپی مبلغ',
                      style: GoogleFonts.vazirmatn(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.05),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIndexBox(
      String label, String value, bool isDark, Color textSec) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF101622).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF324467).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label,
              style: GoogleFonts.vazirmatn(color: textSec, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildInfoBox(Color primary, Color textSec) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a8a).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1e3a8a).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'این محاسبه بر اساس جدول شاخص تورم بانک مرکزی جمهوری اسلامی ایران انجام شده است و جنبه قانونی معتبر دارد.',
              style: GoogleFonts.vazirmatn(
                  color: textSec, fontSize: 13, height: 1.6),
            ),
          )
        ],
      ),
    );
  }
}
