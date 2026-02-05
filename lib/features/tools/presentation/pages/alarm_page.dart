import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';
import '../../../../core/routes/app_routes.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  int _selectedHour = 7;
  int _selectedMinute = 30;
  bool _isPm = true;
  bool _repeatDaily = true;
  bool _vibration = false;
  String _selectedTheme = 'طبیعت';

  final List<Map<String, dynamic>> _themes = [
    {'name': 'طبیعت', 'icon': Icons.nature},
    {'name': 'دیجیتال', 'icon': Icons.memory},
    {'name': 'کلاسیک', 'icon': Icons.music_note},
    {'name': 'پیانو', 'icon': Icons.piano},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const gradientStart = Color(0xFF2D1B4D);

    String timeStr =
        "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.2,
            colors: [gradientStart, backgroundDark],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Digital Clock with Waves
                      _buildClockDisplay(timeStr, primaryColor),

                      // Time Picker Card (Glassmorphism)
                      _buildTimePickerCard(primaryColor),
                      const SizedBox(height: 24),

                      // Toggles
                      _buildToggles(primaryColor),
                      const SizedBox(height: 16),

                      // Theme Selector
                      _buildThemeSelector(primaryColor),
                      const SizedBox(height: 40),

                      // Action Button
                      _buildActivateButton(primaryColor),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              _buildBottomNav(primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 24),
          ),
          Text(
            'هشدار آنلاین',
            style: GoogleFonts.vazirmatn(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildClockDisplay(String time, Color primary) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sound Wave Decoration
          _buildWaveRing(260, primary.withOpacity(0.05)),
          _buildWaveRing(190, primary.withOpacity(0.1)),
          _buildWaveRing(120, primary.withOpacity(0.15)),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'زمان فعلی',
                style: GoogleFonts.vazirmatn(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                DigitUtils.toFarsi(time),
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  height: 1.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveRing(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
    );
  }

  Widget _buildTimePickerCard(Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        // For blur effect if we added BackdropFilter, keeping simple for perf
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPickerColumn('ساعت', 1, 12, _selectedHour,
                (val) => setState(() => _selectedHour = val + 1), primary),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(':',
                  style: GoogleFonts.manrope(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 32,
                      fontWeight: FontWeight.w300)),
            ),
            _buildPickerColumn('دقیقه', 0, 59, _selectedMinute,
                (val) => setState(() => _selectedMinute = val), primary),
            _buildAmPmColumn(primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerColumn(String label, int min, int max, int current,
      ValueChanged<int> onSelected, Color primary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(
                color: Colors.white.withOpacity(0.4), fontSize: 13)),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          width: 60,
          child: CupertinoPicker(
            itemExtent: 46,
            scrollController:
                FixedExtentScrollController(initialItem: current - min),
            onSelectedItemChanged: onSelected,
            selectionOverlay: Container(
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            children: List.generate(max - min + 1, (index) {
              int val = index + min;
              bool isSelected = val == current;
              return Center(
                child: Text(
                  DigitUtils.toFarsi(val.toString().padLeft(2, '0')),
                  style: GoogleFonts.manrope(
                    color: isSelected ? primary : Colors.white.withOpacity(0.2),
                    fontSize: isSelected ? 26 : 20,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAmPmColumn(Color primary) {
    return Column(
      children: [
        Text('بازه',
            style: GoogleFonts.vazirmatn(
                color: Colors.white.withOpacity(0.4), fontSize: 13)),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          width: 60,
          child: CupertinoPicker(
            itemExtent: 46,
            scrollController:
                FixedExtentScrollController(initialItem: _isPm ? 1 : 0),
            onSelectedItemChanged: (val) => setState(() => _isPm = val == 1),
            selectionOverlay: Container(
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            children: [
              _buildAmPmItem('ق.ظ', !_isPm, primary),
              _buildAmPmItem('ب.ظ', _isPm, primary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmPmItem(String text, bool isSelected, Color primary) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.vazirmatn(
          color: isSelected ? primary : Colors.white.withOpacity(0.2),
          fontSize: isSelected ? 18 : 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildToggles(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildGlassToggle('تکرار روزانه', Icons.repeat, _repeatDaily,
              (val) => setState(() => _repeatDaily = val), primary),
          const SizedBox(height: 12),
          _buildGlassToggle('لرزش', Icons.vibration, _vibration,
              (val) => setState(() => _vibration = val), primary),
        ],
      ),
    );
  }

  Widget _buildGlassToggle(String label, IconData icon, bool value,
      ValueChanged<bool> onChanged, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.vazirmatn(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: primary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withOpacity(0.1),
                trackOutlineColor:
                    MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Text('تم صدای هشدار',
              style: GoogleFonts.vazirmatn(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _themes.length,
            itemBuilder: (context, index) {
              final theme = _themes[index];
              bool isSelected = _selectedTheme == theme['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedTheme = theme['name']),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: isSelected
                                  ? primary
                                  : Colors.white.withOpacity(0.08)),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4))
                                ]
                              : null,
                        ),
                        child: Icon(theme['icon'],
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.6),
                            size: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(theme['name'],
                          style: GoogleFonts.vazirmatn(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              fontSize: 11)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivateButton(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'هشدار برای ساعت ${DigitUtils.toFarsi(_selectedHour.toString())}:${DigitUtils.toFarsi(_selectedMinute.toString().padLeft(2, '0'))} تنظیم شد',
                    style: GoogleFonts.vazirmatn(color: Colors.white)),
                backgroundColor: primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: primary.withOpacity(0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.alarm_on, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Text('فعالسازی هشدار',
                  style: GoogleFonts.vazirmatn(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF191022).withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildNavItem(Icons.alarm, 'هشدار', true, primary),
          _buildNavItem(
              Icons.public,
              'ساعت جهانی',
              false,
              primary,
              () => Navigator.pushReplacementNamed(
                  context, AppRoutes.worldClock)),
          _buildNavItem(Icons.timer, 'تایمر', false, primary,
              () => Navigator.pushReplacementNamed(context, AppRoutes.timer)),
          _buildNavItem(
              Icons.hourglass_empty,
              'کرنومتر',
              false,
              primary,
              () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.stopwatch)),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, Color primary,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isActive ? primary : Colors.white.withOpacity(0.4),
              size: 26),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.vazirmatn(
                  color: isActive ? primary : Colors.white.withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
