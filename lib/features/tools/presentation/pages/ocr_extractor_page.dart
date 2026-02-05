import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:share_plus/share_plus.dart';

class OcrExtractorPage extends StatefulWidget {
  const OcrExtractorPage({super.key});

  @override
  State<OcrExtractorPage> createState() => _OcrExtractorPageState();
}

class _OcrExtractorPageState extends State<OcrExtractorPage>
    with SingleTickerProviderStateMixin {
  File? _image;
  String _extractedText = '';
  bool _isScanning = false;
  final picker = ImagePicker();
  late AnimationController _scanController;
  final TextRecognizer _textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin); // For now latin/scripting

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'این قابلیت در نسخه وب با محدودیت مواجه است. لطفاً از نسخه دسکتاپ یا موبایل استفاده کنید.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _extractedText = '';
      });
      _scanImage();
    }
  }

  Future<void> _scanImage() async {
    if (_image == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      final inputImage = InputImage.fromFile(_image!);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      setState(() {
        _extractedText = recognizedText.text;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('خطا در پردازش تصویر: $e'),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF2A1E36) : Colors.white;
    final primaryColor = const Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.history, color: Colors.white),
                  ),
                ],
                title: Text(
                  'استخراج متن از تصویر',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Image Preview / Scanner
                      _buildScannerView(primaryColor, surfaceColor),
                      const SizedBox(height: 12),

                      if (_image != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'فایل: ${_image!.path.split('/').last}',
                              style: GoogleFonts.vazirmatn(
                                  fontSize: 10, color: Colors.white38),
                            ),
                            TextButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.upload_file, size: 16),
                              label: Text('تغییر فایل',
                                  style: GoogleFonts.vazirmatn(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              style: TextButton.styleFrom(
                                  foregroundColor: primaryColor),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildResultPanel(isDark, surfaceColor, primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView(Color primaryColor, Color surfaceColor) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF120C18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (_image != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.8,
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        color: primaryColor.withOpacity(0.5), size: 64),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('انتخاب تصویر',
                          style: GoogleFonts.vazirmatn(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
            if (_isScanning) ...[
              // Laser Line
              AnimatedBuilder(
                animation: _scanController,
                builder: (context, child) {
                  return Positioned(
                    top: _scanController.value *
                        240, // Approximate height adjustment
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: primaryColor,
                              blurRadius: 10,
                              spreadRadius: 2),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // Processing Tag
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _PulseCircle(),
                        const SizedBox(width: 8),
                        Text(
                          'در حال پردازش...',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultPanel(
      bool isDark, Color surfaceColor, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 6,
              decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.text_fields, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'متن استخراج شده',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_extractedText.isNotEmpty) {
                          Clipboard.setData(
                              ClipboardData(text: _extractedText));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('کپی شد'),
                                behavior: SnackBarBehavior.floating),
                          );
                        }
                      },
                      icon: const Icon(Icons.content_copy,
                          size: 20, color: Colors.white70),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_extractedText.isNotEmpty) {
                          Share.share(_extractedText);
                        }
                      },
                      icon: const Icon(Icons.share,
                          size: 20, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: TextField(
                  controller: TextEditingController(text: _extractedText),
                  maxLines: null,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.6),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    border: InputBorder.none,
                    hintText: 'متن استخراج شده در اینجا نمایش داده می‌شود...',
                    hintStyle: GoogleFonts.vazirmatn(color: Colors.white24),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.translate, size: 20),
                    label: Text('ترجمه',
                        style:
                            GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_extractedText.isNotEmpty) {
                        Clipboard.setData(ClipboardData(text: _extractedText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('کپی شد'),
                              behavior: SnackBarBehavior.floating),
                        );
                      }
                    },
                    icon: const Icon(Icons.content_copy, size: 20),
                    label: Text('کپی متن',
                        style:
                            GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      shadowColor: primaryColor.withOpacity(0.4),
                      elevation: 8,
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
}

class _PulseCircle extends StatefulWidget {
  const _PulseCircle();

  @override
  State<_PulseCircle> createState() => _PulseCircleState();
}

class _PulseCircleState extends State<_PulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.2).animate(_pulseController),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController),
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
              color: Color(0xFF7F13EC), shape: BoxShape.circle),
        ),
      ),
    );
  }
}
