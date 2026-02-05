import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import 'package:share_plus/share_plus.dart';

class DigitalSignaturePage extends StatefulWidget {
  const DigitalSignaturePage({super.key});

  @override
  State<DigitalSignaturePage> createState() => _DigitalSignaturePageState();
}

class _DigitalSignaturePageState extends State<DigitalSignaturePage> {
  int _selectedTab = 0; // 0: Draw, 1: Type

  // Draw State
  late SignatureController _signatureController;
  double _strokeWidth = 3.0;
  Color _strokeColor = Colors.black;

  // Type State
  final TextEditingController _typeController = TextEditingController();
  String _typedSignature = "";

  final List<Color> _availableColors = [
    Colors.black,
    const Color(0xFF1E40AF), // Deep Blue
    const Color(0xFFEF4444), // Red
    const Color(0xFF7F13EC), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: _strokeWidth,
      penColor: _strokeColor,
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _updateController() {
    _signatureController = SignatureController(
      penStrokeWidth: _strokeWidth,
      penColor: _strokeColor,
      exportBackgroundColor: Colors.transparent,
      points: _signatureController.points,
    );
    setState(() {});
  }

  Future<void> _exportSignature() async {
    if (_selectedTab == 0) {
      if (_signatureController.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لطفاً ابتدا امضا را ترسیم کنید')),
        );
        return;
      }
      final Uint8List? data = await _signatureController.toPngBytes();
      if (data != null) {
        final xFile =
            XFile.fromData(data, mimeType: 'image/png', name: 'signature.png');
        await Share.shareXFiles([xFile], text: 'امضای دیجیتال من');
      }
    } else {
      // For typed signature, we might want to capture the widget as an image
      // But for now, let's just show a message or use a basic export if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'قابلیت خروجی تصویر برای امضای نوشتاری در نسخه‌های بعدی اضافه می‌شود')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    final primaryColor = const Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context, isDark),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Tabs
                    _buildTabs(isDark, surfaceColor, primaryColor),

                    // Canvas / Input Area
                    if (_selectedTab == 0)
                      _buildDrawArea(primaryColor, surfaceColor)
                    else
                      _buildTypeArea(primaryColor, surfaceColor),

                    const SizedBox(height: 24),

                    // Controls
                    if (_selectedTab == 0)
                      _buildControls(surfaceColor, primaryColor, isDark),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            _buildBottomBar(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_forward,
                color: isDark ? Colors.white : Colors.black87),
          ),
          Text(
            'تولید امضای دیجیتال',
            style: GoogleFonts.vazirmatn(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTabs(bool isDark, Color surfaceColor, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF261933) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildTabItem(1, 'نوشتن امضا', _selectedTab == 1, primaryColor),
            _buildTabItem(0, 'کشیدن امضا', _selectedTab == 0, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
      int index, String title, bool isSelected, Color primaryColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF4d3267)
                    : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : primaryColor)
                    : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawArea(Color primaryColor, Color surfaceColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: const Color(0xFF4d3267).withOpacity(0.3), width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4))
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Simplified background pattern using custom paint or just opacity
                  Opacity(
                    opacity: 0.05,
                    child: GridPaper(
                      color: primaryColor,
                      divisions: 1,
                      subdivisions: 1,
                      interval: 100,
                      child: Container(),
                    ),
                  ),
                  Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.transparent,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => _signatureController.clear(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.red, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'امضای خود را در کادر بالا بکشید',
            style: GoogleFonts.vazirmatn(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeArea(Color primaryColor, Color surfaceColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10)
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: _typeController,
                  onChanged: (val) => setState(() => _typedSignature = val),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'نام خود را وارد کنید',
                    hintStyle: GoogleFonts.vazirmatn(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                  ),
                ),
                const SizedBox(height: 32),
                if (_typedSignature.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        _typedSignature,
                        style: GoogleFonts.vazirmatn(
                          // Ideally a cursive font if available
                          fontSize: 40,
                          color: _strokeColor,
                        ),
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

  Widget _buildControls(Color surfaceColor, Color primaryColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            // Thickness
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.brush, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text('ضخامت قلم',
                        style: GoogleFonts.vazirmatn(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87)),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('${_strokeWidth.toInt()}px',
                      style: GoogleFonts.jetBrainsMono(
                          fontSize: 12, color: primaryColor)),
                ),
              ],
            ),
            Slider(
              value: _strokeWidth,
              min: 1,
              max: 10,
              activeColor: primaryColor,
              onChanged: (val) {
                setState(() {
                  _strokeWidth = val;
                  _updateController();
                });
              },
            ),
            const SizedBox(height: 20),

            // Color Palette
            Align(
              alignment: Alignment.centerRight,
              child: Text('رنگ قلم',
                  style: GoogleFonts.vazirmatn(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87)),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ..._availableColors.map((color) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _strokeColor = color;
                          _updateController();
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: _strokeColor == color
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3),
                          boxShadow: [
                            if (_strokeColor == color)
                              BoxShadow(
                                  color: color.withOpacity(0.4), blurRadius: 8)
                          ],
                        ),
                        child: _strokeColor == color
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    )),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey[100],
                      shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.grey, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF191022).withOpacity(0.8)
            : Colors.white.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _exportSignature,
          icon: const Icon(Icons.download, size: 24),
          label: Text('دانلود امضا (PNG)',
              style: GoogleFonts.vazirmatn(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
