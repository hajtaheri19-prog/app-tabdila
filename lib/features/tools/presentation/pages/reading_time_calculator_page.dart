import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

class ReadingTimeCalculatorPage extends StatefulWidget {
  const ReadingTimeCalculatorPage({super.key});

  @override
  State<ReadingTimeCalculatorPage> createState() =>
      _ReadingTimeCalculatorPageState();
}

class _ReadingTimeCalculatorPageState extends State<ReadingTimeCalculatorPage> {
  final TextEditingController _textController = TextEditingController();
  int _wordCount = 0;
  int _charCount = 0;
  int _readingTimeMinutes = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_analyzeText);
  }

  @override
  void dispose() {
    _textController.removeListener(_analyzeText);
    _textController.dispose();
    super.dispose();
  }

  void _analyzeText() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _wordCount = 0;
        _charCount = 0;
        _readingTimeMinutes = 0;
      });
      return;
    }

    final words =
        text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final chars = text.length;

    // Average reading speed: 180 words per minute for Persian/Arabic
    const wpm = 180;
    final minutes = (words.length / wpm).ceil();

    setState(() {
      _wordCount = words.length;
      _charCount = chars;
      _readingTimeMinutes = minutes;
    });
  }

  void _clearText() {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);
    const textSecondaryDark = Color(0xFFAD92C9);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'محاسبه‌گر زمان مطالعه',
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Text Input Section
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: isDark ? surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF4D3267)
                              : Colors.grey[200]!,
                        ),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            )
                        ],
                      ),
                      child: Stack(
                        children: [
                          TextField(
                            controller: _textController,
                            maxLines: null,
                            expands: true,
                            style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'متن خود را اینجا وارد کنید تا زمان مطالعه و تعداد کلمات آن محاسبه شود...',
                              hintStyle: GoogleFonts.vazirmatn(
                                color: isDark
                                    ? textSecondaryDark.withOpacity(0.5)
                                    : Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(20),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Icon(
                              Icons.edit_note,
                              color: isDark
                                  ? const Color(0xFF4D3267)
                                  : Colors.grey[300],
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: _clearText,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF362348)
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.backspace, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'پاک کردن',
                                    style: GoogleFonts.vazirmatn(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: _analyzeText,
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.analytics,
                                      size: 20, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'تحلیل متن',
                                    style: GoogleFonts.vazirmatn(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Result Stats
                    _buildReadingTimeCard(
                        isDark, primaryColor, surfaceDark, textSecondaryDark),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'تعداد کلمات',
                            _wordCount.toString(),
                            Icons.menu_book,
                            isDark,
                            surfaceDark,
                            textSecondaryDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'تعداد کاراکتر',
                            _charCount.toString(),
                            Icons.abc,
                            isDark,
                            surfaceDark,
                            textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingTimeCard(
      bool isDark, Color primary, Color surface, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF362348) : Colors.grey[100]!,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.timer, color: primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'زمان تخمینی مطالعه',
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? secondary : Colors.grey[500],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    DigitUtils.toFarsi(_readingTimeMinutes.toString()),
                    style: GoogleFonts.manrope(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'دقیقه',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDark,
      Color surface, Color secondary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF362348) : Colors.grey[100]!,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
            )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 18, color: isDark ? secondary : Colors.grey[500]),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? secondary : Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DigitUtils.toFarsi(value),
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
