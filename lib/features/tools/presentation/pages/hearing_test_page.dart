import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HearingTestPage extends StatefulWidget {
  const HearingTestPage({super.key});

  @override
  State<HearingTestPage> createState() => _HearingTestPageState();
}

class _HearingTestPageState extends State<HearingTestPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _currentFreq = 1000;
  bool _isLeftEar = true;
  double _progress = 0.45;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onHear(bool heard) {
    HapticFeedback.lightImpact();
    // Logic for next freq/volume would go here
    // For now, just simulate progression
    setState(() {
      if (_progress < 1.0) {
        _progress += 0.05;
        if (_progress >= 1.0) _progress = 0;
      }

      // Toggle frequencies for demo
      if (_currentFreq == 1000)
        _currentFreq = 2000;
      else if (_currentFreq == 2000)
        _currentFreq = 4000;
      else if (_currentFreq == 4000)
        _currentFreq = 8000;
      else if (_currentFreq == 8000)
        _currentFreq = 500;
      else
        _currentFreq = 1000;

      // Toggle Ear for demo if completed
      if (_progress == 0) _isLeftEar = !_isLeftEar;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(heard ? 'ثبت شد: شنیدم' : 'ثبت شد: نمی‌شنوم',
            style: GoogleFonts.vazirmatn()),
        duration: const Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: heard ? const Color(0xFF7F13EC) : Colors.grey[700],
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_forward,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  Text(
                    'تست شنوایی',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
            ),

            // Progress Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.hearing, color: primaryColor, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            _isLeftEar ? 'تست گوش چپ' : 'تست گوش راست',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$_currentFreq Hz',
                        textDirection: TextDirection.ltr,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _progress,
                            backgroundColor: isDark
                                ? const Color(0xFF4D3267).withOpacity(0.5)
                                : Colors.grey[300],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(_progress * 100).toInt()}%',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Visual Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Frequency Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$_currentFreq',
                        style: GoogleFonts.manrope(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'هرتز',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),

                  // Sound Wave Visualization
                  SizedBox(
                    width: 320,
                    height: 320,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Core
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.graphic_eq,
                              color: Colors.white, size: 48),
                        ),
                        // Ring 1 (Animated)
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 144 + (_pulseController.value * 10),
                              height: 144 + (_pulseController.value * 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: primaryColor.withOpacity(0.6),
                                    width: 2),
                              ),
                            );
                          },
                        ),
                        // Ring 2
                        Container(
                          width: 192,
                          height: 192,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.4), width: 1),
                          ),
                        ),
                        // Ring 3
                        Container(
                          width: 256,
                          height: 256,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.2), width: 1),
                          ),
                        ),
                        // Outer Ring
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.1), width: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'لطفاً به صدا با دقت گوش دهید. شدت صدا تغییر خواهد کرد.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Don't Hear Button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () => _onHear(false),
                        icon: const Icon(Icons.close),
                        label: Text(
                          'نمی‌شنوم',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isDark ? Colors.white70 : Colors.black54,
                          side: BorderSide(
                              color:
                                  isDark ? Colors.white24 : Colors.grey[300]!,
                              width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Hear Button
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => _onHear(true),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: Text(
                          'می‌شنوم',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(0.5),
                        ),
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
