import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomNumberPage extends StatefulWidget {
  const RandomNumberPage({super.key});

  @override
  State<RandomNumberPage> createState() => _RandomNumberPageState();
}

class _RandomNumberPageState extends State<RandomNumberPage> {
  int _quantity = 1;
  bool _unique = true;
  List<int> _results = [42];

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

/* ... */

  void _generateRandomNumbers() {
    final random = Random();
    Set<int> generated = {};
    List<int> newResults = [];

    int currentMin = int.tryParse(_minController.text) ?? 1;
    int currentMax = int.tryParse(_maxController.text) ?? 100;

    if (currentMin >= currentMax) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حداقل باید از حداکثر کمتر باشد')),
      );
      return;
    }

    int range = currentMax - currentMin + 1;
    if (_unique && _quantity > range) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('بازه اعداد برای تعداد درخواستی کافی نیست'),
        ),
      );
      return;
    }

    while (newResults.length < _quantity) {
      int num = currentMin + random.nextInt(range);
      if (_unique) {
        if (generated.add(num)) {
          newResults.add(num);
        }
      } else {
        newResults.add(num);
      }
    }

    setState(() {
      _results = newResults;
    });
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);
    final textSecondary = isDark ? const Color(0xFFAD92C9) : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        title: Text(
          'تولید عدد تصادفی',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Result Card
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'نتیجه تصادفی',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _results.join('  '),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                            shadows: [
                              Shadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'برای تولید اعداد، دکمه را فشار دهید',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 12,
                          color: textSecondary!.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Min/Max Inputs
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        label: 'حداکثر',
                        controller: _maxController,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        label: 'حداقل',
                        controller: _minController,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quantity Slider
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _quantity.toString(),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            'تعداد',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _quantity.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _quantity = val.toInt()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '10',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                          Text(
                            '1',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Unique Toggle
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch(
                        value: _unique,
                        activeThumbColor: primaryColor,
                        onChanged: (val) => setState(() => _unique = val),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'اعداد منحصر به فرد باشند',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              'جلوگیری از تولید اعداد تکراری',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),

          // Generate Button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7F13EC), Color(0xFF9D4EDD)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _generateRandomNumbers,
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'تولید عدد جدید',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required bool isDark,
    required Color surfaceColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: label == 'حداقل' ? '1' : '100',
            hintStyle: TextStyle(
              color: isDark ? Colors.white24 : Colors.black12,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF362348) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF7F13EC)),
            ),
          ),
        ),
      ],
    );
  }
}
