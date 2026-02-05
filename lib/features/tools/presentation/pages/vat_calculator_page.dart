import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VatCalculatorPage extends StatefulWidget {
  const VatCalculatorPage({super.key});

  @override
  State<VatCalculatorPage> createState() => _VatCalculatorPageState();
}

class _VatCalculatorPageState extends State<VatCalculatorPage> {
  final TextEditingController _amountController = TextEditingController();
  double _vatRate = 10;
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    String text = _amountController.text.replaceAll(',', '');
    if (text.isEmpty) return;

    // Format the number with commas
    String formatted = _formatter.format(int.tryParse(text) ?? 0);
    if (formatted != _amountController.text) {
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  double get _baseAmount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  double get _vatAmount => _baseAmount * (_vatRate / 100);
  double get _totalAmount => _baseAmount + _vatAmount;

  void _onKeyPress(String key) {
    String currentText = _amountController.text.replaceAll(',', '');
    if (key == 'backspace') {
      if (currentText.isNotEmpty) {
        _amountController.text =
            currentText.substring(0, currentText.length - 1);
      }
    } else if (key == '.') {
      if (!currentText.contains('.')) {
        _amountController.text = '$currentText.';
      }
    } else {
      if (currentText == '0') {
        _amountController.text = key;
      } else {
        _amountController.text = currentText + key;
      }
    }
    setState(() {});
  }

  void _clear() {
    setState(() {
      _amountController.text = '0';
    });
  }

  void _copyResult() {
    String summary = 'مبلغ پایه: ${_formatter.format(_baseAmount)} تومان\n'
        'مالیات (${_vatRate.toInt()}%): ${_formatter.format(_vatAmount)} تومان\n'
        'جمع کل: ${_formatter.format(_totalAmount)} تومان';
    Clipboard.setData(ClipboardData(text: summary));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('نتیجه در حافظه کپی شد'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final cardColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_forward,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
        title: Text(
          'محاسبه‌گر مالیات بر ارزش افزوده',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'مبلغ پایه را برای محاسبه وارد کنید.',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Base Amount Input
                  Text(
                    'مبلغ پایه (تومان)',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF4D3267)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'تومان',
                          style: GoogleFonts.vazirmatn(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            readOnly: true, // Use custom keypad
                            textAlign: TextAlign.left,
                            style: GoogleFonts.vazirmatn(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: '۰',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // VAT Rate Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${_vatRate.toInt()}٪',
                          style: GoogleFonts.vazirmatn(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        'نرخ مالیات (VAT)',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _vatRate,
                    min: 0,
                    max: 25,
                    activeColor: primaryColor,
                    onChanged: (val) => setState(() => _vatRate = val),
                  ),
                  const SizedBox(height: 32),

                  // Result Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7F13EC), Color(0xFF4D3267)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildResultRow(
                          'مبلغ پایه',
                          '${_formatter.format(_baseAmount)} تومان',
                        ),
                        const Divider(color: Colors.white10, height: 32),
                        _buildResultRow(
                          'مبلغ مالیات (${_vatRate.toInt()}٪)',
                          '${_formatter.format(_vatAmount)} تومان',
                        ),
                        const Divider(color: Colors.white10, height: 32),
                        _buildResultRow(
                          'جمع کل قابل پرداخت',
                          '${_formatter.format(_totalAmount)} تومان',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _clear,
                          icon: const Icon(Icons.restart_alt, size: 20),
                          label: const Text('پاک کردن'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cardColor,
                            foregroundColor:
                                isDark ? Colors.white : Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isDark
                                    ? const Color(0xFF4D3267)
                                    : Colors.grey[200]!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _copyResult,
                          icon: const Icon(Icons.content_copy, size: 20),
                          label: const Text('کپی نتیجه'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: primaryColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Keypad
          _buildKeypad(isDark, cardColor),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: GoogleFonts.vazirmatn(
            fontSize: isTotal ? 24 : 16,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.white : Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildKeypad(bool isDark, Color cardColor) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        8,
        8,
        8,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? cardColor.withOpacity(0.5) : Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        children: [
          _buildKey('1'),
          _buildKey('2'),
          _buildKey('3'),
          _buildKey('4'),
          _buildKey('5'),
          _buildKey('6'),
          _buildKey('7'),
          _buildKey('8'),
          _buildKey('9'),
          _buildKey('.'),
          _buildKey('0'),
          _buildKey('backspace', isIcon: true),
        ],
      ),
    );
  }

  Widget _buildKey(String key, {bool isIcon = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(key),
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: isIcon
              ? const Icon(Icons.backspace_outlined, size: 24)
              : Text(
                  key,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
