import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class TimestampConverterPage extends StatefulWidget {
  const TimestampConverterPage({super.key});

  @override
  State<TimestampConverterPage> createState() => _TimestampConverterPageState();
}

class _TimestampConverterPageState extends State<TimestampConverterPage> {
  int _selectedTab = 0; // 0: Ts->Date, 1: Gr->Ts, 2: So->Ts
  final TextEditingController _timestampController =
      TextEditingController(text: '1640995200');
  bool _isSeconds = true;

  // Result variables
  String _gregorianResult = "Saturday, January 1, 2022";
  String _shamsiResult = "شنبه، ۱۱ دی ۱۴۰۰";
  String _timeResult = "00:00:00";

  @override
  void initState() {
    super.initState();
    _convertTimestamp();
  }

  void _convertTimestamp() {
    try {
      int ts = int.parse(_timestampController.text);
      if (!_isSeconds) {
        ts = ts ~/ 1000;
      }

      final date = DateTime.fromMillisecondsSinceEpoch(ts * 1000).toLocal();

      // Gregorian
      _gregorianResult = DateFormat('EEEE, MMMM d, yyyy').format(date);

      // Shamsi
      final jalali = Jalali.fromDateTime(date);
      final f = jalali.formatter;
      final weekDay = _getShamsiWeekday(jalali.weekDay);
      _shamsiResult = '$weekDay، ${jalali.day} ${f.mN} ${jalali.year}';

      // Time
      _timeResult = DateFormat('HH:mm:ss').format(date);

      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  String _getShamsiWeekday(int day) {
    const names = [
      'شنبه',
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنج‌شنبه',
      'جمعه'
    ];
    return names[day - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor =
        isDark ? const Color(0xFF2D1F3F) : const Color(0xFF362348);
    final primaryColor = const Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'مبدل تایماستمپ',
                        style: GoogleFonts.notoSansArabic(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tabs
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildTabItem(
                                  1,
                                  'Gregorian → Timestamp',
                                  _selectedTab == 1,
                                  primaryColor,
                                  surfaceColor),
                              const SizedBox(width: 12),
                              _buildTabItem(
                                  0,
                                  'Timestamp → Date',
                                  _selectedTab == 0,
                                  primaryColor,
                                  surfaceColor),
                              const SizedBox(width: 12),
                              _buildTabItem(
                                  2,
                                  'Solar → Timestamp',
                                  _selectedTab == 2,
                                  primaryColor,
                                  surfaceColor),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Input Section
                        Text(
                          'تایماستمپ یونیکس',
                          style: GoogleFonts.notoSansArabic(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            TextField(
                              controller: _timestampController,
                              style: GoogleFonts.jetBrainsMono(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1.2),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: surfaceColor,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.all(20),
                              ),
                            ),
                            Positioned(
                              left: 12,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                onPressed: () async {
                                  final data =
                                      await Clipboard.getData('text/plain');
                                  if (data != null) {
                                    _timestampController.text = data.text ?? '';
                                  }
                                },
                                icon: const Icon(Icons.content_paste,
                                    color: Color(0xFF7F13EC)),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Units
                        Row(
                          children: [
                            Expanded(
                              child: _buildUnitSelector(
                                  'ثانیه (Seconds)',
                                  _isSeconds,
                                  () => setState(() => _isSeconds = true),
                                  primaryColor,
                                  surfaceColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildUnitSelector(
                                  'میلی‌ثانیه (ms)',
                                  !_isSeconds,
                                  () => setState(() => _isSeconds = false),
                                  primaryColor,
                                  surfaceColor),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _convertTimestamp,
                            icon:
                                const Icon(Icons.sync_alt, color: Colors.white),
                            label: Text('تبدیل به تاریخ',
                                style: GoogleFonts.notoSansArabic(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.4),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Result Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Column(
                            children: [
                              _buildResultRow(
                                  Icons.calendar_month,
                                  'تاریخ میلادی',
                                  _gregorianResult,
                                  primaryColor,
                                  surfaceColor),
                              const SizedBox(height: 16),
                              Divider(color: Colors.white.withOpacity(0.05)),
                              const SizedBox(height: 16),
                              _buildResultRow(Icons.wb_sunny, 'تاریخ شمسی',
                                  _shamsiResult, primaryColor, surfaceColor),
                              const SizedBox(height: 16),
                              Divider(color: Colors.white.withOpacity(0.05)),
                              const SizedBox(height: 16),
                              _buildResultRow(Icons.schedule, 'ساعت (UTC+3:30)',
                                  _timeResult, primaryColor, surfaceColor),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Help Section
                        Row(
                          children: [
                            const Icon(Icons.info,
                                color: Colors.white54, size: 18),
                            const SizedBox(width: 8),
                            Text('راهنما',
                                style: GoogleFonts.notoSansArabic(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildHelpItem(
                            'تایماستمپ یونیکس تعداد ثانیه‌هایی است که از ۱ ژانویه ۱۹۷۰ گذشته است.'),
                        _buildHelpItem(
                            'برای دقت بیشتر در جاوا اسکریپت، معمولاً از میلی‌ثانیه استفاده می‌شود.'),
                        _buildHelpItem(
                            'ساعت نمایش داده شده بر اساس منطقه زمانی ایران تنظیم شده است.'),
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

  Widget _buildTabItem(int index, String title, bool isSelected,
      Color primaryColor, Color surfaceColor) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: primaryColor.withOpacity(0.25), blurRadius: 10)
                ]
              : null,
        ),
        child: Text(
          title,
          style: GoogleFonts.notoSansArabic(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildUnitSelector(String label, bool isSelected, VoidCallback onTap,
      Color primaryColor, Color surfaceColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryColor : Colors.white12),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected ? primaryColor : Colors.white30,
                    width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: primaryColor, shape: BoxShape.circle)))
                  : null,
            ),
            const SizedBox(width: 10),
            Text(label,
                style: GoogleFonts.notoSansArabic(
                    color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String label, String value,
      Color primaryColor, Color surfaceColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: surfaceColor, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.notoSansArabic(
                      color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value,
                  style: GoogleFonts.notoSansArabic(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: CircleAvatar(radius: 3, backgroundColor: Color(0xFF7F13EC)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text,
                  style: GoogleFonts.notoSansArabic(
                      color: Colors.white38, fontSize: 12, height: 1.5))),
        ],
      ),
    );
  }
}
