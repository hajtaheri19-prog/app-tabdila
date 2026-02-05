import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';

class VisionTestIntroPage extends StatelessWidget {
  const VisionTestIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF7F13EC);
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF2D2335) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decorative blurs
          Positioned(
            top: -100,
            left: MediaQuery.of(context).size.width * 0.5 - 200,
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
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
                        'تست بینایی و رنگ‌بینی',
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

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'بررسی سلامت چشم و تشخیص رنگ‌ها',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.grey[600],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Test Cards
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Color Blindness Test Card
                        _buildTestCard(
                          context: context,
                          title: 'تست رنگ‌بینی',
                          subtitle: 'تشخیص اختلالات با صفحات ایشیهارا',
                          icon: Icons.palette,
                          gradientColors: [
                            Colors.pink,
                            Colors.purple,
                            Colors.indigo,
                          ],
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          primaryColor: primaryColor,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.colorBlindnessTest);
                          },
                        ),

                        const SizedBox(height: 24),

                        // Visual Acuity Test Card
                        _buildTestCard(
                          context: context,
                          title: 'تست تیزی بینایی',
                          subtitle: 'سنجش قدرت دید با نمودار E-chart',
                          icon: Icons.visibility,
                          gradientColors: [
                            Colors.cyan,
                            Colors.blue,
                          ],
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          primaryColor: primaryColor,
                          isBlue: true,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.visualAcuityTest);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Warning Footer
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'این تست‌ها فقط برای بررسی اولیه هستند و جایگزین معاینه پزشکی نیستند.',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 12,
                              color: primaryColor.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
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
    );
  }

  Widget _buildTestCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    bool isBlue = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.6),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon Container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E1625) : Colors.white,
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: GoogleFonts.vazirmatn(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            // Progress indicator
            Container(
              height: 4,
              width: 48,
              decoration: BoxDecoration(
                color: isBlue
                    ? Colors.blue.withOpacity(0.6)
                    : primaryColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
