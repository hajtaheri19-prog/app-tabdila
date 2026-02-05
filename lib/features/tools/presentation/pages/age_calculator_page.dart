import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'dart:async';
import '../../../../core/utils/digit_utils.dart';

class AgeCalculatorPage extends StatefulWidget {
  const AgeCalculatorPage({super.key});

  @override
  State<AgeCalculatorPage> createState() => _AgeCalculatorPageState();
}

class _AgeCalculatorPageState extends State<AgeCalculatorPage> {
  bool _isJalali = true;
  Jalali _selectedJalaliDate = Jalali(1378, 7, 14);
  DateTime _selectedGregorianDate = DateTime(2000, 1, 1);
  Timer? _timer;
  int _liveSeconds = 0;

  @override
  void initState() {
    super.initState();
    _calculateAge();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _liveSeconds++;
      });
    });
  }

  void _calculateAge() {
    setState(() {});
  }

  Map<String, dynamic> get _ageData {
    final now = Jalali.now();
    final birthDate = _isJalali
        ? _selectedJalaliDate
        : Jalali.fromDateTime(_selectedGregorianDate);

    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      months--;
      days = now.day +
          (now.month == 1 ? 30 : Jalali(now.year, now.month, 1).monthLength) -
          birthDate.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalMonths = years * 12 + months;
    final totalDays = now.distanceFrom(birthDate);
    final totalWeeks = (totalDays / 7).floor();
    final totalHours = totalDays * 24;
    final totalMinutes = totalHours * 60;
    final totalSeconds = totalMinutes * 60 + _liveSeconds;

    // Calculate next birthday
    Jalali nextBirthday = Jalali(now.year, birthDate.month, birthDate.day);
    if (nextBirthday.compareTo(now) < 0) {
      nextBirthday = Jalali(now.year + 1, birthDate.month, birthDate.day);
    }
    final daysUntilBirthday = nextBirthday.distanceFrom(now);

    return {
      'years': years,
      'months': months,
      'days': days,
      'totalMonths': totalMonths,
      'totalWeeks': totalWeeks,
      'totalDays': totalDays,
      'totalHours': totalHours,
      'totalSeconds': totalSeconds,
      'nextBirthday': nextBirthday,
      'daysUntilBirthday': daysUntilBirthday,
      'birthDayName': _getDayName(birthDate.weekDay),
    };
  }

  String _getDayName(int weekDay) {
    const days = [
      'شنبه',
      'یکشنبه',
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنجشنبه',
      'جمعه'
    ];
    return days[weekDay - 1];
  }

  String _getMonthName(int month) {
    const months = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند'
    ];
    return months[month - 1];
  }

  String _formatNumber(int number) {
    String formatted = number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return DigitUtils.toFarsi(formatted);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF7F13EC);
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    final accentColor = const Color(0xFFAD92C9);

    final ageData = _ageData;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decorative blurs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
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
              width: 320,
              height: 320,
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
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_forward,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        'محاسبه‌گر دقیق سن',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.history,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                        // Calendar Type Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'تاریخ تولد',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 14,
                                color: accentColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'شمسی',
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Date Picker Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
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
                              // Calendar Type Selector
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => _isJalali = false),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            color: !_isJalali
                                                ? primaryColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'میلادی',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.vazirmatn(
                                              fontSize: 14,
                                              fontWeight: _isJalali
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                              color: !_isJalali
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () =>
                                            setState(() => _isJalali = true),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          decoration: BoxDecoration(
                                            color: _isJalali
                                                ? primaryColor
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'شمسی',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.vazirmatn(
                                              fontSize: 14,
                                              fontWeight: _isJalali
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: _isJalali
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Date Display
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildDateSegment(
                                    'روز',
                                    DigitUtils.toFarsi(
                                        _selectedJalaliDate.day.toString()),
                                    isDark,
                                  ),
                                  Text(
                                    ' / ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  _buildDateSegment(
                                    'ماه',
                                    _getMonthName(_selectedJalaliDate.month),
                                    isDark,
                                  ),
                                  Text(
                                    ' / ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  _buildDateSegment(
                                    'سال',
                                    DigitUtils.toFarsi(
                                        _selectedJalaliDate.year.toString()),
                                    isDark,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Calculate Button
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _calculateAge,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.calculate, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'محاسبه کن',
                                        style: GoogleFonts.vazirmatn(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Hero Result Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: surfaceColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'سن دقیق شما',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 14,
                                  color: accentColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${DigitUtils.toFarsi(ageData['years'].toString())} سال ، ${DigitUtils.toFarsi(ageData['months'].toString())} ماه',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                'و ${DigitUtils.toFarsi(ageData['days'].toString())} روز',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 18,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Divider(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cake,
                                      color: primaryColor, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'متولد ${ageData['birthDayName']}، ${DigitUtils.toFarsi(_selectedJalaliDate.day.toString())} ${_getMonthName(_selectedJalaliDate.month)} ${DigitUtils.toFarsi(_selectedJalaliDate.year.toString())}',
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Statistics Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard(
                              'کل ماه‌ها',
                              _formatNumber(ageData['totalMonths']),
                              Icons.calendar_view_month,
                              isDark,
                              surfaceColor,
                              accentColor,
                            ),
                            _buildStatCard(
                              'کل هفته‌ها',
                              _formatNumber(ageData['totalWeeks']),
                              Icons.date_range,
                              isDark,
                              surfaceColor,
                              accentColor,
                            ),
                            _buildStatCard(
                              'کل روزها',
                              _formatNumber(ageData['totalDays']),
                              Icons.wb_sunny,
                              isDark,
                              surfaceColor,
                              accentColor,
                            ),
                            _buildStatCard(
                              'کل ساعت‌ها',
                              _formatNumber(ageData['totalHours']),
                              Icons.schedule,
                              isDark,
                              surfaceColor,
                              accentColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Live Seconds Counter
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ضربان زندگی (ثانیه)',
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 12,
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _formatNumber(ageData['totalSeconds']),
                                      style: GoogleFonts.manrope(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Next Birthday Countdown
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor,
                                const Color(0xFF5E0EB3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'تولد بعدی شما',
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.celebration,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCountdownItem(
                                      DigitUtils.toFarsi(
                                          ageData['daysUntilBirthday']
                                              .toString()),
                                      'روز',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildCountdownItem('14', 'ساعت'),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildCountdownItem('32', 'دقیقه'),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildCountdownItem(
                                        (_liveSeconds % 60)
                                            .toString()
                                            .padLeft(2, '0'),
                                        'ثانیه'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${_getDayName(ageData['nextBirthday'].weekDay)}، ${DigitUtils.toFarsi(ageData['nextBirthday'].day.toString())} ${_getMonthName(ageData['nextBirthday'].month)} ${DigitUtils.toFarsi(ageData['nextBirthday'].year.toString())}',
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
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

  Widget _buildDateSegment(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: 12,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    bool isDark,
    Color surfaceColor,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.vazirmatn(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
