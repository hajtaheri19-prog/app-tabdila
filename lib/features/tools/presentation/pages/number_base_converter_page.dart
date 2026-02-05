import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class BaseHistory {
  final String input;
  final String output;
  final int fromBase;
  final int toBase;

  BaseHistory({
    required this.input,
    required this.output,
    required this.fromBase,
    required this.toBase,
  });
}

class NumberBaseConverterPage extends StatefulWidget {
  const NumberBaseConverterPage({super.key});

  @override
  State<NumberBaseConverterPage> createState() =>
      _NumberBaseConverterPageState();
}

class _NumberBaseConverterPageState extends State<NumberBaseConverterPage> {
  final TextEditingController _inputController =
      TextEditingController(text: '125');
  int _fromBase = 10;
  int _toBase = 2;
  String _result = '1111101';
  final List<BaseHistory> _history = [
    BaseHistory(input: '255', output: 'FF', fromBase: 10, toBase: 16),
    BaseHistory(input: '12', output: '1100', fromBase: 10, toBase: 2),
  ];

  final Map<int, String> _baseNames = {
    2: 'دودویی (Binary)',
    8: 'هشتهشتی (Octal)',
    10: 'دهدهی (Decimal)',
    16: 'شانزده‌شانزدهی (Hex)',
  };

  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    try {
      final decimalValue = BigInt.parse(input, radix: _fromBase);
      final converted = decimalValue.toRadixString(_toBase).toUpperCase();

      setState(() {
        _result = converted;
        _history.insert(
          0,
          BaseHistory(
            input: input,
            output: converted,
            fromBase: _fromBase,
            toBase: _toBase,
          ),
        );
        if (_history.length > 10) _history.removeLast();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('فرمت عدد ورودی با مبنای انتخاب شده همخوانی ندارد')),
      );
    }
  }

  void _swapBases() {
    setState(() {
      final temp = _fromBase;
      _fromBase = _toBase;
      _toBase = temp;
      _convert();
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF1A1122);
    const surfaceDark = Color(0xFF261933);

    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'مبدل مبنای اعداد',
          style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBaseSelector('از مبنای', _fromBase, (val) {
                setState(() => _fromBase = val!);
              }, primaryColor, surfaceDark),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: _swapBases,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 15)
                      ],
                    ),
                    child: const Icon(Icons.swap_vert,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildBaseSelector('به مبنای', _toBase, (val) {
                setState(() => _toBase = val!);
              }, primaryColor, surfaceDark),
              const SizedBox(height: 24),
              _buildInputField(primaryColor, surfaceDark),
              const SizedBox(height: 24),
              _buildConvertButton(primaryColor),
              const SizedBox(height: 32),
              _buildResultCard(primaryColor, surfaceDark),
              const SizedBox(height: 32),
              _buildHistoryHeader(),
              const SizedBox(height: 12),
              _buildHistoryList(surfaceDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBaseSelector(String label, int value,
      ValueChanged<int?> onChanged, Color primary, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text(label,
              style:
                  GoogleFonts.vazirmatn(color: Colors.white70, fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.2)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: surface,
              icon: const Icon(Icons.expand_more, color: Colors.white38),
              onChanged: onChanged,
              items: _baseNames.entries.map((e) {
                return DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value,
                      style: GoogleFonts.vazirmatn(
                          color: Colors.white, fontSize: 14)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(Color primary, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text('مقدار ورودی',
              style:
                  GoogleFonts.vazirmatn(color: Colors.white70, fontSize: 14)),
        ),
        Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primary.withOpacity(0.2)),
          ),
          child: TextField(
            controller: _inputController,
            style: GoogleFonts.jetBrainsMono(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: '125',
              hintStyle: GoogleFonts.jetBrainsMono(color: Colors.white12),
              contentPadding: const EdgeInsets.all(20),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton(Color primary) {
    return ElevatedButton(
      onPressed: _convert,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        shadowColor: primary.withOpacity(0.5),
      ),
      child: Text(
        'تبدیل کن',
        style: GoogleFonts.vazirmatn(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildResultCard(Color primary, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 8),
          child: Text('نتیجه',
              style:
                  GoogleFonts.vazirmatn(color: Colors.white70, fontSize: 14)),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                  color: primary.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _result,
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFFD4BBFC),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Base $_toBase',
                style: GoogleFonts.jetBrainsMono(
                    color: Colors.white24, fontSize: 12),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildResultAction('کپی', Icons.content_copy, () {
                    Clipboard.setData(ClipboardData(text: _result));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('کپی شد')));
                  }),
                  const SizedBox(width: 12),
                  _buildResultAction('اشتراک', Icons.share, () {
                    Share.share('نتیجه تبدیل: $_result');
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultAction(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(label,
                style:
                    GoogleFonts.vazirmatn(color: Colors.white, fontSize: 12)),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('تبدیل‌های اخیر',
            style: GoogleFonts.vazirmatn(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        GestureDetector(
          onTap: () => setState(() => _history.clear()),
          child: Text('پاک کردن',
              style: GoogleFonts.vazirmatn(
                  color: const Color(0xFF7F13EC), fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildHistoryList(Color surface) {
    if (_history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text('تاریخچه‌ای وجود ندارد',
              style:
                  GoogleFonts.vazirmatn(color: Colors.white24, fontSize: 12)),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = _history[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Base ${item.fromBase}',
                          style: GoogleFonts.jetBrainsMono(
                              color: Colors.white38, fontSize: 10)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_back,
                          size: 10, color: Colors.white24),
                      const SizedBox(width: 4),
                      Text('Base ${item.toBase}',
                          style: GoogleFonts.jetBrainsMono(
                              color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: item.input,
                            style: GoogleFonts.jetBrainsMono(
                                color: Colors.white70, fontSize: 14)),
                        TextSpan(
                            text: ' → ',
                            style: GoogleFonts.jetBrainsMono(
                                color: Colors.white24, fontSize: 14)),
                        TextSpan(
                            text: item.output,
                            style: GoogleFonts.jetBrainsMono(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.history, color: Colors.white12, size: 20),
            ],
          ),
        );
      },
    );
  }
}
