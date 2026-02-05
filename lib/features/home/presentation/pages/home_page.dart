import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui' as ui;
import '../../../../core/providers/app_provider.dart';
import '../../../../core/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  String _currentTime = '۰۰:۲۳:۱۴';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      appProvider.loadDailyQuote();
      appProvider.loadPrices();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = _toPersianDigits(now.hour.toString().padLeft(2, '0'));
    final minute = _toPersianDigits(now.minute.toString().padLeft(2, '0'));
    final second = _toPersianDigits(now.second.toString().padLeft(2, '0'));
    setState(() {
      _currentTime = '$hour:$minute:$second';
    });
  }

  String _toPersianDigits(String text) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    String result = text;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], persian[i]);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Custom Colors
    const primaryColor = Color(0xFF7F13EC);
    const secondaryColor = Color(0xFF06B6D4);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF2A1E35);
    const backgroundLight = Color(0xFFF7F6F8);

    final backgroundColor = isDark ? backgroundDark : backgroundLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildHeader(isDark, primaryColor, secondaryColor),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildInspirationCard(),
                        const SizedBox(height: 32),
                        _buildLiveTicker(isDark, secondaryColor, surfaceDark),
                        const SizedBox(height: 32),
                        _buildUtilityHub(isDark, primaryColor),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(isDark, primaryColor, backgroundDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color primary, Color secondary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color:
            (isDark ? const Color(0xFF2A1E35) : Colors.white).withOpacity(0.4),
        border: Border(
            bottom:
                BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            0), // Glass effect is full width usually or customize
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primary, const Color(0xFF4C1D95)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF191022), // background-dark
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.all_inclusive,
                          color: primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'تبدیلا',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (const Color(0xFF2A1E35)).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                      height: 8,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary.withOpacity(0.75),
                              ),
                            ), // Should animate technically
                          ),
                          Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentTime,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: secondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          image: const DecorationImage(
            image: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuA8nX-iAj_-nCmhtM_bLCR-KV_mAny8cqtRUe9KckkUNO9zts2u5LefelnrU-5jVwH2tGeMH1tzWOTNTDBlLL4WhPoHdWMIMQZYchiGfoeciu9pNT0cvU21MtahaGsj5klLsBmVpNBrnqOtxJpfB6dahF5C66PYovBjs_zNt6aEgE3hvouyo6CN82fpQDeSKR_fgeOB4xo15Dwe9Cg8PJ8-5_DTuSahtMZvbVEz3LpUzgstkAl8QvEqgYSnOxpRfnDOZtR0cMynKUY'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF191022), // background-dark
                    const Color(0xFF191022).withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [
                    0.0,
                    0.2,
                    1.0
                  ], // Reverse gradient for bottom text
                ),
              ),
            ),
            // Overlay for text visibility at bottom
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    const Color(0xFF191022).withOpacity(0.9),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A1E35).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb,
                                    color: Color(0xFFFACC15),
                                    size: 16), // yellow-400
                                const SizedBox(width: 8),
                                Text(
                                  'سخن بزرگان',
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[300],
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '"هر موفقیت بزرگی با یک رویا شروع میشود."',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start Small, Dream Big.',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                              textDirection: TextDirection.ltr,
                            ),
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
      ),
    );
  }

  Widget _buildLiveTicker(bool isDark, Color secondary, Color surface) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: secondary.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'بازار زنده',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.prices),
                child: Text(
                  'مشاهده همه',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7F13EC),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150, // Slightly taller for the new design
          child: Consumer<AppProvider>(
            builder: (context, appProvider, _) {
              final prices = appProvider.prices.take(5).toList();
              // Mock data if empty for visual demo, but we stick to provider
              if (prices.isEmpty) {
                // Placeholder for design verification if no API data
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: prices.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  // Map real data to design logic
                  // Gold -> item 1 style
                  // USD -> item 2 style
                  // Others -> generic or item 3 style
                  return _buildTickerCard(
                      prices[index], index, isDark, surface);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTickerCard(price, int index, bool isDark, Color surface) {
    // Styling logic based on index or type for variety
    Color accentColor;
    IconData icon;
    String label;

    // Simple heuristics
    if (price.name.contains('طلا')) {
      accentColor = const Color(0xFFEAB308); // Yellow-500
      icon = Icons.grid_goldenratio;
      label = 'طلای ۱۸ عیار';
    } else if (price.name.contains('دلار')) {
      accentColor = const Color(0xFF22C55E); // Green-500
      icon = Icons.attach_money;
      label = 'دلار آمریکا';
    } else {
      accentColor = const Color(0xFFF97316); // Orange-500
      icon = Icons.currency_bitcoin;
      label = price.name;
    }

    final isPositive = price.changePercent >= 0;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Blob effect
          Positioned(
            top: -10,
            left: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accentColor, size: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isPositive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFF43F5E))
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${isPositive ? '+' : ''}${price.changePercent.abs()}%',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPositive
                              ? const Color(0xFF34D399)
                              : const Color(0xFFFB7185),
                        ),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPrice(price.value),
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityHub(bool isDark, Color primary) {
    final categories = [
      {
        'icon': Icons.psychology,
        'label': 'هوش مصنوعی',
        'c1': const Color(0xFF6366F1), // Indigo
        'c2': const Color(0xFFA855F7), // Purple
        'route': AppRoutes.ocrExtractor
      },
      {
        'icon': Icons.transform,
        'label': 'مبدل‌ها',
        'c1': const Color(0xFFF97316), // Orange
        'c2': const Color(0xFFEC4899), // Pink
        'route': AppRoutes.converters
      },
      {
        'icon': Icons.schedule,
        'label': 'زمان',
        'c1': const Color(0xFF06B6D4), // Cyan
        'c2': const Color(0xFF3B82F6), // Blue
        'route': AppRoutes.dateConverter
      },
      {
        'icon': Icons.account_balance_wallet,
        'label': 'مالی',
        'c1': const Color(0xFF10B981), // Emerald
        'c2': const Color(0xFF14B8A6), // Teal
        'route': AppRoutes.prices
      },
      {
        'icon': Icons.monitor_heart,
        'label': 'سلامت',
        'c1': const Color(0xFFEF4444), // Red
        'c2': const Color(0xFFF43F5E), // Rose
        'route': AppRoutes.tools
      },
      {
        'icon': Icons.sports_esports,
        'label': 'سرگرمی',
        'c1': const Color(0xFFD946EF), // Fuchsia
        'c2': const Color(0xFFA855F7), // Purple
        'route': AppRoutes.games
      },
      {
        'icon': Icons.auto_fix_high,
        'label': 'فال',
        'c1': const Color(0xFF8B5CF6), // Violet
        'c2': const Color(0xFF6366F1), // Indigo
        'route': AppRoutes.randomNumber
      },
      {
        'icon': Icons.grid_view,
        'label': 'سایر',
        'c1': const Color(0xFF64748B), // Slate (BlueGrey)
        'c2': const Color(0xFF475569), // Slate Dark
        'route': AppRoutes.tools
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: primary.withOpacity(0.5), blurRadius: 8),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ابزارهای هوشمند',
                style: GoogleFonts.vazirmatn(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 24,
              childAspectRatio: 0.75,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, cat['route'] as String);
                },
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [cat['c1'] as Color, cat['c2'] as Color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (cat['c1'] as Color).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border:
                            Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Center(
                        child: Icon(cat['icon'] as IconData,
                            color: Colors.white, size: 28),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat['label'] as String,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[300],
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, Color primary, Color background) {
    return Container(
      height: 100, // Total height including floating button
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Glass Bar
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: (const Color(0xFF2A1E35)).withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(Icons.home, 'خانه', true, isDark, primary),
                      _buildNavItem(
                          Icons.grid_view, 'ابزارها', false, isDark, primary,
                          onTap: () {
                        Navigator.pushNamed(context, AppRoutes.tools);
                      }),
                      const SizedBox(width: 48), // Spacer for FAB
                      _buildNavItem(
                          Icons.history, 'تاریخچه', false, isDark, primary),
                      _buildNavItem(
                          Icons.settings, 'تنظیمات', false, isDark, primary,
                          onTap: () {
                        Navigator.pushNamed(context, AppRoutes.settings);
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Action Button
          Positioned(
            bottom: 50, // 24 (margin) + some offset
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [primary, const Color(0xFF4C1D95)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFF191022), // background-dark
                  width: 4,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'هوش مصنوعی تبدیلا به‌زودی فعال می‌شود',
                          style: GoogleFonts.vazirmatn(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        backgroundColor: primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(
                          bottom: 100,
                          left: 24,
                          right: 24,
                        ),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isSelected, bool isDark, Color primary,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? primary : Colors.grey[400],
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primary : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value) {
    String formatted;
    if (value >= 1000000) {
      formatted =
          '${(value / 1000000).toStringAsFixed(0)},${((value % 1000000) / 1000).toStringAsFixed(0).padLeft(3, '0')},${(value % 1000).toStringAsFixed(0).padLeft(3, '0')}';
    } else if (value >= 1000) {
      formatted =
          '${(value / 1000).toStringAsFixed(0)},${(value % 1000).toStringAsFixed(0).padLeft(3, '0')}';
    } else {
      formatted = value.toStringAsFixed(2).replaceAll('.00', '');
    }
    return _toPersianDigits(formatted);
  }
}
