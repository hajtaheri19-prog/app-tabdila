import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _themeMode = 'تاریک';
  String _language = 'فارسی';
  bool _dailyQuotes = true;
  bool _marketAlerts = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('تنظیمات برنامه',
            style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildSectionTitle('ظاهر برنامه'),
            _buildThemeSelector(isDark, primary),
            _buildSectionTitle('زبان'),
            _buildLanguageSelector(isDark, primary),
            _buildSectionTitle('اعلان‌ها'),
            _buildNotificationSettings(isDark, primary),
            _buildSectionTitle('پشتیبانی و درباره'),
            _buildSupportSettings(isDark, primary),
            const SizedBox(height: 48),
            _buildAppInfo(isDark, primary),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Text(title,
          style: GoogleFonts.vazirmatn(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildThemeSelector(bool isDark, Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildThemeOption('روشن', Icons.light_mode, isDark, primary),
          const SizedBox(height: 12),
          _buildThemeOption('تاریک', Icons.dark_mode, isDark, primary),
          const SizedBox(height: 12),
          _buildThemeOption(
              'هماهنگ با سیستم', Icons.settings_brightness, isDark, primary),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
      String title, IconData icon, bool isDark, Color primary) {
    bool isSelected = _themeMode == title;
    return GestureDetector(
      onTap: () => setState(() => _themeMode = title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primary : Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primary : Colors.grey),
            const SizedBox(width: 12),
            Text(title, style: GoogleFonts.vazirmatn(fontSize: 14)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: primary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(bool isDark, Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildLanguageOption('فارسی', isDark, primary),
          const SizedBox(width: 12),
          _buildLanguageOption('English', isDark, primary),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String lang, bool isDark, Color primary) {
    bool isSelected = _language == lang;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _language = lang),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? primary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: isSelected ? primary : Colors.transparent),
          ),
          child: Center(
              child: Text(lang,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14, color: isSelected ? primary : null))),
        ),
      ),
    );
  }

  Widget _buildNotificationSettings(bool isDark, Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildToggleRow(
              'جملات روزانه',
              'نقل‌قول‌های انگیزشی',
              Icons.format_quote,
              Colors.amber,
              _dailyQuotes,
              (v) => setState(() => _dailyQuotes = v),
              primary),
          const Divider(height: 1, indent: 64, color: Colors.white10),
          _buildToggleRow(
              'هشدارهای بازار',
              'تغییرات نرخ طلا و ارز',
              Icons.trending_up,
              Colors.green,
              _marketAlerts,
              (v) => setState(() => _marketAlerts = v),
              primary),
        ],
      ),
    );
  }

  Widget _buildSupportSettings(bool isDark, Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildNormalRow(
              'درباره و قوانین',
              'اطلاعات برنامه',
              Icons.info_outline,
              Colors.blue,
              () => Navigator.pushNamed(context, '/about')),
          const Divider(height: 1, indent: 64, color: Colors.white10),
          _buildNormalRow(
              'نظرات و پیشنهادات',
              'ارسال بازخورد',
              Icons.feedback_outlined,
              Colors.orange,
              () => Navigator.pushNamed(context, '/feedback')),
          const Divider(height: 1, indent: 64, color: Colors.white10),
          _buildNormalRow(
              'حمایت از برنامه',
              'حمایت معنوی و دونیت',
              Icons.favorite_outline,
              Colors.redAccent,
              () => Navigator.pushNamed(context, '/support')),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
      String title,
      String subtitle,
      IconData icon,
      Color iconColor,
      bool value,
      ValueChanged<bool> onChanged,
      Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 20)),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: GoogleFonts.vazirmatn(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text(subtitle,
                    style:
                        GoogleFonts.vazirmatn(fontSize: 11, color: Colors.grey))
              ])),
          CupertinoSwitch(
              value: value, activeColor: primary, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildNormalRow(String title, String subtitle, IconData icon,
      Color iconColor, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor, size: 20)),
      title: Text(title,
          style:
              GoogleFonts.vazirmatn(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle,
          style: GoogleFonts.vazirmatn(fontSize: 11, color: Colors.grey)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  Widget _buildAppInfo(bool isDark, Color primary) {
    return Column(
      children: [
        Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5)
                ]),
            child: const Center(
                child: Text('T',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))),
        const SizedBox(height: 12),
        Text('اپلیکیشن تبدیلا',
            style: GoogleFonts.vazirmatn(
                fontSize: 14, fontWeight: FontWeight.bold)),
        Text('نسخه ۱.۰',
            style: GoogleFonts.vazirmatn(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
