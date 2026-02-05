import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class SummarizerPage extends StatefulWidget {
  const SummarizerPage({super.key});

  @override
  State<SummarizerPage> createState() => _SummarizerPageState();
}

class _SummarizerPageState extends State<SummarizerPage> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  String _selectedLength = 'کوتاه';
  String _selectedFormat = 'موردی';
  bool _isLoading = false;
  bool _showResult = false;

  void _generateSummary() {
    if (_textController.text.isEmpty && _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفا متن یا لینک را وارد کنید')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _showResult = false;
    });

    // Simulate AI processing
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showResult = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colors from design
    final Color primary = const Color(0xFF7F13EC);
    final Color accent = const Color(0xFF00E5FF);
    final Color backgroundLight = const Color(0xFFF7F6F8);
    final Color backgroundDark = const Color(0xFF191022);
    final Color surfaceDark = const Color(0xFF261933);
    final Color inputBgDark = const Color(0xFF362348);
    final Color textSecondary = const Color(0xFFAD92C9);

    final backgroundColor = isDark ? backgroundDark : backgroundLight;
    final surfaceColor = isDark ? surfaceDark : Colors.white;
    final borderColor = isDark ? const Color(0xFF4D3267) : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark, primary),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInputArea(isDark, surfaceColor, inputBgDark, primary,
                        textSecondary),
                    const SizedBox(height: 24),
                    _buildUrlInput(isDark, surfaceColor, borderColor, primary,
                        textSecondary),
                    const SizedBox(height: 24),
                    _buildSettings(isDark, surfaceColor, borderColor, primary,
                        accent, textSecondary),
                    const SizedBox(height: 24),
                    _buildActionButton(primary),
                    if (_showResult) ...[
                      const SizedBox(height: 24),
                      _buildResultSection(
                          isDark, surfaceColor, primary, accent, textSecondary),
                    ],
                    const SizedBox(height: 48),
                    _buildFooter(textSecondary, primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8))
            .withOpacity(0.8),
        border: Border(
            bottom: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF261933) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_forward,
                  color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: Text(
              'خلاصه ساز هوشمند',
              textAlign: TextAlign.center,
              style: GoogleFonts.vazirmatn(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [primary, Colors.purpleAccent]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: primary.withOpacity(0.5), blurRadius: 8),
              ],
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isDark, Color surface, Color inputBg,
      Color primary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'متن ورودی',
              style: GoogleFonts.vazirmatn(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              'حداکثر ۵۰۰۰ کلمه',
              style: GoogleFonts.vazirmatn(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? inputBg : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ],
              ),
              child: TextField(
                controller: _textController,
                maxLines: 8,
                minLines: 6,
                style: GoogleFonts.vazirmatn(
                    color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText:
                      'متن طولانی خود را اینجا وارد کنید یا Paste نمایید...',
                  hintStyle: GoogleFonts.vazirmatn(
                      color: isDark ? textSecondary : Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Row(
                children: [
                  _buildSmallActionBtn(Icons.content_paste, 'جایگذاری', isDark,
                      primary, textSecondary, () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data?.text != null) {
                      setState(() {
                        _textController.text = data!.text!;
                      });
                    }
                  }),
                  const SizedBox(width: 8),
                  _buildSmallActionBtn(Icons.close, 'پاک کردن', isDark,
                      Colors.red, textSecondary, () {
                    setState(() {
                      _textController.clear();
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallActionBtn(IconData icon, String label, bool isDark,
      Color hoverColor, Color textSecondary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF261933).withOpacity(0.8)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 14, color: isDark ? textSecondary : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.vazirmatn(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? textSecondary : Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlInput(bool isDark, Color surface, Color borderColor,
      Color primary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خلاصه سازی از لینک',
          style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.link, color: textSecondary),
              ),
              Expanded(
                child: TextField(
                  controller: _urlController,
                  style: GoogleFonts.vazirmatn(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'https://example.com/article',
                    hintStyle: GoogleFonts.vazirmatn(
                        color: isDark ? textSecondary : Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettings(bool isDark, Color surface, Color borderColor,
      Color primary, Color accent, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تنظیمات خلاصه',
            style: GoogleFonts.vazirmatn(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black)),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('طول متن:',
                style:
                    GoogleFonts.vazirmatn(fontSize: 12, color: textSecondary)),
            const SizedBox(height: 8),
            Row(
              children: ['کوتاه', 'متوسط', 'با جزئیات'].map((len) {
                final selected = _selectedLength == len;
                return GestureDetector(
                  onTap: () => setState(() => _selectedLength = len),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? primary : surface,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: selected ? primary : borderColor),
                    ),
                    child: Text(
                      len,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? Colors.white
                            : (isDark ? Colors.grey[300] : Colors.grey[600]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('فرمت خروجی:',
                style:
                    GoogleFonts.vazirmatn(fontSize: 12, color: textSecondary)),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildFormatChip('موردی', Icons.format_list_bulleted, isDark,
                    surface, borderColor, accent),
                const SizedBox(width: 8),
                _buildFormatChip('پاراگراف', Icons.segment, isDark, surface,
                    borderColor, accent),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatChip(String label, IconData icon, bool isDark,
      Color surface, Color borderColor, Color accent) {
    final selected = _selectedFormat == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFormat = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? accent : surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? accent : borderColor),
          boxShadow: selected
              ? [BoxShadow(color: accent.withOpacity(0.3), blurRadius: 10)]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: selected
                    ? Colors.black
                    : (isDark ? Colors.grey[300] : Colors.grey[600])),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.vazirmatn(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: selected
                    ? Colors.black
                    : (isDark ? Colors.grey[300] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(Color primary) {
    return GestureDetector(
      onTap: _isLoading ? null : _generateSummary,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [primary, const Color(0xFF9D4EDD)]),
          boxShadow: [
            BoxShadow(
                color: primary.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'شروع خلاصه سازی',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildResultSection(bool isDark, Color surface, Color primary,
      Color accent, Color textSecondary) {
    return Container(
      padding: const EdgeInsets.all(1), // Border width
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.2), Colors.transparent],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: isDark ? accent : primary),
                    const SizedBox(width: 8),
                    Text(
                      'نتیجه هوش مصنوعی',
                      style: GoogleFonts.vazirmatn(
                        fontWeight: FontWeight.bold,
                        color: isDark ? accent : primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.content_copy,
                            size: 20, color: textSecondary),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.share, size: 20, color: textSecondary),
                        onPressed: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'این ابزار هوشمند با استفاده از الگوریتم‌های پیشرفته پردازش زبان طبیعی، متن‌های طولانی شما را تحلیل کرده و نکات کلیدی آن را استخراج می‌کند.',
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                height: 1.8,
                color: isDark ? Colors.grey[200] : Colors.grey[800],
              ),
            ),
            if (_selectedFormat == 'موردی') ...[
              const SizedBox(height: 12),
              _buildBulletPoint('افزایش سرعت مطالعه', isDark, accent, primary),
              _buildBulletPoint(
                  'دقت بالا در درک مطلب', isDark, accent, primary),
              _buildBulletPoint(
                  'پشتیبانی از زبان فارسی', isDark, accent, primary),
            ],
            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.1)),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _generateSummary,
                icon: Icon(Icons.refresh,
                    size: 16, color: isDark ? accent : primary),
                label: Text('تولید مجدد',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isDark ? accent : primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(
      String text, bool isDark, Color accent, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                  color: isDark ? accent : primary, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Text(text,
              style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildFooter(Color textSecondary, Color primary) {
    return Column(
      children: [
        Text(
          'POWERED BY TABDILA AI',
          style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              color: textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
                colors: [Colors.transparent, primary, Colors.transparent]),
          ),
        ),
      ],
    );
  }
}
