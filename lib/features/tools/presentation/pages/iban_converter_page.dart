import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class IbanConverterPage extends StatefulWidget {
  const IbanConverterPage({super.key});

  @override
  State<IbanConverterPage> createState() => _IbanConverterPageState();
}

class _IbanConverterPageState extends State<IbanConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  bool _isCardMode = true;
  String? _ibanResult;
  String? _accountOwner;
  String? _bankName;

  final List<Map<String, String>> _history = [
    {
      'name': 'علی حسینی',
      'iban': 'IR45...9012',
    },
    {
      'name': 'سارا محمدی',
      'iban': 'IR88...3344',
    },
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _calculateIban() {
    if (_inputController.text.isEmpty) return;

    // Simulate IBAN calculation
    setState(() {
      _ibanResult = 'IR12 0170 0000 0012 3456 78';
      _accountOwner = 'آقای محمد رضایی';
      _bankName = 'ملی ایران';
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'کپی شد',
          style: GoogleFonts.vazirmatn(),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF1337EC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF1337EC);
    final backgroundColor =
        isDark ? const Color(0xFF101322) : const Color(0xFFF6F6F8);
    final surfaceColor = isDark ? const Color(0xFF1A1F36) : Colors.white;
    final textSecondary = const Color(0xFF929BC9);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_forward,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'تبدیل حساب به شبا',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Segmented Control
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isCardMode = true),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _isCardMode
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'شماره کارت',
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _isCardMode
                                          ? Colors.white
                                          : textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isCardMode = false),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: !_isCardMode
                                      ? primaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    'شماره حساب',
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: !_isCardMode
                                          ? Colors.white
                                          : textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Input Section
                    Text(
                      'شماره کارت یا حساب خود را وارد کنید',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Input Field
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _inputController,
                              textDirection: TextDirection.ltr,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                color: isDark ? Colors.white : Colors.black87,
                                letterSpacing: 1,
                              ),
                              decoration: InputDecoration(
                                hintText: '---- ---- ---- ----',
                                hintStyle: GoogleFonts.manrope(
                                  color: textSecondary.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                          // Bank Logo
                          Container(
                            margin: const EdgeInsets.only(left: 12),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.yellow, Colors.orange],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'BMI',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _calculateIban,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          shadowColor: primaryColor.withOpacity(0.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calculate, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'محاسبه شبا',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (_ibanResult != null) ...[
                      const SizedBox(height: 24),

                      // Divider
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Result Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نتیجه محاسبه',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: Colors.green[400],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'معتبر',
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 12,
                                    color: Colors.green[400],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Result Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Top gradient line
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, Colors.purple],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // IBAN Number
                            Column(
                              children: [
                                Text(
                                  'IBAN NUMBER',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: textSecondary,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _ibanResult!,
                                  textDirection: TextDirection.ltr,
                                  style: GoogleFonts.manrope(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : Colors.black87,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Divider
                            Divider(
                              color: Colors.white.withOpacity(0.05),
                            ),

                            const SizedBox(height: 16),

                            // Owner and Bank Info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'نام صاحب حساب',
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _accountOwner!,
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'بانک',
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _bankName!,
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        _copyToClipboard(_ibanResult!),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.05),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.content_copy,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'کپی',
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white.withOpacity(0.05),
                                      ),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.05),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.share,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'اشتراک',
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // History Section
                    Text(
                      'تاریخچه اخیر',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // History Items
                    ...List.generate(_history.length, (index) {
                      final item = _history[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                index == 0
                                    ? Icons.account_balance
                                    : Icons.credit_card,
                                color: textSecondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name']!,
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    item['iban']!,
                                    textDirection: TextDirection.ltr,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _copyToClipboard(item['iban']!),
                              icon: Icon(
                                Icons.content_copy,
                                size: 20,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
