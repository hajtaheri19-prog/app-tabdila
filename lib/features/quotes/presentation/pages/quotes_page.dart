import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  // Mock Data for Logic
  final List<FalData> _fals = [
    FalData(
      title: "غزل شماره ۱",
      verses: [
        "الا یا ایها الساقی ادر کاسا و ناولها",
        "که عشق آسان نمود اول ولی افتاد مشکل‌ها",
        "به بوی نافه‌ای کاخر صبا زان طره بگشاید",
        "ز تاب جعد مشکینش چه خون افتاد در دل‌ها",
      ],
      interpretation:
          "ای صاحب فال، نیت شما بسیار نیکوست. اگرچه در ابتدای کار با مشکلاتی روبرو شده‌اید و کارها آنطور که می‌خواستید پیش نرفته است، اما ناامید نباشید. صبری که پیشه کرده‌اید در نهایت ثمر خواهد داد. روزهای خوش در انتظار شماست.",
    ),
    FalData(
      title: "غزل شماره ۲",
      verses: [
        "صلاح کار کجا و من خراب کجا",
        "ببین تفاوت ره کز کجاست تا به کجا",
        "دلم ز صومعه بگرفت و خرقه سالوس",
        "کجاست دیر مغان و شراب ناب کجا",
      ],
      interpretation:
          "شما در دو راهی قرار گرفته‌اید و نمی‌دانید کدام راه را انتخاب کنید. بهتر است با افراد با تجربه مشورت کنید. از ریا و تظاهر دوری کنید و به دنبال حقیقت باشید.",
    ),
    FalData(
        title: "غزل شماره ۳",
        verses: [
          "اگر آن ترک شیرازی به دست آرد دل ما را",
          "به خال هندویش بخشم سمرقند و بخارا را",
          "بده ساقی می باقی که در جنت نخواهی یافت",
          "کنار آب رکن آباد و گلگشت مصلا را",
        ],
        interpretation:
            "شانس به شما رو کرده است. از فرصت‌های پیش رو نهایت استفاده را ببرید. بخشندگی و سخاوت باعث افزایش محبوبیت شما می‌شود. قدر لحظات خوش زندگی را بدانید."),
  ];

  late FalData _currentFal;

  @override
  void initState() {
    super.initState();
    _currentFal = _fals[0];
  }

  void _generateNewFal() {
    setState(() {
      _currentFal = (_fals..shuffle()).first;
    });

    // Show feedback
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('نیت جدید شما ثبت شد', style: GoogleFonts.vazirmatn()),
        backgroundColor: const Color(0xFF7F13EC),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Theme colors extracted from HTML/Tailwind config
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const accentColor = Color(0xFFFFD700);
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor =
        isDark ? Colors.white70 : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Pattern (Subtle dots/grid)
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(
                color: primaryColor.withOpacity(0.05),
                spacing: 20,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(isDark, textColor),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      children: [
                        // Hero Card
                        _buildHeroCard(primaryColor, accentColor, surfaceColor),
                        const SizedBox(height: 24),

                        // Poem Section
                        _buildPoemCard(primaryColor, surfaceColor, textColor,
                            secondaryTextColor),
                        const SizedBox(height: 24),

                        // Interpretation Section
                        _buildInterpretationCard(surfaceColor, textColor,
                            secondaryTextColor, accentColor),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.share_outlined,
                                label: 'اشتراک گذاری',
                                color: surfaceColor,
                                textColor: textColor,
                                onTap: () {
                                  Share.share(
                                      '${_currentFal.title}\n\n${_currentFal.verses.join('\n')}\n\nتعبیر: ${_currentFal.interpretation}');
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildActionButton(
                                icon: Icons.favorite_border,
                                label: 'علاقه‌مندی‌ها',
                                color: surfaceColor,
                                textColor: textColor,
                                onTap: () {},
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

          // Floating Action Button Area
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    backgroundColor,
                    backgroundColor.withOpacity(0.95),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: _buildMainButton(primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_forward, color: textColor),
            style: IconButton.styleFrom(
              backgroundColor:
                  isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            ),
          ),
          Text(
            'فال حافظ',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings_outlined, color: textColor),
            style: IconButton.styleFrom(
              backgroundColor:
                  isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(Color primary, Color accent, Color surface) {
    return Stack(
      children: [
        // Glow effect
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  primary.withOpacity(0.5),
                  accent.withOpacity(0.3),
                  primary.withOpacity(0.5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ).animate().fade(
              duration: const Duration(
                  milliseconds: 1000)), // Simple fade animation placeholder
        ),
        Container(
          height: 280, // Aspect 4/3 approx
          margin: const EdgeInsets.all(2), // For border effect
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(22),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAC3-M3AD7X98Ja6awfoTTMnzNaX6-xf5PpvN4RDwN0b5EfCgk4d4xxyVnKELd-kHikcLz5dXTVnOqkCigJF8K-lCGVmteMygHVe0bZZBZLdlZqo_m-ZnNM8WlYLCVQwTpvNweXIEOKtRlaPRR1mK5571lYSkSbgPWMDpzEqXejaCUQOVv9uq8TaM2gun9xutH_CqdmQMP8sbBH3iXRnFwYLVKZ4OGU3Lncm9g99BXWuFZ_3MLqEbT9CIDVWGkG0SOUd65nP7HbKxM'),
              fit: BoxFit.cover,
              opacity: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      surface.withOpacity(0.2), // Darkens top slightly
                      surface, // Solid at bottom to merge with text
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: primary.withOpacity(0.3)),
                        ),
                        child:
                            Icon(Icons.auto_stories, color: accent, size: 32),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'دیوان خواجه حافظ شیرازی',
                        style: GoogleFonts.vazirmatn(
                          color: Colors.white, // Always white on image
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'راهنمای دل‌های بی‌قرار',
                        style: GoogleFonts.vazirmatn(
                          color: Colors.white70,
                          fontSize: 14,
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
    );
  }

  Widget _buildPoemCard(
      Color primary, Color surface, Color textColor, Color secondaryText) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative Quote Icon (Top Right)
          Positioned(
            top: -10,
            right: -10,
            child: Icon(Icons.format_quote_rounded,
                size: 48, color: primary.withOpacity(0.1)),
          ),
          // Decorative Quote Icon (Bottom Left)
          Positioned(
            bottom: -10,
            left: -10,
            child: Transform.rotate(
              angle: 3.14,
              child: Icon(Icons.format_quote_rounded,
                  size: 48, color: primary.withOpacity(0.1)),
            ),
          ),
          Column(
            children: [
              Text(
                _currentFal.title,
                style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),
              ..._currentFal.verses.asMap().entries.map((entry) {
                final index = entry.key;
                final line = entry.value;
                final isOdd = index % 2 != 0;

                return Column(
                  children: [
                    Text(
                      line,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 18,
                        fontWeight: index % 2 == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: index % 2 == 0 ? textColor : secondaryText,
                        height: 2.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isOdd && index != _currentFal.verses.length - 1) ...[
                      const SizedBox(height: 12),
                      Container(
                        // Separator
                        width: 100,
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              primary.withOpacity(0.3),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ]
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInterpretationCard(
      Color surface, Color textColor, Color secondaryText, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: accent, size: 24),
              const SizedBox(width: 8),
              Text(
                'تعبیر فال',
                style: GoogleFonts.vazirmatn(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: textColor.withOpacity(0.05), height: 1),
          const SizedBox(height: 16),
          Text(
            _currentFal.interpretation,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              height: 2.0,
              color: secondaryText,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: textColor.withOpacity(0.7)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(Color primary) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, const Color(0xFF9D4EDD)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _generateNewFal,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'نیت کنید و لمس کنید',
                style: GoogleFonts.vazirmatn(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FalData {
  final String title;
  final List<String> verses;
  final String interpretation;

  FalData({
    required this.title,
    required this.verses,
    required this.interpretation,
  });
}

// Helper for animation (placeholder since we don't have flutter_animate package)
extension WidgetAnimate on Widget {
  Widget animate() => this; // Mock
  Widget fade({Duration? duration}) => this; // Mock
}

// Custom Painter for background dots
class GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  GridPainter({required this.color, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
