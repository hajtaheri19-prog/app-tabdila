import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamesPage extends StatelessWidget {
  const GamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        title: Text(
          'دنیای بازی و سرگرمی',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'مجموعه‌ای از بازی‌های جذاب برای تمام سلیقه‌ها',
              textAlign: TextAlign.center,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),

            // Active Games Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                _buildGameCard(
                  Icons.grid_3x3,
                  'بازی دوز',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.content_cut,
                  'سنگ کاغذ قیچی',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.abc,
                  'حدس کلمه',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.psychology,
                  'بازی حافظه',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.pin,
                  'حدس عدد',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.apps,
                  'چهار در یک ردیف',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.library_music,
                  'بازی سایمون',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.contrast,
                  'بازی اتللو',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
                _buildGameCard(
                  Icons.view_module,
                  'بازی ۲۰۴۸',
                  isDark,
                  surfaceColor,
                  primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Coming Soon Header
            Row(
              children: [
                const Icon(Icons.upcoming, color: Color(0xFFFBBF24), size: 24),
                const SizedBox(width: 8),
                Text(
                  'بزودی',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                Text(
                  'در حال توسعه',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 12,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Coming Soon List
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildComingSoonCard(
                  Icons.bolt,
                  'فرار از قبض برق',
                  'Survival',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.flag,
                  'Minesweeper 3D',
                  'Puzzle',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.diamond,
                  'بازی زیرخاکی',
                  'Adventure',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.pie_chart,
                  'Pac-Man Glow',
                  'Arcade',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.sports_hockey,
                  'Air Hockey Neon',
                  'Sports',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.castle,
                  'Tower Defense',
                  'Strategy',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.rocket,
                  'Space Invaders',
                  'Retro',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.adjust,
                  'Carrom Board 2D',
                  'Tabletop',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.directions_boat,
                  'BattleShip War',
                  'Tactics',
                  isDark,
                  surfaceColor,
                ),
                _buildComingSoonCard(
                  Icons.sports_baseball,
                  'Pinball Fusion',
                  'Retro',
                  isDark,
                  surfaceColor,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    IconData icon,
    String title,
    bool isDark,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primaryColor,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.vazirmatn(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[200] : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComingSoonCard(
    IconData icon,
    String title,
    String category,
    bool isDark,
    Color surfaceColor,
  ) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.grey[400], size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey[200] : Colors.grey[800],
                    ),
                  ),
                  Text(
                    category,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 9,
                      color: Colors.grey[500],
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
