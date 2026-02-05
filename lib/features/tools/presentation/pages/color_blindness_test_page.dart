import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorBlindnessTestPage extends StatefulWidget {
  const ColorBlindnessTestPage({super.key});

  @override
  State<ColorBlindnessTestPage> createState() => _ColorBlindnessTestPageState();
}

class _ColorBlindnessTestPageState extends State<ColorBlindnessTestPage> {
  int _currentPlate = 0;
  final List<Map<String, dynamic>> _plates = [
    {'number': '12', 'correctAnswer': '12'},
    {'number': '8', 'correctAnswer': '8'},
    {'number': '6', 'correctAnswer': '6'},
    {'number': '29', 'correctAnswer': '29'},
    {'number': '74', 'correctAnswer': '74'},
  ];

  void _nextPlate() {
    if (_currentPlate < _plates.length - 1) {
      setState(() {
        _currentPlate++;
      });
    } else {
      // Show results
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
          'تست با موفقیت انجام شد!\n\nتوجه: این تست فقط برای بررسی اولیه است.',
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
                    'تست رنگ‌بینی',
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
                        'پلیت ${_currentPlate + 1} از ${_plates.length}',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                      Text(
                        '${((_currentPlate + 1) / _plates.length * 100).toInt()}٪',
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
                      value: (_currentPlate + 1) / _plates.length,
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

            // Ishihara Plate
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'چه عددی می‌بینید؟',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Simulated Ishihara Plate
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.orange.withOpacity(0.3),
                            Colors.green.withOpacity(0.3),
                            Colors.red.withOpacity(0.3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _plates[_currentPlate]['number'],
                          style: GoogleFonts.manrope(
                            fontSize: 80,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'به دقت به دایره نگاه کنید',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPlate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: primaryColor.withOpacity(0.4),
                      ),
                      child: Text(
                        _currentPlate < _plates.length - 1
                            ? 'پلیت بعدی'
                            : 'اتمام تست',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Skip or mark as "Can't see"
                      _nextPlate();
                    },
                    child: Text(
                      'نمی‌بینم / رد شو',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
