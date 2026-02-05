import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BinaryConverterPage extends StatefulWidget {
  const BinaryConverterPage({super.key});

  @override
  State<BinaryConverterPage> createState() => _BinaryConverterPageState();
}

class _BinaryConverterPageState extends State<BinaryConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  bool _isTextToBinary = true;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_convert);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _convert() {
    String input = _inputController.text;
    if (input.isEmpty) {
      _outputController.clear();
      setState(() {});
      return;
    }

    try {
      if (_isTextToBinary) {
        List<int> bytes = utf8.encode(input);
        _outputController.text = bytes
            .map((byte) => byte.toRadixString(2).padLeft(8, '0'))
            .join(' ');
      } else {
        List<String> binaryParts =
            input.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
        List<int> bytes =
            binaryParts.map((b) => int.parse(b, radix: 2)).toList();
        _outputController.text = utf8.decode(bytes);
      }
    } catch (e) {
      _outputController.text = 'خطا در تبدیل: فرمت نامعتبر';
    }
    setState(() {});
  }

  void _clear() {
    _inputController.clear();
    _outputController.clear();
  }

  void _paste() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _inputController.text = data!.text!;
    }
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _outputController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('در حافظه کپی شد'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _swap() {
    setState(() {
      _isTextToBinary = !_isTextToBinary;
      String temp = _inputController.text;
      _inputController.text = _outputController.text;
      _outputController.text = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    final surfaceColor = isDark ? const Color(0xFF2D1B3E) : Colors.white;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);

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
          'مبدل متن و باینری',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Glows
          if (isDark) ...[
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],

          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Input Section
                _buildSectionHeader(
                  _isTextToBinary ? 'متن (فارسی/انگلیسی)' : 'کد باینری',
                  _isTextToBinary ? 'UTF-8 Supported' : 'AUTO',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildTextArea(
                  controller: _inputController,
                  hint: _isTextToBinary
                      ? 'متن خود را اینجا وارد کنید...'
                      : '01001000 01101001...',
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  primaryColor: primaryColor,
                  isInput: true,
                  actions: [
                    _buildActionButton(
                      Icons.delete,
                      'پاک کردن',
                      _clear,
                      isDark,
                    ),
                    _buildActionButton(
                      Icons.content_paste,
                      'جایگذاری',
                      _paste,
                      isDark,
                      isPrimary: true,
                    ),
                  ],
                ),

                // Swap Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Divider(
                        color: (isDark ? Colors.white : Colors.black)
                            .withOpacity(0.05),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: _swap,
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.swap_vert,
                              color: primaryColor,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Output Section
                _buildSectionHeader(
                  _isTextToBinary ? 'کد باینری' : 'متن (فارسی/انگلیسی)',
                  _isTextToBinary ? 'AUTO' : 'UTF-8 Supported',
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildTextArea(
                  controller: _outputController,
                  hint: _isTextToBinary
                      ? '01001000 01101001...'
                      : 'نتیجه در اینجا ظاهر می‌شود...',
                  isDark: isDark,
                  surfaceColor: surfaceColor,
                  primaryColor: primaryColor,
                  isReadOnly: true,
                  actions: [
                    Text(
                      '${_outputController.text.length} chars',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Spacer(),
                    _buildActionButton(Icons.share, 'اشتراک', () {}, isDark),
                    _buildActionButton(
                      Icons.content_copy,
                      'کپی',
                      _copy,
                      isDark,
                      isPrimary: true,
                    ),
                  ],
                ),

                const SizedBox(height: 48),
                Text(
                  'تبدیلا - ابزار کاربردی تبدیل',
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

  Widget _buildSectionHeader(String title, String tag, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tag,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            color: const Color(0xFF7F13EC),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.vazirmatn(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    bool isReadOnly = false,
    bool isInput = false,
    required List<Widget> actions,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(isReadOnly ? 0.5 : 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            maxLines: 6,
            minLines: 6,
            readOnly: isReadOnly,
            style: isInput && _isTextToBinary
                ? GoogleFonts.vazirmatn(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  )
                : GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  GoogleFonts.vazirmatn(color: Colors.grey[600], fontSize: 14),
              contentPadding: const EdgeInsets.all(20),
              border: InputBorder.none,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                ),
              ),
            ),
            child: Row(
              children: actions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDark, {
    bool isPrimary = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? (isDark ? Colors.white : const Color(0xFF7F13EC))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: isPrimary
                ? null
                : Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isPrimary
                    ? (isDark ? const Color(0xFF7F13EC) : Colors.white)
                    : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.vazirmatn(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isPrimary
                      ? (isDark ? const Color(0xFF7F13EC) : Colors.white)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
