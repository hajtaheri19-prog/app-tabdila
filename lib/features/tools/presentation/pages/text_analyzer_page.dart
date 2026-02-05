import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

class TextAnalyzerPage extends StatefulWidget {
  const TextAnalyzerPage({super.key});

  @override
  State<TextAnalyzerPage> createState() => _TextAnalyzerPageState();
}

class _TextAnalyzerPageState extends State<TextAnalyzerPage> {
  final TextEditingController _controller = TextEditingController();

  int _charCount = 0;
  int _wordCount = 0;
  int _sentenceCount = 0;
  int _paragraphCount = 0;
  int _tokenEstimate = 0;
  int _uniqueWords = 0;
  String _readingTime = '۰ ثانیه';

  void _analyze(String text) {
    if (text.trim().isEmpty) {
      setState(() {
        _charCount = 0;
        _wordCount = 0;
        _sentenceCount = 0;
        _paragraphCount = 0;
        _tokenEstimate = 0;
        _uniqueWords = 0;
        _readingTime = '۰ ثانیه';
      });
      return;
    }

    final cleanText = text.trim();
    final wordsList =
        cleanText.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

    setState(() {
      _charCount = text.length;
      _wordCount = wordsList.length;
      _sentenceCount = cleanText
          .split(RegExp(r'[.!?؟]+'))
          .where((s) => s.trim().isNotEmpty)
          .length;
      _paragraphCount = cleanText
          .split(RegExp(r'\n\s*\n'))
          .where((p) => p.trim().isNotEmpty)
          .length;

      // OpenAI Token Estimate: approx 0.75 words per token for English, but for Persian/mixed it's more.
      _tokenEstimate = (text.length / 3).ceil();

      _uniqueWords = wordsList.map((w) => w.toLowerCase()).toSet().length;

      // Reading Time: Avg 200 words per minute
      int totalSeconds = ((_wordCount / 200) * 60).ceil();
      if (totalSeconds < 60) {
        _readingTime = '${DigitUtils.toFarsi(totalSeconds.toString())} ثانیه';
      } else {
        _readingTime =
            '${DigitUtils.toFarsi((totalSeconds / 60).floor().toString())} دقیقه';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const accentBlue = Color(0xFF00D2FF);
    const backgroundDark = Color(0xFF191022);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Decorative Blurred Circles
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
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: accentBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(primaryColor),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatsCarousel(primaryColor, accentBlue),
                          const SizedBox(height: 24),
                          _buildInputArea(primaryColor),
                          const SizedBox(height: 32),
                          _buildTechnicalSection(primaryColor, accentBlue),
                          const SizedBox(height: 32),
                          _buildSocialLimits(primaryColor, accentBlue),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: primary.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            'تحلیلگر همه‌جانبه متن',
            style: GoogleFonts.vazirmatn(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_suggest_outlined,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCarousel(Color primary, Color accent) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatChip(
              Icons.text_fields, 'کاراکتر', _charCount.toString(), primary),
          _buildStatChip(Icons.pin, 'کلمه', _wordCount.toString(), primary),
          _buildStatChip(
              Icons.short_text, 'جمله', _sentenceCount.toString(), primary),
          _buildStatChip(
              Icons.segment, 'پاراگراف', _paragraphCount.toString(), primary),
          _buildStatChip(Icons.schedule, 'مطالعه', _readingTime, accent,
              isFarsiValue: false),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value, Color color,
      {bool isFarsiValue = true}) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.vazirmatn(color: Colors.white70, fontSize: 11),
          ),
          Text(
            isFarsiValue ? DigitUtils.toFarsi(value) : value,
            style: GoogleFonts.vazirmatn(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Text(
            'متن خود را برای تحلیل وارد کنید',
            style: GoogleFonts.vazirmatn(color: Colors.white38, fontSize: 13),
          ),
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 10,
                onChanged: _analyze,
                style: GoogleFonts.vazirmatn(
                    color: Colors.white, fontSize: 15, height: 1.6),
                decoration: InputDecoration(
                  hintText:
                      'تبدیلا آماده تحلیل متن‌های طولانی و کوتاهِ شماست...',
                  hintStyle: GoogleFonts.vazirmatn(
                      color: Colors.white12, fontSize: 14),
                  contentPadding: const EdgeInsets.only(
                      left: 20, right: 20, top: 20, bottom: 80),
                  border: InputBorder.none,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      _analyze('');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _controller.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('کپی شد')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: primary.withOpacity(0.3), blurRadius: 15)
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.content_copy,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'کپی',
                            style: GoogleFonts.vazirmatn(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnicalSection(Color primary, Color accent) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.white38, size: 18),
            const SizedBox(width: 8),
            Text(
              'جزئیات فنی و هوش مصنوعی',
              style: GoogleFonts.vazirmatn(
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildTechCard('OPENAI TOKENS',
                    _tokenEstimate.toString(), 'تخمین توکن مصرفی', primary)),
            const SizedBox(width: 12),
            Expanded(
                child: _buildTechCard('UNIQUE WORDS', _uniqueWords.toString(),
                    'کلمات منحصر به فرد', accent)),
          ],
        ),
      ],
    );
  }

  Widget _buildTechCard(
      String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.spaceGrotesk(
                  color: Colors.white24,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(DigitUtils.toFarsi(value),
              style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: GoogleFonts.vazirmatn(
                  color: color.withOpacity(0.7), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildSocialLimits(Color primary, Color accent) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.share_outlined, color: Colors.white38, size: 18),
            const SizedBox(width: 8),
            Text(
              'محدودیت شبکه‌های اجتماعی',
              style: GoogleFonts.vazirmatn(
                  color: Colors.white38,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              _buildLimitBar(
                  'توییتر (X)', _charCount, 280, primary, Icons.grid_3x3),
              const SizedBox(height: 20),
              _buildLimitBar('اینستاگرام (کپشن)', _charCount, 2200, accent,
                  Icons.photo_camera_outlined),
              const SizedBox(height: 20),
              _buildLimitBar('پیامک (فارسی)', _charCount, 70,
                  Colors.purpleAccent, Icons.sms_outlined),
              const SizedBox(height: 20),
              _buildLimitBar('لینکدین (پست)', _charCount, 3000,
                  Colors.blueAccent, Icons.work_outline),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLimitBar(
      String label, int current, int max, Color color, IconData icon) {
    double progress = (current / max).clamp(0.0, 1.0);
    bool overLimit = current > max;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: Colors.white60),
                const SizedBox(width: 8),
                Text(label,
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: Colors.white70)),
              ],
            ),
            Text(
              '${DigitUtils.toFarsi(current.toString())} / ${DigitUtils.toFarsi(max.toString())}',
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  color: overLimit ? Colors.redAccent : Colors.white24),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(
                overLimit ? Colors.redAccent : color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
