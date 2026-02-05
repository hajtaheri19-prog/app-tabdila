import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

class FactorialHistory {
  final int number;
  final BigInt result;

  FactorialHistory({required this.number, required this.result});
}

class FactorialCalculatorPage extends StatefulWidget {
  const FactorialCalculatorPage({super.key});

  @override
  State<FactorialCalculatorPage> createState() =>
      _FactorialCalculatorPageState();
}

class _FactorialCalculatorPageState extends State<FactorialCalculatorPage> {
  final TextEditingController _controller = TextEditingController();
  BigInt? _result;
  String _steps = '';
  final List<FactorialHistory> _history = [
    FactorialHistory(number: 4, result: BigInt.from(24)),
    FactorialHistory(number: 10, result: BigInt.from(3628800)),
  ];

  void _calculate() {
    final input = _controller.text;
    if (input.isEmpty) return;

    final n = int.tryParse(DigitUtils.toEnglish(input));
    if (n == null || n < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً یک عدد صحیح مثبت وارد کنید')),
      );
      return;
    }

    if (n > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('عدد خیلی بزرگ است! حداکثر تا ۱۰۰۰ قابل قبول است')),
      );
      return;
    }

    BigInt fact = BigInt.one;
    List<String> stepList = [];
    for (int i = n; i >= 1; i--) {
      fact *= BigInt.from(i);
      if (n <= 10) {
        stepList.add(DigitUtils.toFarsi(i.toString()));
      }
    }

    setState(() {
      _result = fact;
      if (n == 0) {
        _steps = '۱';
        _result = BigInt.one;
      } else if (n > 10) {
        _steps =
            '${DigitUtils.toFarsi(n.toString())} × ${DigitUtils.toFarsi((n - 1).toString())} × ... × ۱';
      } else {
        _steps = stepList.join(' × ');
      }

      // Add to history
      if (!_history.any((h) => h.number == n)) {
        _history.insert(0, FactorialHistory(number: n, result: fact));
        if (_history.length > 5) _history.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Math Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: MathPatternPainter(primaryColor),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, backgroundDark, primaryColor),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildHeader(primaryColor),
                        const SizedBox(height: 32),
                        _buildInputSection(surfaceDark, primaryColor),
                        const SizedBox(height: 40),
                        _buildResultSection(surfaceDark, primaryColor),
                        const SizedBox(height: 32),
                        _buildHistorySection(surfaceDark, primaryColor),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildBottomNav(primaryColor, backgroundDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color background, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back_ios_new, color: primary, size: 20),
            ),
          ),
          Text(
            'محاسبه فاکتوریل',
            style: GoogleFonts.vazirmatn(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.info_outline, color: Colors.white60, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primary) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
            Text(
              '!n',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                color: primary,
                shadows: [
                  Shadow(color: primary.withOpacity(0.8), blurRadius: 20),
                  Shadow(color: primary.withOpacity(0.4), blurRadius: 40),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Text(
            'محاسبه‌گر فاکتوریل هوشمند تبدیلا',
            style: GoogleFonts.vazirmatn(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection(Color surface, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 8),
          child: Text(
            '(n) عدد ورودی',
            style: GoogleFonts.vazirmatn(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.vazirmatn(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: 'مثلاً ۵',
              hintStyle:
                  GoogleFonts.vazirmatn(color: Colors.white24, fontSize: 18),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              prefixIcon: Icon(Icons.functions,
                  color: primary.withOpacity(0.4), size: 30),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _calculate,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bolt, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'محاسبه فاکتوریل',
                        style: GoogleFonts.vazirmatn(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                _controller.clear();
                setState(() {
                  _result = null;
                  _steps = '';
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child:
                    const Icon(Icons.backspace_outlined, color: Colors.white60),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultSection(Color surface, Color primary) {
    if (_result == null) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'خروجی محاسبه',
                  style: GoogleFonts.vazirmatn(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _result.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('در حافظه کپی شد')),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.content_copy, size: 14, color: primary),
                    const SizedBox(width: 4),
                    Text(
                      'کپی نتیجه',
                      style: GoogleFonts.vazirmatn(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF21152D),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مراحل محاسبه',
                style: GoogleFonts.vazirmatn(
                  color: Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _steps,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white70,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              const Text(
                'نتیجه نهایی',
                style: TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text('=',
                      style: TextStyle(color: Colors.white24, fontSize: 24)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        DigitUtils.toFarsi(_result.toString()),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          shadows: [
                            Shadow(
                                color: primary.withOpacity(0.5),
                                blurRadius: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(Color surface, Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.history, color: Colors.white38, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'آخرین محاسبات',
                style: GoogleFonts.vazirmatn(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'مشاهده تاریخچه کامل',
                style: GoogleFonts.vazirmatn(
                  color: Colors.white24,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: _history.reversed.map((h) {
              return Container(
                margin: const EdgeInsets.only(left: 4),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white10, width: 2),
                ),
                child: Center(
                  child: Text(
                    '!${h.number}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color primary, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      decoration: BoxDecoration(
        color: background.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(Icons.calculate, 'محاسبه', true, primary),
          _buildNavItem(Icons.menu_book, 'آموزش', false, primary),
          _buildNavItem(Icons.settings, 'تنظیمات', false, primary),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, Color primary) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? primary : Colors.white24),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? primary : Colors.white24,
          ),
        ),
      ],
    );
  }
}

class MathPatternPainter extends CustomPainter {
  final Color color;
  MathPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 40) {
      for (double j = 0; j < size.height; j += 40) {
        canvas.drawCircle(Offset(i, j), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
