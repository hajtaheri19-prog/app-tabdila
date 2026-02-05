import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({super.key});

  @override
  State<PasswordGeneratorPage> createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage> {
  double _length = 16;
  bool _useLowercase = true;
  bool _useUppercase = true;
  bool _useNumbers = true;
  bool _useSymbols = true;
  bool _excludeSimilar = false;
  bool _excludeAmbiguous = false;
  String _password = '';
  double _strength = 0.9;
  String _strengthLabel = 'قوی';

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  void _generatePassword() {
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
    const String similar = 'il1Lo0O';
    const String ambiguous = '{}[]()/\'"`~,;:.<>';

    String chars = '';
    if (_useLowercase) chars += lowercase;
    if (_useUppercase) chars += uppercase;
    if (_useNumbers) chars += numbers;
    if (_useSymbols) chars += symbols;

    if (_excludeSimilar) {
      for (var s in similar.split('')) {
        chars = chars.replaceAll(s, '');
      }
    }
    if (_excludeAmbiguous) {
      for (var a in ambiguous.split('')) {
        chars = chars.replaceAll(a, '');
      }
    }

    if (chars.isEmpty) {
      setState(() {
        _password = 'یک گزینه را انتخاب کنید';
        _strength = 0;
        _strengthLabel = 'نامعتبر';
      });
      return;
    }

    final random = Random.secure();
    String newPassword = List.generate(_length.toInt(), (index) {
      return chars[random.nextInt(chars.length)];
    }).join();

    setState(() {
      _password = newPassword;
      _calculateStrength();
    });
  }

  void _calculateStrength() {
    // Simple strength calculation logic
    double score = 0;
    if (_useLowercase) score += 0.2;
    if (_useUppercase) score += 0.2;
    if (_useNumbers) score += 0.2;
    if (_useSymbols) score += 0.2;
    score += (_length / 32) * 0.2;

    _strength = score.clamp(0.0, 1.0);
    if (_strength < 0.3) {
      _strengthLabel = 'ضعیف';
    } else if (_strength < 0.6) {
      _strengthLabel = 'متوسط';
    } else {
      _strengthLabel = 'قوی';
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('رمز عبور در حافظه کپی شد'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);
    final textSecondary = isDark ? const Color(0xFFAD92C9) : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        title: Text(
          'تولید رمز عبور قوی',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 12),
                // Password Display Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: primaryColor.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SelectableText(
                        _password,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'رمز عبور تولید شده',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Share functionality
                            },
                            icon: const Icon(Icons.share),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.05),
                              foregroundColor:
                                  isDark ? Colors.white : primaryColor,
                              side: BorderSide(
                                color: primaryColor.withOpacity(0.2),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _copyToClipboard,
                            icon: const Icon(Icons.content_copy, size: 18),
                            label: const Text('کپی رمز'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Strength Meter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(_strength * 100).toInt()}%',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'قدرت رمز: $_strengthLabel',
                          style: GoogleFonts.vazirmatn(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified_user,
                          color: Colors.green,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _strength,
                    minHeight: 10,
                    backgroundColor:
                        isDark ? const Color(0xFF4D3267) : Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(Colors.red, Colors.green, _strength) ??
                          primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Length Slider
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
                        '${_length.toInt()} کاراکتر',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Text(
                      'طول رمز',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _length,
                  min: 4,
                  max: 32,
                  onChanged: (val) {
                    setState(() {
                      _length = val;
                      _generatePassword();
                    });
                  },
                  activeColor: primaryColor,
                ),
                const SizedBox(height: 24),

                // Advanced Settings Title
                Text(
                  'تنظیمات پیشرفته',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Toggles
                _buildToggle(
                  title: 'حروف کوچک (a-z)',
                  value: _useLowercase,
                  onChanged: (val) => setState(() {
                    _useLowercase = val;
                    _generatePassword();
                  }),
                  isDark: isDark,
                  primaryColor: primaryColor,
                ),
                _buildToggle(
                  title: 'حروف بزرگ (A-Z)',
                  value: _useUppercase,
                  onChanged: (val) => setState(() {
                    _useUppercase = val;
                    _generatePassword();
                  }),
                  isDark: isDark,
                  primaryColor: primaryColor,
                ),
                _buildToggle(
                  title: 'اعداد (0-9)',
                  value: _useNumbers,
                  onChanged: (val) => setState(() {
                    _useNumbers = val;
                    _generatePassword();
                  }),
                  isDark: isDark,
                  primaryColor: primaryColor,
                ),
                _buildToggle(
                  title: 'نمادها (!@#\$)',
                  value: _useSymbols,
                  onChanged: (val) => setState(() {
                    _useSymbols = val;
                    _generatePassword();
                  }),
                  isDark: isDark,
                  primaryColor: primaryColor,
                ),
                _buildToggle(
                  title: 'حذف کاراکترهای مشابه',
                  subtitle: '(O, 0, l, 1)',
                  value: _excludeSimilar,
                  onChanged: (val) => setState(() {
                    _excludeSimilar = val;
                    _generatePassword();
                  }),
                  isDark: isDark,
                  primaryColor: primaryColor,
                ),
                _buildToggle(
                  title: 'حذف کاراکترهای مبهم',
                  subtitle: '({[]})',
                  value: _excludeAmbiguous,
                  onChanged: (val) => setState(() {
                    _excludeAmbiguous = val;
                    _generatePassword();
                  }),
                  isDark: isDark,
                  primaryColor: primaryColor,
                  isLast: true,
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),

          // Generate Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _generatePassword,
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'تولید رمز جدید',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    required Color primaryColor,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey[200]!,
                ),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: primaryColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
