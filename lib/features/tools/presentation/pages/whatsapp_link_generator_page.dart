import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppLinkGeneratorPage extends StatefulWidget {
  const WhatsAppLinkGeneratorPage({super.key});

  @override
  State<WhatsAppLinkGeneratorPage> createState() =>
      _WhatsAppLinkGeneratorPageState();
}

class _WhatsAppLinkGeneratorPageState extends State<WhatsAppLinkGeneratorPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String? _generatedLink;
  bool _showResult = false;

  void _generateLink() {
    String phone =
        _phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
    String message = Uri.encodeComponent(_messageController.text.trim());

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفا شماره موبایل را وارد کنید')),
      );
      return;
    }

    setState(() {
      _generatedLink =
          "https://wa.me/$phone${message.isNotEmpty ? "?text=$message" : ""}";
      _showResult = true;
    });
  }

  void _copyLink() {
    if (_generatedLink != null) {
      Clipboard.setData(ClipboardData(text: _generatedLink!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لینک کپی شد')),
      );
    }
  }

  void _openWhatsApp() async {
    if (_generatedLink != null) {
      final url = Uri.parse(_generatedLink!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);
    final mutedText = isDark ? const Color(0xFFAD92C9) : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_forward,
              color: isDark ? Colors.white : Colors.black87),
        ),
        title: Text(
          'سازنده لینک واتساپ',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'با وارد کردن شماره موبایل و متن دلخواه، لینک مستقیم واتساپ و کیوآر کد بسازید.',
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: mutedText,
              ),
            ),
            const SizedBox(height: 32),

            // Phone Input
            _buildLabel('شماره موبایل', isDark),
            const SizedBox(height: 8),
            _buildInputField(
              controller: _phoneController,
              hint: '+98 912 345 6789',
              icon: Icons.smartphone,
              isDark: isDark,
              surfaceColor: surfaceColor,
              primaryColor: primaryColor,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            Text(
              'شماره را با کد کشور وارد کنید (مثلا 98+)',
              style: GoogleFonts.vazirmatn(fontSize: 11, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Message Input
            _buildLabel('متن پیام پیش‌فرض', isDark),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color:
                        isDark ? const Color(0xFF4D3267) : Colors.grey[300]!),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 5,
                style: GoogleFonts.vazirmatn(
                    color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: 'سلام، من در مورد آگهی شما سوالی داشتم...',
                  hintStyle: GoogleFonts.vazirmatn(
                      color: Colors.grey[500], fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _generateLink,
                icon: const Icon(Icons.qr_code_2),
                label: Text(
                  'تولید لینک و QR',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.4),
                ),
              ),
            ),

            if (_showResult) ...[
              const SizedBox(height: 32),
              _buildResultCard(isDark, primaryColor, surfaceColor),
            ],

            const SizedBox(height: 40),
            Center(
              child: Text(
                'قدرت گرفته از تبدیلا',
                style: GoogleFonts.vazirmatn(
                    fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        text,
        style: GoogleFonts.vazirmatn(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color surfaceColor,
    required Color primaryColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? const Color(0xFF4D3267) : Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.left,
        keyboardType: keyboardType,
        style: GoogleFonts.manrope(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          hintText: hint,
          hintStyle: GoogleFonts.manrope(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildResultCard(bool isDark, Color primaryColor, Color surfaceColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          Text(
            'لینک شما آماده شد!',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          SizedBox(height: 24),

          // QR Code
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: QrImageView(
              data: _generatedLink ?? '',
              version: QrVersions.auto,
              size: 160.0,
              gapless: false,
            ),
          ),

          SizedBox(height: 24),

          // Link Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _copyLink,
                  icon: Icon(Icons.content_copy, color: primaryColor, size: 20),
                ),
                Expanded(
                  child: Text(
                    _generatedLink ?? '',
                    style: GoogleFonts.manrope(
                        fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Row Actions
          Row(
            children: [
              Expanded(
                child: _buildResultAction(
                  label: 'باز کردن',
                  icon: Icons.open_in_new,
                  color: const Color(0xFF25D366),
                  onTap: _openWhatsApp,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildResultAction(
                  label: 'اشتراک‌گذاری',
                  icon: Icons.share,
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : const Color(0xFFEEEEEE),
                  textColor: isDark ? Colors.white : Colors.black87,
                  onTap: () => Share.share(_generatedLink ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultAction({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.vazirmatn(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
