import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

class DigitConverterPage extends StatefulWidget {
  const DigitConverterPage({super.key});

  @override
  State<DigitConverterPage> createState() => _DigitConverterPageState();
}

class _DigitConverterPageState extends State<DigitConverterPage> {
  // We use string to keep track of input to handle large numbers easily and leading zeros if needed
  String _rawValue = "1250000";
  bool _isTomanToRial = true; // true: input is Toman, false: input is Rial

  // Toman = Rial / 10
  // Rial = Toman * 10

  String get _tomanValue {
    if (_rawValue.isEmpty) return "0";
    if (_isTomanToRial) {
      return _rawValue;
    } else {
      // Rial input, convert to Toman (divide by 10)
      if (_rawValue.length <= 1) return "0";
      return _rawValue.substring(0, _rawValue.length - 1);
    }
  }

  String get _rialValue {
    if (_rawValue.isEmpty) return "0";
    if (!_isTomanToRial) {
      return _rawValue;
    } else {
      // Toman input, convert to Rial (multiply by 10)
      return "${_rawValue}0";
    }
  }

  void _onKeypadTap(String value) {
    setState(() {
      if (value == 'backspace') {
        if (_rawValue.isNotEmpty) {
          _rawValue = _rawValue.substring(0, _rawValue.length - 1);
        }
      } else if (value == '000') {
        if (_rawValue.isNotEmpty && _rawValue != '0') {
          if ((_rawValue + "000").length < 15) {
            // Cap length
            _rawValue += "000";
          }
        }
      } else {
        if (_rawValue == '0') {
          _rawValue = value;
        } else {
          if ((_rawValue + value).length < 15) {
            _rawValue += value;
          }
        }
      }
      if (_rawValue.isEmpty) _rawValue = "0";
    });
  }

  void _toggleDirection() {
    setState(() {
      _isTomanToRial = !_isTomanToRial;
      // When swapping, we usually want to keep the value of the NEW input field logically consistent
      // If we seek to swap source/target but keep the 'value', we might shift digits.
      // But typically "Swap" in currency converter means swapping the MODE.
      // The design shows Toman up, Rial down.
      // The user request title implies "Rial <-> Toman" converter.
      // Let's assume swap just changes who is the "active" input.
      // E.g. Toman Card becomes non-active?
      // Actually, standard converters often just swap the positions.
      // But here the cards are fixed in layout (Top/Bottom).
      // Let's just swap the "Active Input" highlight and logic.
    });
  }

  String _formatNumber(String s) {
    if (s.isEmpty) return "";
    try {
      final n = int.parse(s);
      // Manual formatting or regex
      final formatted = s.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return DigitUtils.toFarsi(formatted);
    } catch (e) {
      return s;
    }
  }

  String _numberToWordsPersian(String numberStr) {
    if (numberStr.isEmpty || numberStr == '0') return "صفر";
    // This is a placeholder. Implementing full Persian letters requires a library or a big function.
    // I will put a small map for tens/hundreds or use a simplistic approach or
    // simply describe it's limitations or use the `number_to_words` logic if I can.
    // Since I can't import `persian_tools` effectively if it's not in pubspec (I assume it's not),
    // I will implement a basic converter function below.

    try {
      return _convertNumberToWords(BigInt.parse(numberStr));
    } catch (e) {
      return "";
    }
  }

  // Basic Number to Words (Simplified Implementation)
  final _ones = ['', 'یک', 'دو', 'سه', 'چهار', 'پنج', 'شش', 'هفت', 'هشت', 'نه'];
  final _tens = [
    '',
    'ده',
    'بیست',
    'سی',
    'چهل',
    'پنجاه',
    'شصت',
    'هفتاد',
    'هشتاد',
    'نود'
  ];
  final _teens = [
    'ده',
    'یازده',
    'دوازده',
    'سیزده',
    'چهارده',
    'پانزده',
    'شانزده',
    'هفده',
    'هجده',
    'نوزده'
  ];
  final _hundreds = [
    '',
    'صد',
    'دویست',
    'سیصد',
    'چهارصد',
    'پانصد',
    'ششصد',
    'هفتصد',
    'هشتصد',
    'نهصد'
  ];
  final _thousands = ['', 'هزار', 'میلیون', 'میلیارد', 'تریلیون'];

