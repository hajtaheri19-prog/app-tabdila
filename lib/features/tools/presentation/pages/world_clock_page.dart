import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../../core/utils/digit_utils.dart';

class WorldClockPage extends StatefulWidget {
  const WorldClockPage({super.key});

  @override
  State<WorldClockPage> createState() => _WorldClockPageState();
}

class _WorldClockPageState extends State<WorldClockPage>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late DateTime _now;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatJalaliDate(DateTime date) {
    final jalali = Jalali.fromDateTime(date);
    final formatter = jalali.formatter;
    return '${formatter.wN}، ${formatter.d} ${formatter.mN} ${formatter.yyyy}';
  }

  String _getTimeForZone(int offsetHours, int offsetMinutes) {
    final utc = _now.toUtc();
    final zoneTime =
        utc.add(Duration(hours: offsetHours, minutes: offsetMinutes));
    return DateFormat('HH:mm').format(zoneTime);
  }

  String _getTimeDifference(int offsetHours, int offsetMinutes) {
    // Tehran offset is 3:30
    const tehranHours = 3;
    const tehranMinutes = 30;

    final diffMinutes =
        (offsetHours * 60 + offsetMinutes) - (tehranHours * 60 + tehranMinutes);
    final hours = (diffMinutes.abs() ~/ 60);
    final minutes = (diffMinutes.abs() % 60);

    final sign = diffMinutes >= 0 ? '+' : '-';
    final label = diffMinutes >= 0 ? 'جلوتر' : 'عقب‌تر';

    if (diffMinutes == 0) return 'زمان مرجع';

    String timeStr = '${hours}:${minutes.toString().padLeft(2, '0')}';
    return '$sign$timeStr ساعت $label';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ساعت ایران و جهان',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section: Iran Clock
              _buildIranClockHero(primaryColor, backgroundDark),
              const SizedBox(height: 32),

              // Title: Time Difference
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'اختلاف زمانی هوشمند',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const Icon(Icons.schedule, color: primaryColor),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              _buildSearchBar(isDark, surfaceDark, primaryColor),
              const SizedBox(height: 24),

              // Comparison Cards
              _buildCityCard(
                city: 'تهران',
                country: 'ایران',
                gmt: '+3:30',
                offsetHours: 3,
                offsetMinutes: 30,
                isDark: isDark,
                surface: surfaceDark,
                primary: primaryColor,
                isReference: true,
              ),
              const SizedBox(height: 12),
              _buildCityCard(
                city: 'نیویورک',
                country: 'ایالات متحده',
                gmt: '-5:00',
                offsetHours: -5,
                offsetMinutes: 0,
                isDark: isDark,
                surface: surfaceDark,
                primary: primaryColor,
              ),
              const SizedBox(height: 12),
              _buildCityCard(
                city: 'توکیو',
                country: 'ژاپن',
                gmt: '+9:00',
                offsetHours: 9,
                offsetMinutes: 0,
                isDark: isDark,
                surface: surfaceDark,
                primary: primaryColor,
              ),
              const SizedBox(height: 32),

              // Map Card
              _buildMapCard(isDark, surfaceDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIranClockHero(Color primary, Color background) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary,
            const Color(0xFF4D0B8F),
            background,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'ساعت رسمی ایران',
            style: GoogleFonts.vazirmatn(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            DigitUtils.toFarsi(DateFormat('HH:mm:ss').format(_now)),
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatJalaliDate(_now),
            style: GoogleFonts.vazirmatn(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _pulseController,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4ADE80),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'به‌روزرسانی خودکار فعال است',
                  style: GoogleFonts.vazirmatn(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Color surface, Color primary) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'نام شهر یا کشور را جستجو کنید...',
          hintStyle: GoogleFonts.vazirmatn(
              color: Colors.white.withOpacity(0.3), fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCityCard({
    required String city,
    required String country,
    required String gmt,
    required int offsetHours,
    required int offsetMinutes,
    required bool isDark,
    required Color surface,
    required Color primary,
    bool isReference = false,
  }) {
    final diffLabel = _getTimeDifference(offsetHours, offsetMinutes);
    final isAhead = diffLabel.contains('جلوتر');
    final isBehind = diffLabel.contains('عقب‌تر');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isReference
              ? primary.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isReference
                      ? primary.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isReference
                          ? primary.withOpacity(0.3)
                          : Colors.white10),
                ),
                child: Icon(
                  isReference ? Icons.location_on : Icons.near_me,
                  color: isReference ? primary : Colors.white60,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$country (GMT $gmt)',
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DigitUtils.toFarsi(_getTimeForZone(offsetHours, offsetMinutes)),
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                diffLabel,
                style: GoogleFonts.vazirmatn(
                  color: isReference
                      ? primary
                      : (isAhead
                          ? Colors.greenAccent
                          : (isBehind ? Colors.redAccent : Colors.grey)),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard(bool isDark, Color surface) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Placeholder background image or pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, color: Colors.white24, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    'نقشه جهانی زمان',
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'مشاهده وضعیت روز و شب در جهان',
                    style: GoogleFonts.vazirmatn(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Icon(Icons.open_in_full,
                  color: Colors.white.withOpacity(0.6), size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
