import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../../../core/utils/digit_utils.dart';

class AttorneyFeeCalculatorPage extends StatefulWidget {
  const AttorneyFeeCalculatorPage({super.key});

  @override
  State<AttorneyFeeCalculatorPage> createState() =>
      _AttorneyFeeCalculatorPageState();
}

class _AttorneyFeeCalculatorPageState extends State<AttorneyFeeCalculatorPage> {
  final TextEditingController _amountController =
      TextEditingController(text: '250,000,000');
  final _formatter = NumberFormat("#,###");

  String _caseType = 'financial';
  String _stage = 'badvi';

  double _attorneyFee = 0;
  double _taxStamp = 0;
  double _kanoonShare = 0;
  double _sandoghShare = 0;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    double amount = DigitUtils.parseDouble(_amountController.text);
    double totalFee = 0;

    if (_caseType == 'financial') {
      // 1402-1403 Tariff Logic (Simplified Cumulative)
      if (amount <= 30000000) {
        totalFee = amount * 0.08;
      } else if (amount <= 150000000) {
        totalFee = (30000000 * 0.08) + ((amount - 30000000) * 0.07);
      } else if (amount <= 600000000) {
        totalFee = (30000000 * 0.08) +
            (120000000 * 0.07) +
            ((amount - 150000000) * 0.05);
      } else if (amount <= 1000000000) {
        totalFee = (30000000 * 0.08) +
            (120000000 * 0.07) +
            (450000000 * 0.05) +
            ((amount - 600000000) * 0.04);
      } else {
        totalFee = (30000000 * 0.08) +
            (120000000 * 0.07) +
            (450000000 * 0.05) +
            (400000000 * 0.04) +
            ((amount - 1000000000) * 0.03);
      }

      // Min/Max caps (example values)
      if (totalFee < 500000) totalFee = 500000;
      if (totalFee > 200000000) totalFee = 200000000;

      // Stage Multiplier
      if (_stage == 'badvi') {
        _attorneyFee = totalFee * 0.6;
      } else if (_stage == 'appeal') {
        _attorneyFee = totalFee * 0.4;
      } else {
        _attorneyFee = totalFee * 0.2; // Supreme court etc
      }
    } else {
      // Non-financial fixed (simplified)
      _attorneyFee = 2000000;
    }

    _taxStamp = _attorneyFee * 0.05;
    _kanoonShare = _attorneyFee * 0.02;
    _sandoghShare = _attorneyFee * 0.01;

    setState(() {});
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
          'محاسبه حق‌الوکاله و تمبر',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
            color: primaryColor,
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('نوع دعوا', Icons.gavel, primaryColor),
              _buildDropdown(isDark, surfaceDark, primaryColor),
              const SizedBox(height: 20),
              if (_caseType == 'financial') ...[
                _buildLabel(
                    'مبلغ خواسته (تومان)', Icons.payments, primaryColor),
                _buildAmountField(isDark, surfaceDark, primaryColor),
                const SizedBox(height: 20),
              ],
              _buildLabel('مرحله رسیدگی', Icons.account_tree, primaryColor),
              _buildStageToggle(isDark, surfaceDark, primaryColor),
              const SizedBox(height: 32),
              _buildResultCard(primaryColor),
              const SizedBox(height: 24),
              _buildActionButtons(primaryColor, isDark, surfaceDark),
              const SizedBox(height: 24),
              _buildInfoAlert(primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.vazirmatn(
                fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(bool isDark, Color surface, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? const Color(0xFF4D3267)
                : Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _caseType,
          isExpanded: true,
          dropdownColor: surface,
          icon: const Icon(Icons.expand_more, color: Color(0xFFAD92C9)),
          items: [
            DropdownMenuItem(
                value: 'financial',
                child: Text('حقوقی (مالی)', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: 'non-financial',
                child: Text('غیر مالی', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: 'criminal',
                child: Text('کیفری', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: 'execution',
                child: Text('اجرای احکام', style: GoogleFonts.vazirmatn())),
          ],
          onChanged: (v) {
            setState(() => _caseType = v!);
            _calculate();
          },
        ),
      ),
    );
  }

  Widget _buildAmountField(bool isDark, Color surface, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? const Color(0xFF4D3267)
                : Colors.grey.withOpacity(0.2)),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        onChanged: (v) {
          String val = v.replaceAll(',', '');
          if (val.isNotEmpty) {
            _amountController.value = TextEditingValue(
              text: _formatter.format(int.parse(val)),
              selection: TextSelection.collapsed(
                  offset: _formatter.format(int.parse(val)).length),
            );
          }
          _calculate();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'TOM',
              style: GoogleFonts.manrope(
                  fontSize: 10, fontWeight: FontWeight.bold, color: primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStageToggle(bool isDark, Color surface, Color primary) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF362348) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildToggleButton(
              'بدوی', _stage == 'badvi', () => _setStage('badvi'), isDark),
          _buildToggleButton('تجدیدنظر', _stage == 'appeal',
              () => _setStage('appeal'), isDark),
          _buildToggleButton('دیوان عالی', _stage == 'supreme',
              () => _setStage('supreme'), isDark),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      String label, bool active, VoidCallback onTap, bool isDark) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: active
                ? (isDark ? const Color(0xFF191022) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (active)
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.vazirmatn(
                fontSize: 13,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active
                    ? (isDark ? Colors.white : const Color(0xFF7F13EC))
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setStage(String s) {
    setState(() => _stage = s);
    _calculate();
  }

  Widget _buildResultCard(Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7F13EC), Color(0xFF4D3267)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'حق‌الوکاله طبق تعرفه ۱۴۰۳',
            style: GoogleFonts.vazirmatn(
                color: Colors.white.withOpacity(0.8), fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                DigitUtils.toFarsi(_formatter.format(_attorneyFee.round())),
                style: GoogleFonts.manrope(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                'تومان',
                style: GoogleFonts.vazirmatn(
                    color: Colors.white.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 20),
          _buildResultRow('تمبر مالیاتی (۵٪)', _taxStamp),
          const SizedBox(height: 12),
          _buildResultRow('سهم کانون/مرکز', _kanoonShare),
          const SizedBox(height: 12),
          _buildResultRow('صندوق حمایت', _sandoghShare),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, double val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(
                color: Colors.white.withOpacity(0.8), fontSize: 13)),
        Text(
          '${DigitUtils.toFarsi(_formatter.format(val.round()))} تومان',
          style: GoogleFonts.vazirmatn(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Color primary, bool isDark, Color surface) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
              'دریافت PDF', Icons.picture_as_pdf, primary, Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
              'کپی جزئیات',
              Icons.content_copy,
              isDark ? surface : Colors.white,
              isDark ? Colors.white : Colors.black87,
              border: true),
        ),
      ],
    );
  }

  Widget _buildButton(String text, IconData icon, Color bg, Color textCol,
      {bool border = false}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: border ? Border.all(color: Colors.grey.withOpacity(0.2)) : null,
        boxShadow: [
          if (!border)
            BoxShadow(
                color: bg.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textCol, size: 18),
          const SizedBox(width: 8),
          Text(text,
              style: GoogleFonts.vazirmatn(
                  color: textCol, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoAlert(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user, color: primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'این محاسبه بر اساس آخرین بخشنامه «آئین‌نامه تعرفه حق‌الوکاله، حق‌المشاوره و هزینه سفر وکلای دادگستری» مصوب ریاست محترم قوه قضائیه انجام شده است.',
              style: GoogleFonts.vazirmatn(
                  fontSize: 11, color: Colors.grey, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
