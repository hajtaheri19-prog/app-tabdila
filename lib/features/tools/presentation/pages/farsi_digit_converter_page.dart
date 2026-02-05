import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

class FarsiDigitConverterPage extends StatefulWidget {
  const FarsiDigitConverterPage({super.key});

  @override
  State<FarsiDigitConverterPage> createState() =>
      _FarsiDigitConverterPageState();
}

class _FarsiDigitConverterPageState extends State<FarsiDigitConverterPage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  bool _isEnglishToFarsi = true;

  void _convert() {
    String input = _inputController.text;
    String output = "";

    if (_isEnglishToFarsi) {
      output = DigitUtils.toFarsi(input);
    } else {
      output = DigitUtils.toEnglish(input);
    }

    setState(() {
      _outputController.text = output;
    });
  }

  void _swap() {
    setState(() {
      _isEnglishToFarsi = !_isEnglishToFarsi;
      _inputController.text = _outputController.text;
      _convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primary = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F0816) : const Color(0xFFF7F6F8),
      appBar: AppBar(
        title: Text('ارقام فارسی',
            style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInputCard(
              title: _isEnglishToFarsi ? 'ارقام انگلیسی' : 'ارقام فارسی',
              controller: _inputController,
              isDark: isDark,
              onChanged: (_) => _convert(),
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: _swap,
              icon: const Icon(Icons.swap_vert, size: 32, color: primary),
              style: IconButton.styleFrom(
                backgroundColor: primary.withOpacity(0.1),
                padding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            _buildOutputCard(
              title: _isEnglishToFarsi ? 'ارقام فارسی' : 'ارقام انگلیسی',
              controller: _outputController,
              isDark: isDark,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _outputController.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('کپی شد!'),
                      behavior: SnackBarBehavior.floating),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.black26, // Added shadowColor
                elevation: 4, // Added elevation
              ),
              child: Text('کپی نتیجه',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required bool isDark,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1225) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.vazirmatn(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 5,
            onChanged: onChanged,
            style: GoogleFonts.vazirmatn(
                fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'متن را اینجا وارد کنید...',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputCard({
    required String title,
    required TextEditingController controller,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1225).withOpacity(0.5)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.vazirmatn(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 5,
            readOnly: true,
            style: GoogleFonts.vazirmatn(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF7F13EC)),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
