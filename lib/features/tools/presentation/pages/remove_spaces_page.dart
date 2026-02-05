import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RemoveSpacesPage extends StatefulWidget {
  const RemoveSpacesPage({super.key});

  @override
  State<RemoveSpacesPage> createState() => _RemoveSpacesPageState();
}

class _RemoveSpacesPageState extends State<RemoveSpacesPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  int _selectedMode = 0; // 0: Remove extra spaces, 1: Remove all spaces

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  void _cleanText() {
    String text = _inputController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفا متن ورودی را وارد کنید')),
      );
      return;
    }

    String cleaned = '';
    if (_selectedMode == 0) {
      // Remove extra spaces (trim and replace multiple spaces/newlines with single)
      // Preserving single newlines might be desired or just collapses everything to one space?
      // "Extra spaces" usually means converting 2+ spaces to 1, and 2+ newlines to 1 or appropriate.
      // Simple implementation: Replace any whitespace sequence with a single space, then trim.
      // But preserving paragraph structure (single newline) is often better.
      // Let's assume standard "collapse whitespace":
      cleaned = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    } else {
      // Remove all spaces
      cleaned = text.replaceAll(RegExp(r'\s+'), '');
    }

    setState(() {
      _outputController.text = cleaned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = const Color(0xFF7F13EC);
    final background =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surface = isDark ? const Color(0xFF261933) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_forward,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  Text(
                    'حذف فواصل اضافه',
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
                    // Input Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('متن ورودی',
                            style: GoogleFonts.vazirmatn(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700])),
                        TextButton.icon(
                          onPressed: () => _inputController.clear(),
                          icon: const Icon(Icons.delete_outline,
                              size: 16, color: Colors.redAccent),
                          label: Text('پاک کردن',
                              style: GoogleFonts.vazirmatn(
                                  color: Colors.redAccent, fontSize: 12)),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.transparent),
                          ),
                          child: TextField(
                            controller: _inputController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: GoogleFonts.vazirmatn(
                                color: isDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              hintText:
                                  'متن خود را اینجا وارد کنید یا بچسبانید...',
                              hintStyle: GoogleFonts.vazirmatn(
                                  color: Colors.grey[500]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: InkWell(
                            onTap: () async {
                              final data =
                                  await Clipboard.getData('text/plain');
                              if (data?.text != null) {
                                _inputController.text = data!.text!;
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: primary.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.content_paste,
                                      size: 16, color: primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'چسباندن',
                                    style: GoogleFonts.vazirmatn(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Controls
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color:
                            isDark ? const Color(0xFF261933) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          _buildToggleItem(
                              'فقط فواصل اضافه', 0, isDark, primary),
                          _buildToggleItem(
                              'حذف تمامی فواصل', 1, isDark, primary),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _cleanText,
                        icon: const Icon(Icons.auto_fix_high,
                            color: Colors.white),
                        label: Text('پاکسازی متن',
                            style: GoogleFonts.vazirmatn(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          shadowColor: primary.withOpacity(0.4),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Output Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('متن خروجی',
                            style: GoogleFonts.vazirmatn(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700])),
                        Row(
                          children: [
                            Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            Text('آماده',
                                style: GoogleFonts.vazirmatn(
                                    fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF20152A)
                                : Colors.grey[
                                    50], // Slightly darker/different bg for output
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.grey[200]!),
                          ),
                          child: TextField(
                            controller: _outputController,
                            readOnly: true,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: GoogleFonts.vazirmatn(
                                color:
                                    isDark ? Colors.white70 : Colors.black87),
                            decoration: InputDecoration(
                              hintText:
                                  'متن پاکسازی شده اینجا نمایش داده می‌شود...',
                              hintStyle: GoogleFonts.vazirmatn(
                                  color: Colors.grey[500]),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: InkWell(
                            onTap: () {
                              if (_outputController.text.isNotEmpty) {
                                Clipboard.setData(ClipboardData(
                                    text: _outputController.text));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('متن کپی شد'),
                                        duration: Duration(seconds: 1)));
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white : Colors.black87,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4))
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.content_copy,
                                      size: 16,
                                      color: isDark
                                          ? Colors.black87
                                          : Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'کپی متن',
                                    style: GoogleFonts.vazirmatn(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.black87
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String label, int index, bool isDark, Color primary) {
    bool isSelected = _selectedMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF261933) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected && !isDark
                ? Border.all(color: Colors.black12)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 4)
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}
