import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF211C27) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_forward_ios,
              color: isDark ? Colors.white : Colors.black87, size: 20),
        ),
        title: Text(
          'درباره و قوانین',
          style: GoogleFonts.vazirmatn(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // About Us Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF7F13EC), Color(0xFF4C1D95)],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Icon(Icons.sync_alt,
                              color: Colors.white, size: 60),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'درباره تبدیلا',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'تبدیلا، ابزاری هوشمند و مدرن برای تمامی نیازهای محاسباتی و تبدیل‌های روزمره شماست. ما با هدف ساده‌سازی فرآیندهای پیچیده، مجموعه‌ای از ابزارهای کاربردی را در یک محیط زیبا گردآوری کرده‌ایم.',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 15,
                              height: 1.6,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[700],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Rules Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'قوانین و مقررات',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.gavel, color: primaryColor, size: 24),
                ],
              ),
            ),

            // Rules Accordion
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _RuleItem(
                    title: 'شرایط استفاده از خدمات',
                    content:
                        'با استفاده از اپلیکیشن تبدیلا، شما موافقت خود را با تمامی بندهای ذکر شده اعلام می‌دارید. استفاده از این سرویس تنها برای مقاصد قانونی مجاز است. هرگونه استفاده غیرمجاز یا تلاش برای مهندسی معکوس ممنوع می‌باشد.',
                    isDark: isDark,
                    initiallyExpanded: true,
                  ),
                  const SizedBox(height: 12),
                  _RuleItem(
                    title: 'حریم خصوصی کاربران',
                    content:
                        'ما به حریم خصوصی شما احترام می‌گذاریم. تبدیلا اطلاعات حساس شخصی شما را ذخیره نمی‌کند. داده‌های مربوط به تبدیل‌های شما به صورت محلی در دستگاه شما پردازش می‌شوند تا امنیت حداکثری تضمین گردد.',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _RuleItem(
                    title: 'اشتراک و پرداخت‌ها',
                    content:
                        'برخی از قابلیت‌های پیشرفته ممکن است نیاز به اشتراک ویژه داشته باشند. تمامی تراکنش‌ها از طریق درگاه‌های امن بانکی انجام شده و بلافاصله پس از پرداخت فعال می‌گردند.',
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Social Media
            Text(
              'ارتباط با ما',
              style: GoogleFonts.vazirmatn(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialItem(
                    icon: Icons.language, label: 'وبسایت', color: primaryColor),
                const SizedBox(width: 32),
                _SocialItem(
                    icon: Icons.camera_alt,
                    label: 'اینستاگرام',
                    color: primaryColor),
                const SizedBox(width: 32),
                _SocialItem(
                    icon: Icons.send, label: 'تلگرام', color: primaryColor),
              ],
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/feedback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  foregroundColor: primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.feedback_outlined),
                    const SizedBox(width: 12),
                    Text(
                      'ثبت نظرات و پیشنهادات',
                      style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // Version Footer
            const SizedBox(height: 48),
            Opacity(
              opacity: 0.4,
              child: Text(
                'نسخه ۲.۴.۰ - تولید شده با عشق',
                style: GoogleFonts.vazirmatn(
                    fontSize: 12, color: isDark ? Colors.white : Colors.black),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _RuleItem extends StatefulWidget {
  final String title;
  final String content;
  final bool isDark;
  final bool initiallyExpanded;

  const _RuleItem({
    required this.title,
    required this.content,
    required this.isDark,
    this.initiallyExpanded = false,
  });

  @override
  State<_RuleItem> createState() => _RuleItemState();
}

class _RuleItemState extends State<_RuleItem> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF191022) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: widget.isDark ? const Color(0xFF473B54) : Colors.grey[200]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        title: Text(
          widget.title,
          textAlign: TextAlign.right,
          style: GoogleFonts.vazirmatn(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: widget.isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: Icon(
          _isExpanded ? Icons.expand_less : Icons.expand_more,
          color: Colors.grey,
        ),
        onExpansionChanged: (expanded) =>
            setState(() => _isExpanded = expanded),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Divider(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[100]),
                const SizedBox(height: 8),
                Text(
                  widget.content,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 13,
                    height: 1.6,
                    color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
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

class _SocialItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SocialItem(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
