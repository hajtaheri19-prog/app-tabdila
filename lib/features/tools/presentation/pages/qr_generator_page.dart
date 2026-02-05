import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrGeneratorPage extends StatefulWidget {
  const QrGeneratorPage({super.key});

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage> {
  final TextEditingController _contentController = TextEditingController();
  String _qrType = 'link';
  double _qrSize = 180;
  Color _qrColor = Colors.black;
  Color _bgColor = Colors.white;
  bool _isTransparent = false;
  String _dotStyle = 'Rounded';
  String _eyeStyle = 'Extra Rounded';

  final GlobalKey _qrKey = GlobalKey();

  Future<void> _exportQr(String format) async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final xFile = XFile.fromData(
        bytes,
        mimeType: 'image/png',
        name: 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await Share.shareXFiles([xFile], text: 'کد QR من');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('خطا در ذخیره‌سازی: $e'),
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6);
    final surfaceColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final primaryColor = const Color(0xFF7C3AED);
    final borderColor =
        isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    final textSubColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('تبدیلا',
                style: GoogleFonts.vazirmatn(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.qr_code_2, color: primaryColor, size: 24),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? Colors.white : Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Breadcrumbs placeholder style
            Row(
              children: [
                Text('خانه',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: textSubColor.withOpacity(0.7))),
                Icon(Icons.chevron_right,
                    size: 12, color: textSubColor.withOpacity(0.7)),
                Text('جعبه ابزار',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: textSubColor.withOpacity(0.7))),
                Icon(Icons.chevron_right,
                    size: 12, color: textSubColor.withOpacity(0.7)),
                Text('ساخت کد QR',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 24),

            // Content Section
            _buildSection(
              title: 'محتوای QR Code',
              icon: Icons.link,
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF111827) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _qrType,
                      isExpanded: true,
                      icon: const Icon(Icons.expand_more),
                      items: [
                        DropdownMenuItem(
                            value: 'link',
                            child: Text('لینک (URL)',
                                style: GoogleFonts.vazirmatn(fontSize: 14))),
                        DropdownMenuItem(
                            value: 'text',
                            child: Text('متن ساده',
                                style: GoogleFonts.vazirmatn(fontSize: 14))),
                        DropdownMenuItem(
                            value: 'wifi',
                            child: Text('وایفای',
                                style: GoogleFonts.vazirmatn(fontSize: 14))),
                        DropdownMenuItem(
                            value: 'email',
                            child: Text('ایمیل',
                                style: GoogleFonts.vazirmatn(fontSize: 14))),
                        DropdownMenuItem(
                            value: 'phone',
                            child: Text('شماره تماس',
                                style: GoogleFonts.vazirmatn(fontSize: 14))),
                      ],
                      onChanged: (val) => setState(() => _qrType = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  onChanged: (val) => setState(() {}),
                  textAlign: TextAlign.right,
                  style: GoogleFonts.vazirmatn(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: '...لینک خود را وارد کنید',
                    hintStyle: GoogleFonts.vazirmatn(color: Colors.grey[400]),
                    filled: true,
                    fillColor:
                        isDark ? const Color(0xFF111827) : Colors.grey[50],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.link, color: primaryColor, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Design Section
            _buildSection(
              title: 'طراحی QR Code',
              icon: Icons.palette,
              primaryColor: primaryColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('اندازه',
                        style: GoogleFonts.vazirmatn(
                            fontSize: 14, color: textSubColor)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text('${_qrSize.toInt()}px',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Slider(
                  value: _qrSize,
                  min: 100,
                  max: 500,
                  activeColor: primaryColor,
                  onChanged: (val) => setState(() => _qrSize = val),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: _buildColorPicker(
                            'رنگ QR',
                            _qrColor,
                            (c) => setState(() => _qrColor = c),
                            isDark,
                            primaryColor)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildColorPicker(
                            'رنگ پس‌زمینه',
                            _bgColor,
                            (c) => setState(() => _bgColor = c),
                            isDark,
                            primaryColor)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                    'شکل نقاط',
                    _dotStyle,
                    ['Rounded', 'Square', 'Classic'],
                    (v) => setState(() => _dotStyle = v!),
                    isDark),
                const SizedBox(height: 12),
                _buildDropdown(
                    'شکل گوشه‌ها',
                    _eyeStyle,
                    ['Extra Rounded', 'Sharp', 'Standard'],
                    (v) => setState(() => _eyeStyle = v!),
                    isDark),
                const SizedBox(height: 16),
                _buildToggle(
                    'پس‌زمینه شفاف',
                    _isTransparent,
                    (v) => setState(() => _isTransparent = v),
                    primaryColor,
                    isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Preview Section
            RepaintBoundary(
              key: _qrKey,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: -5)
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: _contentController.text.isEmpty
                          ? 'https://google.com'
                          : _contentController.text,
                      version: QrVersions.auto,
                      size: _qrSize,
                      backgroundColor:
                          _isTransparent ? Colors.transparent : _bgColor,
                      eyeStyle: QrEyeStyle(
                        eyeShape: _eyeStyle == 'Sharp'
                            ? QrEyeShape.square
                            : QrEyeShape.circle,
                        color: _qrColor,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: _dotStyle == 'Square'
                            ? QrDataModuleShape.square
                            : QrDataModuleShape.circle,
                        color: _qrColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('پیش‌نمایش زنده',
                        style: GoogleFonts.vazirmatn(
                            fontSize: 14,
                            color: textSubColor,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: _buildExportButton(
                          'PNG', primaryColor, true, () => _exportQr('png'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _buildExportButton(
                          'SVG',
                          isDark ? const Color(0xFF1F2937) : Colors.grey[100]!,
                          false,
                          () {},
                          isDark: isDark)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: _buildExportButton(
                          'WebP',
                          isDark ? const Color(0xFF1F2937) : Colors.grey[100]!,
                          false,
                          () {},
                          isDark: isDark)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required IconData icon,
      required Color primaryColor,
      required Color surfaceColor,
      required Color borderColor,
      required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(title,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Icon(Icons.expand_less, color: primaryColor),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildColorPicker(String label, Color color, Function(Color) onSelect,
      bool isDark, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Simple color picker mock
            onSelect(color == Colors.black ? primaryColor : Colors.black);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        color: color, borderRadius: BorderRadius.circular(6))),
                const SizedBox(width: 8),
                Text(
                    '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 10, color: Colors.grey[500])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      Function(String?) onChanged, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items
                  .map((i) => DropdownMenuItem(
                      value: i,
                      child:
                          Text(i, style: GoogleFonts.vazirmatn(fontSize: 13))))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged,
      Color primaryColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.opacity, color: primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(
      String format, Color color, bool isPrimary, VoidCallback onTap,
      {bool isDark = false}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor:
            isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black87),
        elevation: isPrimary ? 4 : 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: isPrimary ? color.withOpacity(0.3) : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(format,
              style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500)),
          const SizedBox(width: 4),
          Icon(Icons.download, size: 16),
        ],
      ),
    );
  }
}
