import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/digit_utils.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/data/national_id_city_data.dart';

class NationalIdValidatorPage extends StatefulWidget {
  const NationalIdValidatorPage({super.key});

  @override
  State<NationalIdValidatorPage> createState() =>
      _NationalIdValidatorPageState();
}

class _NationalIdValidatorPageState extends State<NationalIdValidatorPage> {
  final List<TextEditingController> _controllers =
      List.generate(10, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(10, (_) => FocusNode());

  bool? _isValid;
  String _city = '';
  String _province = '';
  bool _isLoading = false;

  // Uses imported nationalIdCityData

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool _validateNationalCode(String code) {
    if (code.length != 10) return false;
    if (RegExp(r'^(\d)\1{9}$').hasMatch(code)) return false;

    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(code[i]) * (10 - i);
    }

    int remainder = sum % 11;
    int controlDigit = int.parse(code[9]);

    if (remainder < 2) {
      return controlDigit == remainder;
    } else {
      return controlDigit == (11 - remainder);
    }
  }

  void _checkCode() async {
    String code = _controllers.map((e) => e.text).join();
    if (code.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً ۱۰ رقم کدملی را وارد کنید')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isValid = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    bool valid = _validateNationalCode(code);
    String prefix = code.substring(0, 3);

    setState(() {
      _isLoading = false;
      _isValid = valid;
      if (valid && nationalIdCityData.containsKey(prefix)) {
        _province = nationalIdCityData[prefix]![0];
        _city = nationalIdCityData[prefix]![1];
      } else {
        _province = 'نامشخص';
        _city = 'نامشخص';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);
    const successColor = Color(0xFF00FF9D);
    const errorColor = Color(0xFFFF3131);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'اعتبارسنجی کد ملی',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {},
            color: primaryColor,
          ),
        ],
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
                    const SizedBox(height: 20),
                    Text(
                      'لطفاً ${DigitUtils.toFarsi('10')} رقم کد ملی را وارد نمایید',
                      style: GoogleFonts.vazirmatn(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildSegmentedInput(isDark, surfaceDark, primaryColor),
                    const SizedBox(height: 40),
                    _buildValidateButton(primaryColor),
                    const SizedBox(height: 32),
                    _buildScanningStatus(primaryColor),
                    const SizedBox(height: 32),
                    if (_isValid != null) ...[
                      if (_isValid!)
                        _buildSuccessResult(successColor, isDark)
                      else
                        _buildErrorResult(errorColor, isDark),
                    ],
                    const SizedBox(height: 60),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
          _buildNavItem(Icons.badge, 'کد ملی', true, () {}),
          _buildNavItem(
              Icons.credit_card,
              'کارت بانکی',
              false,
              () => Navigator.pushReplacementNamed(
                  context, AppRoutes.bankCardValidator)),
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

  Widget _buildSegmentedInput(bool isDark, Color surface, Color primary) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(10, (index) {
          return Expanded(
            child: Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isDark ? surface : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: _focusNodes[index].hasFocus
                        ? primary
                        : primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 9) {
                    _focusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _focusNodes[index - 1].requestFocus();
                  }
                  if (index == 9 && value.isNotEmpty) {
                    _focusNodes[index].unfocus();
                    _checkCode();
                  }
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildValidateButton(Color primary) {
    return GestureDetector(
      onTap: _isLoading ? null : _checkCode,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.fingerprint, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'بررسی صحت کد',
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
    );
  }

  Widget _buildScanningStatus(Color primary) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.security, color: primary.withOpacity(0.6)),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, primary.withOpacity(0.5)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessResult(Color success, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            success.withOpacity(0.1),
            success.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: success.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, color: success, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'کد ملی صحیح است',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: success,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem('استان', _province, isDark),
                    ),
                    Expanded(
                      child: _buildInfoItem('شهر صادرکننده', _city, isDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorResult(Color error, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            error.withOpacity(0.1),
            error.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: error.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cancel, color: error, size: 28),
          ),
          const SizedBox(width: 16),
          Text(
            'کد ملی نامعتبر است',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.vazirmatn(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.vazirmatn(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          const Icon(Icons.verified_user, color: Color(0xFF7F13EC), size: 40),
          const SizedBox(height: 8),
          Text(
            'امنیت اطلاعات شما با پروتکل‌های پیشرفته تبدیلا تضمین شده است',
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