  String _convertNumberToWords(BigInt number) {
    if (number == BigInt.zero) return "صفر";

    String numStr = number.toString();
    List<String> chunks = [];

    while (numStr.length > 0) {
      int end = numStr.length;
      int start = end - 3 > 0 ? end - 3 : 0;
      chunks.add(numStr.substring(start, end));
      numStr = numStr.substring(0, start);
    }

    List<String> words = [];
    for (int i = 0; i < chunks.length; i++) {
      int n = int.tryParse(chunks[i]) ?? 0;
      if (n != 0) {
        String w = _convertThreeDigits(n);
        if (i > 0) {
          w += ' ' + _thousands[i];
        }
        words.add(w);
      }
    }

    return words.reversed.join(' و ');
  }

  String _convertThreeDigits(int n) {
    int h = n ~/ 100;
    int t = (n % 100) ~/ 10;
    int o = n % 10;

    List<String> parts = [];

    if (h > 0) parts.add(_hundreds[h]);

    if (t == 1) {
      parts.add(_teens[o]);
    } else {
      if (t > 0) parts.add(_tens[t]);
      if (o > 0) parts.add(_ones[o]);
    }

    return parts.join(' و ');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = const Color(0xFF7F13EC); // From your config
    final background =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);

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
                    style: IconButton.styleFrom(
                      backgroundColor: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.white,
                      shape: const CircleBorder(),
                    ),
                  ),
                  Text(
                    'تبدیل ریال ↔ تومان',
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

            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Primary Card (Toman)
                    _buildCurrencyCard(
                        title: 'تومان',
                        subtitle: 'TOMAN',
                        icon: Icons.payments,
                        value: _tomanValue,
                        isActive: _isTomanToRial,
                        isDark: isDark,
                        primary: primary,
                        onTap: () {
                          if (!_isTomanToRial)
                            setState(() => _isTomanToRial = true);
                        }),

                    // Swap Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0), // Adjusted margin
                      child: Transform.translate(
                        offset: const Offset(0, 0),
                        child: GestureDetector(
                          onTap: _toggleDirection,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: primary.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 2),
                              ],
                              border: Border.all(color: background, width: 4),
                            ),
                            child: const Icon(Icons.swap_vert,
                                color: Colors.white, size: 28),
                          ),
                        ),
                      ),
                    ),

                    // Secondary Card (Rial)
                    _buildCurrencyCard(
                        title: 'ریال',
                        subtitle: 'RIAL',
                        icon: Icons.account_balance_wallet,
                        value: _rialValue,
                        isActive: !_isTomanToRial,
                        isDark: isDark,
                        primary: primary,
                        onTap: () {
                          if (_isTomanToRial)
                            setState(() => _isTomanToRial = false);
                        }),

                    const Spacer(),

                    // Keypad
                    _buildKeypad(isDark, primary),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required bool isActive,
    required bool isDark,
    required Color primary,
    required VoidCallback onTap,
  }) {
    final borderColor = isActive
        ? primary
        : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!);
    final bgColor = isActive
        ? (isDark ? const Color(0xFF261933) : Colors.white)
        : (isDark ? const Color(0xFF1F1429) : Colors.grey[50]!);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: isActive ? 2 : 1),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: primary.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8)),
                ]
              : [],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.vazirmatn(
                    fontWeight: FontWeight.bold,
                    color: isActive
                        ? primary
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    letterSpacing: 1.5,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Icon(icon,
                    color: isActive ? primary : Colors.grey[400], size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatNumber(value),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                height: 1,
                color:
                    isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
            const SizedBox(height: 8),
            Text(
              value == "0" ? 'صفر' : '${_numberToWordsPersian(value)} $title',
              style: GoogleFonts.vazirmatn(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(bool isDark, Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _buildKey('1', isDark),
              _buildKey('2', isDark),
              _buildKey('3', isDark),
            ],
          ),
          Row(
            children: [
              _buildKey('4', isDark),
              _buildKey('5', isDark),
              _buildKey('6', isDark),
            ],
          ),
          Row(
            children: [
              _buildKey('7', isDark),
              _buildKey('8', isDark),
              _buildKey('9', isDark),
            ],
          ),
          Row(
            children: [
              _buildKey('000', isDark, fontSize: 18),
              _buildKey('0', isDark),
              _buildKey('backspace', isDark,
                  isIcon: true, icon: Icons.backspace_outlined, color: primary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String value, bool isDark,
      {bool isIcon = false,
      IconData? icon,
      double fontSize = 24,
      Color? color}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          _onKeypadTap(value);
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: isIcon
                ? Icon(icon,
                    color: color ?? (isDark ? Colors.white : Colors.black87),
                    size: 24)
                : Text(
                    DigitUtils.toFarsi(value),
                    style: GoogleFonts.vazirmatn(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: color ?? (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
