import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class BmiCalculatorPage extends StatefulWidget {
  const BmiCalculatorPage({super.key});

  @override
  State<BmiCalculatorPage> createState() => _BmiCalculatorPageState();
}

class _BmiCalculatorPageState extends State<BmiCalculatorPage>
    with SingleTickerProviderStateMixin {
  double _weight = 75.0;
  double _height = 175.0;
  bool _isMale = true;
  late AnimationController _gaugeController;

  @override
  void initState() {
    super.initState();
    _gaugeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _gaugeController.forward();
  }

  @override
  void dispose() {
    _gaugeController.dispose();
    super.dispose();
  }

  double get _bmi {
    final heightInMeters = _height / 100;
    return _weight / (heightInMeters * heightInMeters);
  }

  String get _bmiCategory {
    if (_bmi < 18.5) return 'کم‌وزن';
    if (_bmi < 25) return 'وزن نرمال';
    if (_bmi < 30) return 'اضافه‌وزن';
    return 'چاق';
  }

  Color get _bmiColor {
    if (_bmi < 18.5) return Colors.blue;
    if (_bmi < 25) return Colors.green;
    if (_bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String get _bmiAdvice {
    if (_bmi < 18.5) {
      return 'وزن شما کمتر از حد نرمال است. توصیه می‌شود با مشاوره پزشک، برنامه غذایی مناسب برای افزایش وزن داشته باشید.';
    } else if (_bmi < 25) {
      return 'وزن شما در محدوده سالم قرار دارد. با تغذیه مناسب و ورزش مداوم، این وضعیت ایده‌آل را حفظ کنید.';
    } else if (_bmi < 30) {
      return 'وزن شما بیشتر از حد نرمال است. برنامه‌ریزی برای کاهش وزن با تغذیه سالم و ورزش منظم توصیه می‌شود.';
    } else {
      return 'وزن شما به میزان قابل توجهی بیشتر از حد نرمال است. مشاوره با پزشک متخصص تغذیه ضروری است.';
    }
  }

  IconData get _adviceIcon {
    if (_bmi < 18.5) return Icons.warning;
    if (_bmi < 25) return Icons.health_and_safety;
    if (_bmi < 30) return Icons.info;
    return Icons.error;
  }

  // Calculate gauge needle rotation angle
  double get _needleAngle {
    // Map BMI 15-35 to -90deg to +90deg
    double clampedBmi = _bmi.clamp(15.0, 35.0);
    return ((clampedBmi - 15) / 20) * 180 - 90;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF7F13EC);
    final backgroundColor =
        isDark ? const Color(0xFF130C1A) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF1E1628) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background decorative blurs
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
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
                    Colors.blue.withOpacity(0.05),
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
                        icon: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: isDark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.black87,
                            size: 20,
                          ),
                        ),
                      ),
                      Text(
                        'محاسبه‌گر BMI',
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

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Gender Selector
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isMale = true),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: _isMale
                                          ? primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: _isMale
                                          ? [
                                              BoxShadow(
                                                color: primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.male,
                                          size: 20,
                                          color: _isMale
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'آقا',
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _isMale
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _isMale = false),
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: !_isMale
                                          ? primaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: !_isMale
                                          ? [
                                              BoxShadow(
                                                color: primaryColor
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.female,
                                          size: 20,
                                          color: !_isMale
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'خانم',
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: !_isMale
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Gauge and Result
                        _buildGaugeSection(isDark, primaryColor),

                        const SizedBox(height: 32),

                        // Weight Slider
                        _buildSliderCard(
                          icon: Icons.monitor_weight,
                          label: 'وزن (Weight)',
                          value: _weight,
                          unit: 'kg',
                          min: 30,
                          max: 150,
                          onChanged: (value) => setState(() => _weight = value),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          primaryColor: primaryColor,
                        ),

                        const SizedBox(height: 16),

                        // Height Slider
                        _buildSliderCard(
                          icon: Icons.height,
                          label: 'قد (Height)',
                          value: _height,
                          unit: 'cm',
                          min: 100,
                          max: 220,
                          onChanged: (value) => setState(() => _height = value),
                          isDark: isDark,
                          surfaceColor: surfaceColor,
                          primaryColor: primaryColor,
                        ),

                        const SizedBox(height: 24),

                        // Advice Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                surfaceColor,
                                const Color(0xFF251A33).withOpacity(0.5),
                              ],
                            ),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _bmiColor.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _adviceIcon,
                                  color: _bmiColor,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _bmiCategory,
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _bmiAdvice,
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.grey[700],
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Recalculate Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              _gaugeController.reset();
                              _gaugeController.forward();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 8,
                              shadowColor: primaryColor.withOpacity(0.4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'محاسبه مجدد',
                                  style: GoogleFonts.vazirmatn(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.refresh, size: 20),
                              ],
                            ),
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

  Widget _buildGaugeSection(bool isDark, Color primaryColor) {
    return Column(
      children: [
        // Gauge
        SizedBox(
          width: 280,
          height: 140,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Decorative glow
              Positioned(
                bottom: 0,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _bmiColor.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Gauge arcs
              CustomPaint(
                size: const Size(280, 140),
                painter: GaugePainter(
                  bmi: _bmi,
                  needleAngle: _needleAngle,
                  animation: _gaugeController,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Status Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            border: Border.all(color: primaryColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _bmiCategory.toUpperCase(),
            style: GoogleFonts.vazirmatn(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 1,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // BMI Number
        Text(
          _bmi.toStringAsFixed(1),
          style: GoogleFonts.manrope(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : Colors.black87,
            letterSpacing: -2,
          ),
        ),

        Text(
          'شاخص توده بدنی (BMI)',
          style: GoogleFonts.vazirmatn(
            fontSize: 14,
            color: isDark ? Colors.white.withOpacity(0.4) : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSliderCard({
    required IconData icon,
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value.toInt().toString(),
                    style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Minus button
              IconButton(
                onPressed: () {
                  if (value > min) onChanged(value - 1);
                },
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.remove, size: 16, color: Colors.white),
                ),
              ),

              // Slider
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: const Color(0xFF362348),
                    thumbColor: primaryColor,
                    overlayColor: primaryColor.withOpacity(0.3),
                  ),
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    onChanged: onChanged,
                  ),
                ),
              ),

              // Plus button
              IconButton(
                onPressed: () {
                  if (value < max) onChanged(value + 1);
                },
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double bmi;
  final double needleAngle;
  final Animation<double> animation;

  GaugePainter({
    required this.bmi,
    required this.needleAngle,
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 20;

    // Draw arcs
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Underweight (Blue) - 15-18.5
    paint.color = Colors.blue.withOpacity(0.4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * 0.175,
      false,
      paint,
    );

    // Normal (Green) - 18.5-25
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi + math.pi * 0.175,
      math.pi * 0.325,
      false,
      paint,
    );

    // Overweight (Orange) - 25-35+
    paint.color = Colors.orange.withOpacity(0.4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi + math.pi * 0.5,
      math.pi * 0.5,
      false,
      paint,
    );

    // Draw needle
    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final animatedAngle = needleAngle * animation.value;
    final radians = (animatedAngle) * math.pi / 180;

    final needleLength = radius - 10;
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(radians + math.pi),
      center.dy + needleLength * math.sin(radians + math.pi),
    );

    // Draw needle triangle
    final path = Path();
    path.moveTo(needleEnd.dx, needleEnd.dy);
    path.lineTo(center.dx - 4, center.dy);
    path.lineTo(center.dx + 4, center.dy);
    path.close();
    canvas.drawPath(path, needlePaint);

    // Draw center circle
    canvas.drawCircle(
      center,
      6,
      Paint()..color = const Color(0xFF130C1A),
    );
    canvas.drawCircle(
      center,
      6,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) => true;
}
