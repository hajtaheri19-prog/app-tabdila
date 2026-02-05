import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialPostGeneratorPage extends StatefulWidget {
  const SocialPostGeneratorPage({super.key});

  @override
  State<SocialPostGeneratorPage> createState() =>
      _SocialPostGeneratorPageState();
}

class _SocialPostGeneratorPageState extends State<SocialPostGeneratorPage> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();

  String _selectedPlatform = 'instagram';
  String _selectedTone = 'professional';
  bool _isGenerating = false;
  bool _hasGenerated = false;

  final List<String> _hashtags = ['#هوش_مصنوعی', '#تکنولوژی', '#استارتاپ'];

  @override
  void dispose() {
    _topicController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _generatePost() {
    if (_topicController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('لطفاً موضوع پست را وارد کنید',
              style: GoogleFonts.vazirmatn()),
          backgroundColor: Colors.red[700],
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    // Simulate AI generation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        _hasGenerated = true;
        _resultController.text =
            '🚀 محصول جدید ما اینجاست!\n\nبا افتخار از ابزار هوش مصنوعی جدیدمان رونمایی می‌کنیم. این ابزار به شما کمک می‌کند تا کارهای روزانه خود را ۱۰ برابر سریع‌تر انجام دهید.\n\nهمین حالا امتحان کنید و تفاوت را احساس کنید! ✨';
      });
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _resultController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('متن کپی شد', style: GoogleFonts.vazirmatn()),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF7F13EC),
      ),
    );
  }

  void _regenerate() {
    setState(() {
      _hasGenerated = false;
      _resultController.clear();
    });
    _generatePost();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF7F13EC);
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    final borderColor = isDark ? const Color(0xFF4D3267) : Colors.grey[200]!;
    final textSecondary = isDark ? const Color(0xFFAD92C9) : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor.withOpacity(0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_forward,
                            color: isDark ? Colors.white : Colors.black87),
                      ),
                      Text(
                        'تولید پست',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 40), // Spacer
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Headline
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'جادوی هوش مصنوعی',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'موضوع را وارد کنید تا هوش مصنوعی پست شبکه‌های اجتماعی شما را بنویسد.',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 16,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Topic Input
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'موضوع پست',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                children: [
                                  TextField(
                                    controller: _topicController,
                                    maxLines: 4,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      hintText:
                                          'مثال: راه‌اندازی ویژگی جدید در اپلیکیشن ما که به کاربران کمک می‌کند...',
                                      hintStyle: GoogleFonts.vazirmatn(
                                        color: isDark
                                            ? textSecondary
                                            : Colors.grey[400],
                                      ),
                                      filled: true,
                                      fillColor: surfaceColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide:
                                            BorderSide(color: borderColor),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide:
                                            BorderSide(color: borderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                            color: primaryColor, width: 2),
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    child: Icon(
                                      Icons.edit_note,
                                      color: primaryColor.withOpacity(0.5),
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Settings Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تنظیمات',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Platform Selection
                              Text(
                                'پلتفرم',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _buildPlatformChip(
                                    'instagram',
                                    'اینستاگرام',
                                    Icons.photo_camera,
                                    isDark,
                                    primaryColor,
                                    surfaceColor,
                                    borderColor,
                                  ),
                                  _buildPlatformChip(
                                    'twitter',
                                    'توییتر (X)',
                                    Icons.alternate_email,
                                    isDark,
                                    primaryColor,
                                    surfaceColor,
                                    borderColor,
                                  ),
                                  _buildPlatformChip(
                                    'linkedin',
                                    'لینکدین',
                                    Icons.work,
                                    isDark,
                                    primaryColor,
                                    surfaceColor,
                                    borderColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Tone Selection
                              Text(
                                'لحن گفتار',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: textSecondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildToneChip(
                                      'professional',
                                      '🧠 حرفه‌ای',
                                      isDark,
                                      primaryColor,
                                      surfaceColor,
                                      borderColor,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildToneChip(
                                      'friendly',
                                      '😎 دوستانه',
                                      isDark,
                                      primaryColor,
                                      surfaceColor,
                                      borderColor,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildToneChip(
                                      'creative',
                                      '🎨 خلاقانه',
                                      isDark,
                                      primaryColor,
                                      surfaceColor,
                                      borderColor,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildToneChip(
                                      'marketing',
                                      '🚀 تبلیغاتی',
                                      isDark,
                                      primaryColor,
                                      surfaceColor,
                                      borderColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  borderColor,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Result Preview
                        if (_hasGenerated)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'پیش‌نمایش',
                                      style: GoogleFonts.vazirmatn(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _regenerate,
                                      icon: Icon(
                                        Icons.refresh,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextField(
                                              controller: _resultController,
                                              maxLines: null,
                                              readOnly: true,
                                              textDirection: TextDirection.rtl,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              style: GoogleFonts.vazirmatn(
                                                fontSize: 16,
                                                height: 1.6,
                                                color: isDark
                                                    ? Colors.grey[100]
                                                    : Colors.grey[800],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Wrap(
                                              spacing: 8,
                                              runSpacing: 8,
                                              children: _hashtags
                                                  .map((tag) => Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: primaryColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: primaryColor
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          tag,
                                                          style: GoogleFonts
                                                              .vazirmatn(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF1F1429)
                                              : Colors.grey[50],
                                          border: Border(
                                            top: BorderSide(color: borderColor),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${_resultController.text.length} کاراکتر',
                                              style: GoogleFonts.vazirmatn(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: textSecondary,
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: _copyToClipboard,
                                              icon: const Icon(
                                                  Icons.content_copy,
                                                  size: 18),
                                              label: Text(
                                                'کپی متن',
                                                style: GoogleFonts.vazirmatn(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                foregroundColor: primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Generate Button (Sticky)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withOpacity(0),
                    backgroundColor.withOpacity(0.9),
                    backgroundColor,
                  ],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _generatePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: primaryColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.4),
                  ),
                  child: _isGenerating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'در حال تولید...',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'تولید محتوا',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.auto_awesome, color: Colors.white),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(
    String value,
    String label,
    IconData icon,
    bool isDark,
    Color primaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    final isSelected = _selectedPlatform == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlatform = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToneChip(
    String value,
    String label,
    bool isDark,
    Color primaryColor,
    Color surfaceColor,
    Color borderColor,
  ) {
    final isSelected = _selectedTone == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTone = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.2) : surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? primaryColor : borderColor,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? primaryColor
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }
}
