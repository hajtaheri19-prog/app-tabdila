import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:async';

class ColorConverterPage extends StatefulWidget {
  const ColorConverterPage({super.key});

  @override
  State<ColorConverterPage> createState() => _ColorConverterPageState();
}

class _ColorConverterPageState extends State<ColorConverterPage> {
  Color _pickerColor = const Color(0xFF6A3EAB);
  Color _currentColor = const Color(0xFF6A3EAB);
  String _currentTime = '۰۰:۰۰:۰۰';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
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
    if (mounted) {
      setState(() {
        _currentTime = '$hour:$minute:$second';
      });
    }
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

  void changeColor(Color color) {
    setState(() => _currentColor = color);
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase().substring(2)}';
  }

  String _colorToRgb(Color color) {
    return '${color.red}, ${color.green}, ${color.blue}';
  }

  String _colorToHsl(Color color) {
    final hsl = HSLColor.fromColor(color);
    return '${hsl.hue.toInt()}°, ${(hsl.saturation * 100).toInt()}%, ${(hsl.lightness * 100).toInt()}%';
  }

  Color _getComplementary(Color color) {
    final hsl = HSLColor.fromColor(color);
    final complementHue = (hsl.hue + 180) % 360;
    return hsl.withHue(complementHue).toColor();
  }

  List<Color> _getAnalogous(Color color) {
    final hsl = HSLColor.fromColor(color);
    return [
      hsl.withHue((hsl.hue + 30) % 360).toColor(),
      hsl.withHue((hsl.hue - 30 + 360) % 360).toColor(),
    ];
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('متن "$text" کپی شد', style: GoogleFonts.vazirmatn()),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6A3EAB);
    final backgroundColor =
        isDark ? const Color(0xFF12101F) : const Color(0xFFF3F0FF);
    final surfaceColor = isDark ? const Color(0xFF1E1B2E) : Colors.white;
    final inputColor =
        isDark ? const Color(0xFF2A2640) : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode,
                          color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: surfaceColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10)
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(_currentTime,
                              style: GoogleFonts.vazirmatn(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                          const SizedBox(width: 4),
                          Icon(Icons.schedule, color: primaryColor, size: 16),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text('تبدیلا',
                            style: GoogleFonts.vazirmatn(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xFF6A3EAB), Color(0xFF916CD5)]),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 8)
                            ],
                          ),
                          child: const Icon(Icons.transform,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Breadcrumb
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey[400], size: 18),
                          const SizedBox(width: 4),
                          Text('خانه',
                              style: GoogleFonts.vazirmatn(
                                  color: Colors.grey[600], fontSize: 12)),
                          const SizedBox(width: 4),
                          Text('/',
                              style: GoogleFonts.vazirmatn(
                                  color: Colors.grey[300], fontSize: 12)),
                          const SizedBox(width: 4),
                          Text('جعبه ابزار',
                              style: GoogleFonts.vazirmatn(
                                  color: Colors.grey[600], fontSize: 12)),
                          const SizedBox(width: 4),
                          Text('/',
                              style: GoogleFonts.vazirmatn(
                                  color: Colors.grey[300], fontSize: 12)),
                          const SizedBox(width: 4),
                          Text('مبدل رنگ',
                              style: GoogleFonts.vazirmatn(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            Text('بازگشت',
                                style: GoogleFonts.vazirmatn(
                                    color: Colors.grey[600], fontSize: 12)),
                            const SizedBox(width: 2),
                            Icon(Icons.keyboard_arrow_left,
                                color: Colors.grey[600], size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Main Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 20)
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('انتخابگر رنگ',
                          style: GoogleFonts.vazirmatn(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),

                      // Color Picker Trigger
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('انتخاب رنگ',
                                  style: GoogleFonts.vazirmatn()),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: _pickerColor,
                                  onColorChanged: (color) {
                                    setState(() => _pickerColor = color);
                                  },
                                  showLabel: true,
                                  pickerAreaHeightPercent: 0.8,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(
                                        () => _currentColor = _pickerColor);
                                    Navigator.pop(context);
                                  },
                                  child: Text('انتخـــاب',
                                      style: GoogleFonts.vazirmatn(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: _currentColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: _currentColor.withOpacity(0.4),
                                  blurRadius: 15)
                            ],
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const Icon(Icons.colorize,
                              color: Colors.white, size: 24),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Preview Bar
                      Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _currentColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 8,
                                right: 12,
                                child: Text('PREVIEW',
                                    style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 10))),
                            Center(
                                child: Text('پیش‌نمایش رنگ',
                                    style: GoogleFonts.vazirmatn(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black26,
                                              blurRadius: 4)
                                        ]))),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Camera Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Placeholder for smart color identification
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'این قابلیت به زودی فعال می‌شود')));
                          },
                          icon: const Icon(Icons.camera_alt, size: 20),
                          label: Text('شناسایی هوشمند رنگ با دوربین',
                              style: GoogleFonts.vazirmatn(
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color(0xFF2A2640)
                                : const Color(0xFF1E1B2E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Format Fields
                      _buildFormatField('HEX', _colorToHex(_currentColor),
                          inputColor, isDark),
                      const SizedBox(height: 12),
                      _buildFormatField('RGB', _colorToRgb(_currentColor),
                          inputColor, isDark),
                      const SizedBox(height: 12),
                      _buildFormatField('HSL', _colorToHsl(_currentColor),
                          inputColor, isDark),

                      const SizedBox(height: 24),

                      // Palette
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('پالت رنگی پیشنهادی',
                            style: GoogleFonts.vazirmatn(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                              child: _buildPaletteItem(
                                  'مکمل',
                                  _getComplementary(_currentColor),
                                  inputColor,
                                  isDark)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _buildAnalogousPalette(
                                  'مشابه',
                                  _getAnalogous(_currentColor),
                                  inputColor,
                                  isDark)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatField(
      String label, String value, Color inputColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: inputColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _copyToClipboard(value),
                    icon: Icon(Icons.content_copy,
                        size: 20, color: Colors.grey[400]),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(value,
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 40), // spacer for symmetry if needed
                ],
              ),
            ),
            Positioned(
              top: -8,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E1B2E)
                    : Colors.white,
                child: Text(label,
                    style: GoogleFonts.vazirmatn(
                        color: Colors.grey[400], fontSize: 10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaletteItem(
      String label, Color color, Color inputColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  GoogleFonts.vazirmatn(color: Colors.grey[400], fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: color.withOpacity(0.3), blurRadius: 4)
                      ])),
              const SizedBox(width: 8),
              Text(_colorToHex(color),
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: isDark ? Colors.white70 : Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalogousPalette(
      String label, List<Color> colors, Color inputColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  GoogleFonts.vazirmatn(color: Colors.grey[400], fontSize: 10)),
          const SizedBox(height: 8),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                          color: colors[0],
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E1B2E)
                                  : Colors.white,
                              width: 2))),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                            color: colors[1],
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isDark
                                    ? const Color(0xFF1E1B2E)
                                    : Colors.white,
                                width: 2))),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
