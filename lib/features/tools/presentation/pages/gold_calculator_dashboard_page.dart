import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../../core/routes/app_routes.dart';

class GoldCalculatorDashboardPage extends StatelessWidget {
  const GoldCalculatorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const goldColor = Color(0xFFFBBF24);
    const backgroundDark = Color(0xFF0F0816);
    const surfaceDark = Color(0xFF1A1025);
    const textMuted = Color(0xFFAD92C9);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: goldColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context, isDark),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ابزارهای مالی',
                          style: GoogleFonts.vazirmatn(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'یک ابزار را برای شروع محاسبه انتخاب کنید',
                          style: GoogleFonts.vazirmatn(
                            fontSize: 14,
                            color: isDark ? textMuted : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Dashboard Cards
                        _buildDashboardCard(
                          title: 'محاسبه قیمت طلا',
                          subtitle: 'محاسبه قیمت نهایی فاکتور طلا',
                          icon: Icons.monetization_on,
                          accentColor: goldColor,
                          isDark: isDark,
                          surfaceColor: surfaceDark,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.goldCalculator,
                              arguments: 0),
                        ),
                        const SizedBox(height: 16),

                        _buildDashboardCard(
                          title: 'محاسبه حباب سکه',
                          subtitle: 'تحلیل حباب و ارزش واقعی بازار',
                          icon: Icons.bubble_chart,
                          accentColor: primaryColor,
                          isDark: isDark,
                          surfaceColor: surfaceDark,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.goldCalculator,
                              arguments: 1),
                        ),
                        const SizedBox(height: 16),

                        _buildDashboardCard(
                          title: 'محاسبه اجرت ساخت',
                          subtitle: 'تخمین هزینه‌های ساخت طلا',
                          icon: Icons.diamond,
                          accentColor: goldColor,
                          isDark: isDark,
                          surfaceColor: surfaceDark,
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.goldCalculator,
                              arguments: 2),
                        ),
                        const SizedBox(height: 16),

                        _buildDashboardCard(
                          title: 'اجرت از فاکتور',
                          subtitle: 'محاسبه معکوس اجرت از مبلغ کل',
                          icon: Icons.receipt_long,
                          accentColor: primaryColor,
                          isDark: isDark,
                          surfaceColor: surfaceDark,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.goldCalculator,
                                arguments: 3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Gradient Line
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        primaryColor.withOpacity(0.3),
                        Colors.transparent,
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_forward,
                color: isDark ? Colors.white : Colors.black87),
          ),
          Text(
            'محاسبه‌گر طلا و سکه',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_sweep, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required bool isDark,
    required Color surfaceColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: isDark ? surfaceColor.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.05),
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Side Accent Bar
            Positioned(
              left:
                  0, // In RTL, this is the leading edge (actually it stays on screen coordinates)
              // Since the app might be RTL, let's use the visual right side for the bar as in HTML
              right: 0,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 4,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [accentColor, accentColor.withOpacity(0.6)],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Text Content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.vazirmatn(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.vazirmatn(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFFAD92C9)
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (isDark)
                          BoxShadow(
                            color: accentColor.withOpacity(0.05),
                            blurRadius: 10,
                          ),
                      ],
                    ),
                    child: Icon(icon, color: accentColor, size: 30),
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
