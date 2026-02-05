import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Base64ConverterPage extends StatefulWidget {
  const Base64ConverterPage({super.key});

  @override
  State<Base64ConverterPage> createState() => _Base64ConverterPageState();
}

class _Base64ConverterPageState extends State<Base64ConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  final TextEditingController _fileBase64Controller = TextEditingController();

  bool _isEncodeMode = true;
  int _activeTab = 0; // 0: Text, 1: File
  String _inputInfo = 'حجم: ۰ بایت | ۰ کاراکتر';

  PlatformFile? _selectedFile;
  bool _isProcessingFile = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_processTextTransformation);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    _fileBase64Controller.dispose();
    super.dispose();
  }

  void _processTextTransformation() {
    if (_activeTab != 0) return;

    String input = _inputController.text;
    if (input.isEmpty) {
      setState(() {
        _outputController.text = '';
        _inputInfo = 'حجم: ۰ بایت | ۰ کاراکتر';
      });
      return;
    }

    try {
      if (_isEncodeMode) {
        List<int> bytes = utf8.encode(input);
        _outputController.text = base64.encode(bytes);
        _updateTextInfo(bytes.length, input.length);
      } else {
        String normalized = input.replaceAll(RegExp(r'\s+'), '');
        List<int> decodedBytes = base64.decode(normalized);
        _outputController.text = utf8.decode(decodedBytes);
        _updateTextInfo(input.length, _outputController.text.length);
      }
    } catch (e) {
      setState(() {
        _outputController.text = 'خطا در پردازش داده‌ها...';
      });
    }
  }

  void _updateTextInfo(int bytes, int chars) {
    setState(() {
      _inputInfo = 'حجم: $bytes بایت | $chars کاراکتر';
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _isProcessingFile = true;
        });

        // Convert to Base64
        if (_selectedFile!.bytes != null) {
          String base64String = base64.encode(_selectedFile!.bytes!);
          _fileBase64Controller.text = base64String;
        } else if (_selectedFile!.path != null) {
          File file = File(_selectedFile!.path!);
          List<int> bytes = await file.readAsBytes();
          _fileBase64Controller.text = base64.encode(bytes);
        }

        setState(() {
          _isProcessingFile = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('خطا در انتخاب فایل'),
            behavior: SnackBarBehavior.floating),
      );
      setState(() {
        _isProcessingFile = false;
      });
    }
  }

  Future<void> _saveBase64ToFile() async {
    if (_fileBase64Controller.text.isEmpty) return;

    try {
      String base64String =
          _fileBase64Controller.text.trim().replaceAll(RegExp(r'\s+'), '');
      List<int> bytes = base64.decode(base64String);

      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/decoded_file_${DateTime.now().millisecondsSinceEpoch}';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      await Share.shareXFiles([XFile(filePath)],
          text: 'فایل بازگشایی شده از Base64');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('شناسه Base64 معتبر نیست'),
            behavior: SnackBarBehavior.floating),
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
    final borderColor = isDark ? const Color(0xFF4D3267) : Colors.grey[300]!;

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
          'مبدل Base64',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: borderColor, width: 1)),
              ),
              child: Row(
                children: [
                  _buildTopTab('متن ↔ Base64', 0, primaryColor),
                  _buildTopTab('فایل ↔ Base64', 1, primaryColor),
                ],
              ),
            ),
          ),

          Expanded(
            child: _activeTab == 0
                ? _buildTextTab(isDark, surfaceColor, primaryColor, borderColor)
                : _buildFileTab(
                    isDark, surfaceColor, primaryColor, borderColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTab(String title, int index, Color primaryColor) {
    bool isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? primaryColor : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextTab(
      bool isDark, Color surfaceColor, Color primaryColor, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'UTF-8',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 10,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                _isEncodeMode ? 'متن ورودی' : 'کد Base64 ورودی',
                style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              TextField(
                controller: _inputController,
                maxLines: 5,
                style: GoogleFonts.vazirmatn(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'متن خود را اینجا وارد کنید...',
                  hintStyle: GoogleFonts.vazirmatn(color: Colors.grey[500]),
                  filled: true,
                  fillColor: surfaceColor,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: primaryColor, width: 2)),
                ),
              ),
              if (_inputController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _inputController.clear(),
                    color: Colors.grey[400],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(_inputInfo,
              style:
                  GoogleFonts.vazirmatn(fontSize: 10, color: Colors.grey[500])),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? surfaceColor : Colors.grey[200],
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      _buildToggleItem(
                          'Decode',
                          !_isEncodeMode,
                          isDark,
                          primaryColor,
                          () => setState(() => _isEncodeMode = false)),
                      _buildToggleItem(
                          'Encode',
                          _isEncodeMode,
                          isDark,
                          primaryColor,
                          () => setState(() => _isEncodeMode = true)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child:
                      Icon(Icons.arrow_downward, color: primaryColor, size: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isEncodeMode ? 'خروجی Base64' : 'متن بازگشایی شده',
            style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[300] : Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _outputController,
            maxLines: 5,
            readOnly: true,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600]),
            decoration: InputDecoration(
              hintText: 'خروجی اینجا نمایش داده می‌شود...',
              filled: true,
              fillColor: isDark ? const Color(0xFF150D1C) : Colors.grey[50]!,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildActionButton(
                      Icons.download, 'ذخیره متن', () {}, isDark,
                      surfaceColor: surfaceColor, borderColor: borderColor)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(Icons.copy, 'کپی نتیجه', () {
                  if (_outputController.text.isNotEmpty) {
                    Clipboard.setData(
                        ClipboardData(text: _outputController.text));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('کپی شد'),
                        behavior: SnackBarBehavior.floating));
                  }
                }, isDark, isPrimary: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFileTab(
      bool isDark, Color surfaceColor, Color primaryColor, Color borderColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File Picker Section
          Text('فایل ورودی',
              style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.grey[700])),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: borderColor, style: BorderStyle.solid),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      color: primaryColor, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    _selectedFile == null
                        ? 'برای انتخاب فایل کلیک کنید'
                        : _selectedFile!.name,
                    style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  if (_selectedFile != null)
                    Text(
                      '${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 12, color: Colors.grey[500]),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text('رشته Base64 فایل',
              style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[300] : Colors.grey[700])),
          const SizedBox(height: 8),
          TextField(
            controller: _fileBase64Controller,
            maxLines: 8,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[700]),
            decoration: InputDecoration(
              hintText:
                  'کد Base64 فایل اینجا نمایش داده می‌شود یا می‌توانید کد خود را اینجا وارد کنید...',
              filled: true,
              fillColor: isDark ? const Color(0xFF150D1C) : Colors.grey[50]!,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: borderColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: primaryColor, width: 2)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildActionButton(Icons.file_open, 'تبدیل به فایل',
                      _saveBase64ToFile, isDark,
                      surfaceColor: surfaceColor, borderColor: borderColor)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(Icons.copy, 'کپی Base64', () {
                  if (_fileBase64Controller.text.isNotEmpty) {
                    Clipboard.setData(
                        ClipboardData(text: _fileBase64Controller.text));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('کپی شد'),
                        behavior: SnackBarBehavior.floating));
                  }
                }, isDark, isPrimary: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String mode, bool isSelected, bool isDark,
      Color primaryColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? primaryColor : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            mode == 'Encode' ? 'کدگذاری (Encode)' : 'بازگشایی (Decode)',
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black87)
                    : (isDark ? Colors.grey[400] : Colors.grey[500])),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onTap, bool isDark,
      {bool isPrimary = false, Color? surfaceColor, Color? borderColor}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label, style: GoogleFonts.vazirmatn(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF7F13EC) : surfaceColor,
        foregroundColor:
            isPrimary ? Colors.white : (isDark ? Colors.white : Colors.black87),
        elevation: isPrimary ? 4 : 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: borderColor ?? Colors.transparent)),
      ),
    );
  }
}
