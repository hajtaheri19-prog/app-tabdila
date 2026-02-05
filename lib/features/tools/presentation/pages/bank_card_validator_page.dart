import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/digit_utils.dart';
import '../../../../core/routes/app_routes.dart';

class BankCardValidatorPage extends StatefulWidget {
  const BankCardValidatorPage({super.key});

  @override
  State<BankCardValidatorPage> createState() => _BankCardValidatorPageState();
}

class _BankCardValidatorPageState extends State<BankCardValidatorPage> {
  final TextEditingController _controller = TextEditingController();
  bool? _isValid;
  String _bankName = '';
  Color _bankColor = const Color(0xFF7F13EC);
  bool _isLoading = false;

  final Map<String, Map<String, dynamic>> _bankData = {
    '603799': {'name': 'بانک ملی ایران', 'color': Color(0xFF1E40AF)},
    '589210': {'name': 'بانک سپاه', 'color': Color(0xFF991B1B)},
    '627353': {'name': 'بانک تجارت', 'color': Color(0xFF1E3A8A)},
    '603769': {'name': 'بانک صادرات', 'color': Color(0xFF1D4ED8)},
    '621986': {'name': 'بانک سامان', 'color': Color(0xFF0284C7)},
    '627412': {'name': 'بانک پاسارگاد', 'color': Color(0xFFD97706)},
    '622106': {'name': 'بانک پارسیان', 'color': Color(0xFF854D0E)},
    '610433': {'name': 'بانک ملت', 'color': Color(0xFFDC2626)},
    '635235': {'name': 'بانک شهر', 'color': Color(0xFFE11D48)},
    '502229': {'name': 'بانک پاسارگاد', 'color': Color(0xFFD97706)},
    '636214': {'name': 'بانک آینده', 'color': Color(0xFF7C3AED)},
    '627760': {'name': 'پست بانک', 'color': Color(0xFF15803D)},
    '603770': {'name': 'بانک کشاورزی', 'color': Color(0xFF166534)},
    '504172': {'name': 'بانک رسالت', 'color': Color(0xFF1E3A8A)},
    '628023': {'name': 'بانک مسکن', 'color': Color(0xFFEA580C)},
  };

  void _validate() async {
    String card = DigitUtils.clean(_controller.text);
    if (card.length < 16) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً ۱۶ رقم شماره کارت را وارد کنید')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isValid = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    bool valid = DigitUtils.isLuhnValid(card);
    String bin = card.substring(0, 6);

    setState(() {
      _isLoading = false;
      _isValid = valid;
      if (_bankData.containsKey(bin)) {
        _bankName = _bankData[bin]!['name'];
        _bankColor = _bankData[bin]!['color'];
      } else {
        _bankName = 'بانک ناشناس';
        _bankColor = const Color(0xFF7F13EC);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'اعتبارسنجی کارت بانکی',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'لطفاً ۱۶ رقم شماره کارت خود را وارد کنید',
                      style: GoogleFonts.vazirmatn(
                          color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 32),
                    _buildCardInput(isDark, surfaceDark),
                    const SizedBox(height: 40),
                    _buildValidateButton(),
                    const SizedBox(height: 40),
                    if (_isValid != null) ...[
                      if (_isValid!)
                        _buildSuccessCard(isDark)
                      else
                        _buildErrorCard(isDark),
                    ],
                  ],
                ),
              ),
            ),
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInput(bool isDark, Color surface) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, right: 4),
            child: Text('شماره ۱۶ رقمی کارت',
                style: GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey)),
          ),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
                fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardFormatter(),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '---- ---- ---- ----',
              hintStyle: TextStyle(color: Colors.grey, letterSpacing: 2),
            ),
            onChanged: (v) {
              if (DigitUtils.clean(v).length >= 6) {
                String bin = DigitUtils.clean(v).substring(0, 6);
                if (_bankData.containsKey(bin)) {
                  setState(() {
                    _bankName = _bankData[bin]!['name'];
                    _bankColor = _bankData[bin]!['color'];
                  });
                }
              }
              if (DigitUtils.clean(v).length == 16) {
                _validate();
              }
            },
          ),
          if (_bankName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: _bankColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(_bankName,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 12,
                          color: _bankColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildValidateButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _validate,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF7F13EC),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF7F13EC).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card, color: Colors.white),
                    const SizedBox(width: 12),
                    Text('بررسی اعتبار کارت',
                        style: GoogleFonts.vazirmatn(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('شماره کارت معتبر است',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                const SizedBox(height: 4),
                Text('صادر شده توسط: $_bankName',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 32),
          const SizedBox(width: 16),
          Text('شماره کارت نامعتبر است',
              style: GoogleFonts.vazirmatn(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F162A) : Colors.white,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
              Icons.badge,
              'کد ملی',
              false,
              () => Navigator.pushReplacementNamed(
                  context, AppRoutes.nationalIdValidator)),
          _buildNavItem(Icons.credit_card, 'کارت بانکی', true, () {}),
          _buildNavItem(Icons.history, 'تاریخچه', false, () {}),
          _buildNavItem(Icons.settings, 'تنظیمات', false, () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool active, VoidCallback onTap) {
    final color = active ? const Color(0xFF7F13EC) : Colors.grey;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(label,
              style: GoogleFonts.vazirmatn(
                  fontSize: 10,
                  color: color,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _CardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
