import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/digit_utils.dart';

class NumberToWordsPage extends StatefulWidget {
  const NumberToWordsPage({super.key});

  @override
  State<NumberToWordsPage> createState() => _NumberToWordsPageState();
}

class _NumberToWordsPageState extends State<NumberToWordsPage> {
  String _input = '1250000000';
  String _mode = 'simple'; // 'simple', 'toman', 'rial'
  final NumberFormat _formatter = NumberFormat('#,###');

  final List<String> _ones = [
    '',
    'یک',
    'دو',
    'سه',
    'چهار',
    'پنج',
    'شش',
    'هفت',
    'هشت',
    'نه',
  ];
  final List<String> _tens = [
    '',
    'ده',
    'بیست',
    'سی',
    'چهل',
    'پنجاه',
    'شصت',
    'هفتاد',
    'هشتاد',
    'نود',
  ];
  final List<String> _teens = [
    'ده',
    'یازده',
    'دوازده',
    'سیزده',
    'چهارده',
    'پانزده',
    'شانزده',
    'هفده',
    'هجده',
    'نوزده',
  ];
  final List<String> _hundreds = [
    '',
    'صد',
    'دویست',
    'سیصد',
    'چهارصد',
    'پانصد',
    'ششصد',
    'هفتصد',
    'هشتصد',
    'نهصد',
  ];
  final List<String> _stages = ['', 'هزار', 'میلیون', 'میلیارد', 'تریلیون'];

  String _convert(String input) {
    if (input.isEmpty || input == '0') return 'صفر';
    int num = int.tryParse(input) ?? 0;
    if (num == 0) return 'صفر';

    List<String> parts = [];
    int stageIndex = 0;

    while (num > 0) {
      int chunk = num % 1000;
      if (chunk != 0) {
        String chunkStr = _convertChunk(chunk);
        String stage = _stages[stageIndex];
        parts.insert(
          0,
          '$chunkStr ${stage.isNotEmpty ? ' $stage' : ''}'.trim(),
        );
      }
      num ~/= 1000;
      stageIndex++;
    }

    String result = parts.join(' و ');

    if (_mode == 'toman') {
      result += ' تومان';
    } else if (_mode == 'rial') {
      result += ' ریال';
    }

    return result;
  }

  String _convertChunk(int n) {
    String res = '';
    int h = n ~/ 100;
    int t = (n % 100) ~/ 10;
    int o = n % 10;

    if (h > 0) res += _hundreds[h];

    if (t == 1) {
      if (res.isNotEmpty) res += ' و ';
      res += _teens[o];
    } else {
      if (t > 1) {
        if (res.isNotEmpty) res += ' و ';
        res += _tens[t];
      }
      if (o > 0) {
        if (res.isNotEmpty) res += ' و ';
        res += _ones[o];
      }
    }
    return res;
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'backspace') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (key == 'clear') {
        _input = '';
      } else {
        if (_input.length < 15) {
          // Limit for safety
          _input += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF2A1D36) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);

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
          'تبدیل عدد به حروف',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Mode Selector
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? surfaceColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        _buildModeItem('rial', 'ریال', isDark, primaryColor),
                        _buildModeItem('toman', 'تومان', isDark, primaryColor),
                        _buildModeItem('simple', 'ساده', isDark, primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Input Display
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ورود عدد',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _input.isEmpty
                            ? '۰'
                            : DigitUtils.toFarsi(
                                _formatter.format(int.tryParse(_input) ?? 0)),
                        style: GoogleFonts.manrope(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Icon(
                    Icons.arrow_circle_down,
                    color: Color(0xFF7F13EC),
                    size: 32,
                  ),
                  const SizedBox(height: 12),

                  // Result Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'به حروف',
                          style: GoogleFonts.vazirmatn(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _convert(_input),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.vazirmatn(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black87,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildActionButton(
                              Icons.share,
                              'اشتراک',
                              () {},
                              isDark,
                            ),
                            const SizedBox(width: 8),
                            _buildActionButton(
                              Icons.copy,
                              'کپی متن',
                              () {
                                Clipboard.setData(
                                  ClipboardData(text: _convert(_input)),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('کپی شد'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              isDark,
                              isPrimary: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Keypad
          _buildKeypad(isDark, surfaceColor, primaryColor),
        ],
      ),
    );
  }

  Widget _buildModeItem(
    String mode,
    String label,
    bool isDark,
    Color primaryColor,
  ) {
    bool isSelected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? primaryColor : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected && !isDark
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? (isDark ? Colors.white : Colors.black87)
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onTap,
    bool isDark, {
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.vazirmatn(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color(0xFF7F13EC)
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
        foregroundColor: isPrimary
            ? Colors.white
            : (isDark ? Colors.grey[300] : Colors.grey[700]),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  Widget _buildKeypad(bool isDark, Color surfaceColor, Color primaryColor) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1122) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          _buildKeyRow(['1', '2', '3']),
          const SizedBox(height: 12),
          _buildKeyRow(['4', '5', '6']),
          const SizedBox(height: 12),
          _buildKeyRow(['7', '8', '9']),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildKey(
                  'clear',
                  isText: true,
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildKey('0')),
              const SizedBox(width: 12),
              Expanded(child: _buildKey('backspace', isIcon: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      children: keys
          .map(
            (k) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildKey(k),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildKey(
    String key, {
    bool isIcon = false,
    bool isText = false,
    Color? primaryColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(key),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: isIcon
                ? const Icon(Icons.backspace_outlined, size: 24)
                : isText
                    ? Text(
                        'پاک کردن',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      )
                    : Text(
                        DigitUtils.toFarsi(key),
                        style: GoogleFonts.vazirmatn(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
