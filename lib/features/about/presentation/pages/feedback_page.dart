import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String? _selectedCategory;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final List<String> _categories = [
    'گزارش باگ',
    'پیشنهاد',
    'انتقاد',
    'سایر',
  ];

  void _sendFeedback() {
    if (_selectedCategory == null ||
        _subjectController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لطفا تمامی فیلدها را پر کنید.',
              style: GoogleFonts.vazirmatn()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Logic to send feedback would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('پیام شما با موفقیت ارسال شد. ممنون از همراهی شما!',
            style: GoogleFonts.vazirmatn()),
        backgroundColor: const Color(0xFF7F13EC),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('پیشنهادات و انتقادات',
            style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('دسته بندی'),
              const SizedBox(height: 8),
              _buildCategoryDropdown(isDark),
              const SizedBox(height: 24),
              _buildLabel('موضوع'),
              const SizedBox(height: 8),
              _buildTextField(
                  _subjectController, 'مثلا: مشکل در تبدیل ارز', 1, isDark),
              const SizedBox(height: 24),
              _buildLabel('متن پیام'),
              const SizedBox(height: 8),
              _buildTextField(
                  _messageController, 'لطفا جزئیات را بنویسید...', 6, isDark),
              const SizedBox(height: 100), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _sendFeedback,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7F13EC),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ارسال بازخورد',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Icon(Icons.send, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text,
        style: GoogleFonts.vazirmatn(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey));
  }

  Widget _buildCategoryDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF251E2F) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? const Color(0xFF473B54)
                : Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCategory,
          hint: Text('انتخاب کنید',
              style: GoogleFonts.vazirmatn(color: Colors.grey)),
          dropdownColor: isDark ? const Color(0xFF251E2F) : Colors.white,
          onChanged: (val) => setState(() => _selectedCategory = val),
          items: _categories
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat, style: GoogleFonts.vazirmatn()),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, int lines, bool isDark) {
    return TextField(
      controller: controller,
      maxLines: lines,
      style: GoogleFonts.vazirmatn(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.vazirmatn(color: Colors.grey[500]),
        filled: true,
        fillColor: isDark ? const Color(0xFF251E2F) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: isDark
                  ? const Color(0xFF473B54)
                  : Colors.grey.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: isDark
                  ? const Color(0xFF473B54)
                  : Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7F13EC), width: 2),
        ),
      ),
    );
  }
}
