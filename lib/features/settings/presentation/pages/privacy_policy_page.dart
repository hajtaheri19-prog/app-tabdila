import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final primaryColor = const Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isDark),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Headline
                    Text(
                      'تعهد ما به حریم خصوصی شما',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 48,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Introduction
                    Text(
                      'اپلیکیشن «تبدیلا» با احترام به حقوق کاربران، متعهد می‌شود که از اطلاعات شخصی شما به بهترین شکل ممکن محافظت کند. این سند توضیح می‌دهد که چه اطلاعاتی جمع‌آوری می‌شود و چگونه از آن‌ها استفاده می‌کنیم. امنیت داده‌های شما اولویت اصلی ماست.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Section: Data Collection
                    _buildSectionHeader(Icons.analytics,
                        'جمع‌آوری و استفاده از اطلاعات', primaryColor, isDark),
                    const SizedBox(height: 12),
                    Text(
                      'ما فقط اطلاعاتی را جمع‌آوری می‌کنیم که برای بهبود تجربه کاربری و فرآیند تبدیل فایل‌ها ضروری هستند. این اطلاعات شامل مدل دستگاه و نوع سیستم‌عامل برای بهینه‌سازی عملکرد اپلیکیشن است. فایل‌های آپلود شده جهت تبدیل، پس از اتمام فرآیند بلافاصله از سرورهای موقت ما حذف می‌شوند.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Section: Security
                    _buildSectionHeader(Icons.security, 'امنیت و اشتراک‌گذاری',
                        primaryColor, isDark),
                    const SizedBox(height: 12),
                    Text(
                      'تبدیلا هرگز اطلاعات خصوصی شما را به اشخاص ثالث نمی‌فروشد و اجاره نمی‌دهد. تمامی ارتباطات بین دستگاه شما و سرورهای ما با استفاده از پروتکل‌های رمزنگاری شده (SSL) محافظت می‌شوند تا امنیت داده‌های شما در حین انتقال تضمین شود.',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        height: 1.6,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Contact Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سوالی دارید؟',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اگر در مورد سیاست‌های ما سوالی دارید، تیم پشتیبانی ما آماده پاسخگویی به شماست.',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 14,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {}, // TODO: Implement mailto
                              icon: const Icon(Icons.mail, size: 20),
                              label: Text(
                                'تماس با پشتیبانی',
                                style: GoogleFonts.vazirmatn(
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'نسخه ۲.۴.۰',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:
                                  isDark ? Colors.grey[600] : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'آخرین بروزرسانی: ۱۴ مهر ۱۴۰۳',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 12,
                              color:
                                  isDark ? Colors.grey[600] : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
            color: isDark ? Colors.white : Colors.black87,
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.only(right: 48), // Compensate for arrow_forward
                child: Text(
                  'سیاست حریم خصوصی',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      IconData icon, String title, Color primaryColor, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
