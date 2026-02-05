import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HafezPage extends StatefulWidget {
  const HafezPage({super.key});

  @override
  State<HafezPage> createState() => _HafezPageState();
}

class _HafezPageState extends State<HafezPage> {
  bool _isLoading = false;
  bool _showResult = false;
  Map<String, dynamic>? _currentGhazal;

  Future<void> _takeFal() async {
    setState(() {
      _isLoading = true;
      _showResult = false;
    });

    try {
      // 1. Pick random ID (1 to 495)
      final randomId = Random().nextInt(495) + 1;
      final paddedId = randomId.toString().padLeft(3, '0');
      final assetPath = 'content/ghazal/$paddedId.md';

      // 2. Read asset file
      final content = await rootBundle.loadString(assetPath);

      // 3. Parse content
      final parsed = _parseMarkdown(content);

      // Simulate a mystical delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _currentGhazal = parsed;
          _showResult = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('خطا در دریافت فال: $e', style: GoogleFonts.vazirmatn()),
          ),
        );
      }
    }
  }

  Map<String, dynamic> _parseMarkdown(String content) {
    // Simple manual parser for frontmatter
    final parts = content.split('---');
    if (parts.length < 3) return {};

    final frontmatter = parts[1];
    final body = parts.sublist(2).join('---').trim();

    // Parse YAML-like frontmatter manually
    String title = '';
    List<String> verses = [];

    final lines = frontmatter.split('\n');
    bool capturingMesra = false;

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      if (line.startsWith('title:')) {
        title = line.replaceAll('title:', '').trim();
      } else if (line.startsWith('mesra:')) {
        capturingMesra = true;
      } else if (capturingMesra && line.trim().startsWith('-')) {
        verses.add(line.trim().substring(1).trim());
      } else if (capturingMesra &&
          !line.startsWith(' ') &&
          !line.startsWith('\t')) {
        capturingMesra = false;
      }
    }

    return {
      'title': title,
      'verses': verses,
      'interpretation': body,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF7F13EC); // Main Brand Color

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8),
      body: Stack(
        children: [
          // Background Pattern or Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF2D1B4D), const Color(0xFF191022)]
                    : [const Color(0xFFEEE5F5), const Color(0xFFF7F6F8)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          if (!_showResult && !_isLoading)
                            _buildStartView(isDark),
                          if (_isLoading) _buildLoadingView(isDark),
                          if (_showResult && _currentGhazal != null)
                            _buildResultView(isDark, _currentGhazal!),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : Colors.black87),
          ),
          Text(
            'فال حافظ',
            style: GoogleFonts.vazirmatn(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.help_outline,
                color: isDark ? Colors.white54 : Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildStartView(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF7F13EC).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF7F13EC).withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.menu_book,
            size: 80,
            color: const Color(0xFF7F13EC),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'نیت کنید',
          style: GoogleFonts.vazirmatn(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ای حافظ شیرازی! تو محرم هر رازی\nتو را به خدا و به شاخ نباتت قسم می‌دهم\nکه هر چه صلاح و مصلحت می‌بینی\nبرایم آشکار سازی',
          textAlign: TextAlign.center,
          style: GoogleFonts.vazirmatn(
            fontSize: 16,
            height: 1.8,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _takeFal,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7F13EC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Text(
              'گرفتن فال',
              style: GoogleFonts.vazirmatn(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView(bool isDark) {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF7F13EC)),
            const SizedBox(height: 24),
            Text(
              'در حال تفال...',
              style: GoogleFonts.vazirmatn(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(bool isDark, Map<String, dynamic> data) {
    final verses = data['verses'] as List<String>;
    final interpretation = data['interpretation'] as String;
    final title = data['title'] as String;

    return Column(
      children: [
        // Poem Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A1B38) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
            ),
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
              Text(
                title,
                style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF7F13EC),
                ),
              ),
              const SizedBox(height: 24),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: verses.length,
                separatorBuilder: (c, i) => i % 2 != 0
                    ? const SizedBox(height: 8) // Space between couplets
                    : const SizedBox(height: 4), // Space between hemistichs
                itemBuilder: (context, index) {
                  final isEven = index % 2 == 0;
                  return Padding(
                    padding: EdgeInsets.only(
                        left: isEven ? 24.0 : 0, right: isEven ? 0 : 24.0),
                    child: Text(
                      verses[index],
                      textAlign: isEven ? TextAlign.right : TextAlign.left,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        height: 1.8,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Interpretation Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A1B38) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.black12,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'تفسیر فال',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                interpretation,
                textAlign: TextAlign.justify,
                style: GoogleFonts.vazirmatn(
                  fontSize: 16,
                  height: 1.8,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _takeFal,
            icon: const Icon(Icons.refresh),
            label: Text(
              'نیت دوباره',
              style: GoogleFonts.vazirmatn(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.white : const Color(0xFF7F13EC),
              side: BorderSide(
                color: isDark ? Colors.white24 : const Color(0xFF7F13EC),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
