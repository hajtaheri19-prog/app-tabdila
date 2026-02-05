import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisualAcuityTestPage extends StatefulWidget {
  const VisualAcuityTestPage({super.key});

  @override
  State<VisualAcuityTestPage> createState() => _VisualAcuityTestPageState();
}

class _VisualAcuityTestPageState extends State<VisualAcuityTestPage> {
  int _currentLevel = 0;
  final List<double> _fontSizes = [100, 80, 60, 40, 30, 20, 16, 12];
  final List<String> _directions = ['E', 'ᒣ', 'ᒦ', 'W'];
  int _currentDirectionIndex = 0;

  void _nextLevel() {
    if (_currentLevel < _fontSizes.length - 1) {
      setState(() {
        _currentLevel++;
        _currentDirectionIndex =
            (_currentDirectionIndex + 1) % _directions.length;
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2335),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'نتیجه تست',
          style: GoogleFonts.vazirmatn(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'تست تیزی بینایی با موفقیت انجام شد!\n\nسطح قابل مشاهده: ${_currentLevel + 1}/${_fontSizes.length}\n\nتوجه: این تست فقط برای بررسی اولیه است.',
          style: GoogleFonts.vazirmatn(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'بستن',
              style: GoogleFonts.vazirmatn(
                color: const Color(0xFF7F13EC),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDirectionLabel(int index) {
    switch (index) {
      case 0:
        return 'راست →';
      case 1:
        return 'بالا ↑';
      case 2:
        return 'پایین ↓';
      case 3:
        return 'چپ ←';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF7F13EC);
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);

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
                    'تست تیزی بینایی',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF2D2335),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            'راهنما',
                            style: GoogleFonts.vazirmatn(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            '• در فاصله ۳۰ سانتی از صفحه قرار بگیرید\n• هر چشم را جداگانه بررسی کنید\n• جهت باز بودن حرف E را مشخص کنید\n• اگر نمی‌بینید، رد شو را بزنید',
                            style: GoogleFonts.vazirmatn(
                              color: Colors.white70,
                              height: 1.8,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'متوجه شدم',
                                style: GoogleFonts.vazirmatn(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سطح ${_currentLevel + 1} از ${_fontSizes.length}',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${((_currentLevel + 1) / _fontSizes.length * 100).toInt()}٪',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentLevel + 1) / _fontSizes.length,
                      backgroundColor:
                          isDark ? const Color(0xFF4D3267) : Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // E-Chart
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'به کدام سمت باز است؟',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 80),

                    // The E Letter
                    Text(
                      _directions[_currentDirectionIndex],
                      style: GoogleFonts.manrope(
                        fontSize: _fontSizes[_currentLevel],
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : Colors.black87,
                        letterSpacing: 0,
                      ),
                    ),

                    const SizedBox(height: 80),

                    Text(
                      'حرف را واضح می‌بینید؟',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Direction Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDirectionButton('راست →', 0, isDark, primaryColor),
                  _buildDirectionButton('بالا ↑', 1, isDark, primaryColor),
                  _buildDirectionButton('پایین ↓', 2, isDark, primaryColor),
                  _buildDirectionButton('چپ ←', 3, isDark, primaryColor),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextButton(
                onPressed: _nextLevel,
                child: Text(
                  'نمی‌بینم / رد شو',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionButton(
      String label, int index, bool isDark, Color primaryColor) {
    return ElevatedButton(
      onPressed: () {
        if (index == _currentDirectionIndex) {
          // Correct answer
          _nextLevel();
        } else {
          // Wrong answer - show feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'پاسخ صحیح: ${_getDirectionLabel(_currentDirectionIndex)}',
                style: GoogleFonts.vazirmatn(),
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? const Color(0xFF2D2335) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.2),
          ),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: GoogleFonts.vazirmatn(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
