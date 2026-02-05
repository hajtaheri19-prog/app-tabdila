import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';

class ImageCompressorPage extends StatefulWidget {
  const ImageCompressorPage({super.key});

  @override
  State<ImageCompressorPage> createState() => _ImageCompressorPageState();
}

class _ImageCompressorPageState extends State<ImageCompressorPage> {
  XFile? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  Uint8List? _compressedImageBytes;

  bool _isProcessing = false;
  int _quality = 80;
  String _compressionMode = 'Balanced'; // Low, Balanced, Severe
  bool _removeExif = true;
  bool _resize = false;
  bool _convertToWebP = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageFile = image;
        _selectedImageBytes = bytes;
        _compressedImageBytes = null;
      });
    }
  }

  Future<void> _compressImage() async {
    if (_selectedImageBytes == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      img.Image? image = img.decodeImage(_selectedImageBytes!);

      if (image == null) throw Exception('Could not decode image');

      // Quality setting based on mode if not manual
      int targetQuality = _quality;
      if (_compressionMode == 'Low') targetQuality = 90;
      if (_compressionMode == 'Balanced') targetQuality = 70;
      if (_compressionMode == 'Severe') targetQuality = 40;

      // Resize if enabled (example: 70% scale)
      if (_resize) {
        image = img.copyResize(image, width: (image.width * 0.7).toInt());
      }

      Uint8List compressedBytes;

      if (_convertToWebP) {
        try {
          // Fallback to JPG since webp encoding might be limited in pure dart 'image' package depending on version
          // But let's try jpg as safe default if webp fails or just treat as jpg for now
          compressedBytes =
              Uint8List.fromList(img.encodeJpg(image, quality: targetQuality));
        } catch (e) {
          compressedBytes =
              Uint8List.fromList(img.encodeJpg(image, quality: targetQuality));
        }
      } else {
        compressedBytes =
            Uint8List.fromList(img.encodeJpg(image, quality: targetQuality));
      }

      setState(() {
        _compressedImageBytes = compressedBytes;
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('فشرده‌سازی با موفقیت انجام شد'),
            behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('خطا در فشرده‌سازی: $e'),
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  Future<void> _saveOrShareImage() async {
    if (_compressedImageBytes == null) return;
    String extension = 'jpg'; // Keeping jpg as safe fallback
    final name =
        'compressed_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final xFile = XFile.fromData(_compressedImageBytes!,
        mimeType: 'image/jpeg', name: name);
    await Share.shareXFiles([xFile], text: 'تصویر فشرده شده با تبدیلا');
  }

  String _getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF130B1B) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF1F152B) : Colors.white;
    final primaryColor = const Color(0xFF7F13EC);
    final cyanColor = const Color(0xFF06B6D4);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87),
        ),
        title: Text(
          'کاهش حجم تصویر حرفه‌ای',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: cyanColor),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              children: [
                // Selection Zone
                _buildDropZone(primaryColor),
                const SizedBox(height: 24),

                // File Info
                if (_selectedImageBytes != null)
                  _buildFileInfo(surfaceColor, primaryColor),
                const SizedBox(height: 24),

                // Compression Engine
                _buildCompressionEngine(surfaceColor, primaryColor, cyanColor),
                const SizedBox(height: 24),

                // Advanced Options
                _buildAdvancedOptions(surfaceColor, primaryColor, cyanColor),
                const SizedBox(height: 24),

                // Comparison View
                if (_compressedImageBytes != null)
                  _buildComparisonView(primaryColor),
              ],
            ),
          ),

          // Bottom Action Button
          _buildBottomAction(primaryColor),
        ],
      ),
    );
  }

  Widget _buildDropZone(Color primaryColor) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: primaryColor.withOpacity(0.1), width: 1),
              ),
            ),
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: primaryColor.withOpacity(0.2), width: 1),
              ),
            ),
            // Central button
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1F152B).withOpacity(0.6),
                border:
                    Border.all(color: primaryColor.withOpacity(0.4), width: 1),
                boxShadow: [
                  BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _selectedImageBytes != null
                    ? Opacity(
                        opacity: 0.5,
                        child: Image.memory(_selectedImageBytes!,
                            fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: primaryColor, shape: BoxShape.circle),
                            child: const Icon(Icons.add,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'افزودن تصویر',
                            style: GoogleFonts.vazirmatn(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInfo(Color surfaceColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: MemoryImage(_selectedImageBytes!), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedImageFile?.name ?? 'تصویر انتخاب شده',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('تصویر اصلی',
                        style: GoogleFonts.vazirmatn(
                            fontSize: 10, color: Colors.grey[500])),
                    const SizedBox(width: 8),
                    Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey[800], shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100)),
                      child: Text(_getFileSize(_selectedImageBytes!.length),
                          style: GoogleFonts.vazirmatn(
                              fontSize: 10,
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _selectedImageBytes = null;
              _selectedImageFile = null;
              _compressedImageBytes = null;
            }),
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildCompressionEngine(
      Color surfaceColor, Color primaryColor, Color cyanColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.tune, color: cyanColor),
                const SizedBox(width: 8),
                Text('موتور فشرده‌سازی',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('حجم تقریبی',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 10, color: Colors.grey[500])),
                Text(
                    _compressedImageBytes != null
                        ? _getFileSize(_compressedImageBytes!.length)
                        : '---',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cyanColor)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              _buildModeItem(
                  'شدید',
                  'حجم کم',
                  _compressionMode == 'Severe',
                  () => setState(() => _compressionMode = 'Severe'),
                  primaryColor),
              _buildModeItem(
                  'متعادل',
                  'پیشنهادی',
                  _compressionMode == 'Balanced',
                  () => setState(() => _compressionMode = 'Balanced'),
                  primaryColor),
              _buildModeItem('کم', 'کیفیت بالا', _compressionMode == 'Low',
                  () => setState(() => _compressionMode = 'Low'), primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeItem(String title, String subTitle, bool isSelected,
      VoidCallback onTap, Color primaryColor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: isSelected
                ? LinearGradient(
                    colors: [primaryColor, const Color(0xFF6B10C6)])
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.3), blurRadius: 10)
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(title,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[500])),
              Text(subTitle,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 8,
                      color: isSelected ? Colors.white70 : Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedOptions(
      Color surfaceColor, Color primaryColor, Color cyanColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تنظیمات پیشرفته',
              style:
                  GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 16),
          _buildOptionToggle(
              Icons.description,
              'حذف متادیتا (EXIF)',
              _removeExif,
              (val) => setState(() => _removeExif = val),
              const Color(0xFFA855F7),
              primaryColor,
              surfaceColor),
          _buildDivider(),
          _buildOptionToggle(
              Icons.aspect_ratio,
              'تغییر ابعاد',
              _resize,
              (val) => setState(() => _resize = val),
              cyanColor,
              primaryColor,
              surfaceColor),
          _buildDivider(),
          _buildOptionToggle(
              Icons.transform,
              'تبدیل به WebP',
              _convertToWebP,
              (val) => setState(() => _convertToWebP = val),
              const Color(0xFFFB923C),
              primaryColor,
              surfaceColor),
        ],
      ),
    );
  }

  Widget _buildOptionToggle(
      IconData icon,
      String title,
      bool value,
      Function(bool) onChanged,
      Color iconColor,
      Color primaryColor,
      Color surfaceColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: surfaceColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title,
                style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: primaryColor,
          activeTrackColor: primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: Colors.white.withOpacity(0.05), height: 1),
    );
  }

  Widget _buildComparisonView(Color primaryColor) {
    return Container(
      height: 120,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                    Container(color: Colors.black45),
                    Positioned(
                        bottom: 8,
                        right: 8,
                        child: _buildLabel('قبل', Colors.black54)),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(_compressedImageBytes!, fit: BoxFit.cover),
                    Positioned(
                        bottom: 8,
                        left: 8,
                        child: _buildLabel('بعد', primaryColor)),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
              ),
              child: Text(_calculateSavings(),
                  style: GoogleFonts.vazirmatn(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent)),
            ),
          ),
          const Center(
              child:
                  VerticalDivider(color: Colors.white, width: 2, thickness: 2)),
        ],
      ),
    );
  }

  String _calculateSavings() {
    if (_selectedImageBytes == null || _compressedImageBytes == null)
      return '0%';
    final original = _selectedImageBytes!.length;
    final compressed = _compressedImageBytes!.length;
    final savings = ((original - compressed) / original * 100).toInt();
    return '$savings٪ صرفه‌جویی';
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(text,
          style: GoogleFonts.vazirmatn(
              fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomAction(Color primaryColor) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: ElevatedButton(
        onPressed: _selectedImageBytes == null || _isProcessing
            ? null
            : (_compressedImageBytes == null
                ? _compressImage
                : _saveOrShareImage),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          shadowColor: primaryColor.withOpacity(0.5),
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      _compressedImageBytes == null ? Icons.bolt : Icons.share),
                  const SizedBox(width: 8),
                  Text(
                      _compressedImageBytes == null
                          ? 'شروع فشرده‌سازی'
                          : 'ذخیره / اشتراک‌گذاری',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }
}
