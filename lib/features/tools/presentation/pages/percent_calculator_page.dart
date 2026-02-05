import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

class PercentCalculatorPage extends StatefulWidget {
  const PercentCalculatorPage({super.key});

  @override
  State<PercentCalculatorPage> createState() => _PercentCalculatorPageState();
}

class _PercentCalculatorPageState extends State<PercentCalculatorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _val1Controller = TextEditingController();
  final TextEditingController _val2Controller = TextEditingController();
  String _result = '';
  String _resultDetail = '';
  List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _result = '';
        _resultDetail = '';
        _val1Controller.clear();
        _val2Controller.clear();
      });
    });
  }

  void _calculate() {
    if (_val1Controller.text.isEmpty || _val2Controller.text.isEmpty) return;

    double v1 = DigitUtils.parseDouble(_val1Controller.text);
    double v2 = DigitUtils.parseDouble(_val2Controller.text);

    setState(() {
      switch (_tabController.index) {
        case 0: // X percent of Y
          double res = (v1 * v2) / 100;
          _result =
              DigitUtils.toFarsi(res.toStringAsFixed(res % 1 == 0 ? 0 : 2));
          _resultDetail = DigitUtils.toFarsi(
              '${v1.toStringAsFixed(0)} درصد از ${v2.toStringAsFixed(0)} برابر است با $_result');
          _addHistory(
              '${v1.toStringAsFixed(0)}% از ${v2.toStringAsFixed(0)}', _result);
          break;
        case 1: // X is what percent of Y
          double res = (v1 / v2) * 100;
          _result =
              DigitUtils.toFarsi(res.toStringAsFixed(res % 1 == 0 ? 0 : 2));
          _resultDetail = DigitUtils.toFarsi(
              '${v1.toStringAsFixed(0)} چه درصدی از ${v2.toStringAsFixed(0)} است؟ $_result درصد');
          _addHistory('$v1 از $v2', '$_result٪');
          break;
        case 2: // Increase/Decrease Y by X percent
          double res = v2 + (v2 * v1 / 100);
          _result =
              DigitUtils.toFarsi(res.toStringAsFixed(res % 1 == 0 ? 0 : 2));
          _resultDetail = DigitUtils.toFarsi(
              '${v2.toStringAsFixed(0)} با ${v1.toStringAsFixed(0)} درصد افزایش برابر است با $_result');
          _addHistory(
              '${v2.toStringAsFixed(0)} + ${v1.toStringAsFixed(0)}%', _result);
          break;
      }
    });
  }

  void _addHistory(String query, String result) {
    _history.insert(0, {'query': DigitUtils.toFarsi(query), 'result': result});
    if (_history.length > 5) _history.removeLast();
  }

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
        title: Text('محاسبه درصد',
            style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: isDark ? const Color(0xFFAD92C9) : Colors.grey,
          labelStyle:
              GoogleFonts.vazirmatn(fontWeight: FontWeight.bold, fontSize: 13),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: const [
            Tab(text: 'X درصد از Y'),
            Tab(text: 'چند درصد؟'),
            Tab(text: 'افزایش/کاهش'),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTitleSection(),
              const SizedBox(height: 24),
              _buildInputCard(isDark, primary),
              const SizedBox(height: 24),
              if (_result.isNotEmpty) _buildResultCard(isDark, primary),
              const SizedBox(height: 24),
              _buildHistorySection(isDark, primary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    String title = '';
    switch (_tabController.index) {
      case 0:
        title = 'X درصد از Y چقدر می‌شود؟';
        break;
      case 1:
        title = 'X چه درصدی از Y است؟';
        break;
      case 2:
        title = 'تغییر Y به میزان X درصد';
        break;
    }
    return Column(
      children: [
        Text(title,
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87)),
        const SizedBox(height: 8),
        Text('برای مشاهده نتیجه مقادیر زیر را پر کنید',
            style: GoogleFonts.vazirmatn(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInputCard(bool isDark, Color primary) {
    String label1 = '';
    String label2 = '';
    String hint1 = '';
    String hint2 = '';
    IconData icon1 = Icons.calculate;
    IconData icon2 = Icons.percent;

    switch (_tabController.index) {
      case 0:
        label1 = 'درصد (X)';
        hint1 = 'مثلا ۲۰';
        label2 = 'مقدار کل (Y)';
        hint2 = 'مثلا ۱۰۰';
        break;
      case 1:
        label1 = 'مقدار اول (X)';
        hint1 = 'مثلا ۲۰';
        label2 = 'مقدار دوم (Y)';
        hint2 = 'مثلا ۱۰۰';
        break;
      case 2:
        label1 = 'درصد تغییر (X)';
        hint1 = 'مثلا ۱۵';
        label2 = 'مقدار اصلی (Y)';
        hint2 = 'مثلا ۱۲۰';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF261933) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark
                ? const Color(0xFF4D3267).withOpacity(0.3)
                : Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildTextField(
              label1, hint1, _val1Controller, icon1, isDark, primary),
          const SizedBox(height: 20),
          _buildTextField(
              label2, hint2, _val2Controller, icon2, isDark, primary),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              shadowColor: primary.withOpacity(0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.functions),
                const SizedBox(width: 8),
                Text('محاسبه کن',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller,
      IconData icon,
      bool isDark,
      Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[700])),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          style:
              GoogleFonts.vazirmatn(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.vazirmatn(
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                fontWeight: FontWeight.normal),
            prefixIcon: Icon(icon, color: primary.withOpacity(0.7)),
            filled: true,
            fillColor:
                isDark ? const Color(0xFF1F1429) : const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: primary, width: 2)),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(bool isDark, Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2D1B3E), const Color(0xFF1A0F26)]
              : [const Color(0xFF1E293B), Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4D3267).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('نتیجه محاسبه',
              style: GoogleFonts.vazirmatn(
                  fontSize: 14, color: const Color(0xFFAD92C9))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(_result,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: primary.withOpacity(0.5), blurRadius: 10)
                      ])),
              if (_tabController.index == 1) ...[
                const SizedBox(width: 4),
                Text('٪',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary)),
              ],
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          Text(_resultDetail,
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildHistorySection(bool isDark, Color primary) {
    if (_history.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('محاسبات اخیر',
            style: GoogleFonts.vazirmatn(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87)),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return Container(
                width: 130,
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF261933) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isDark
                          ? const Color(0xFF4D3267).withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_history[index]['query']!,
                        style: GoogleFonts.vazirmatn(
                            fontSize: 10, color: const Color(0xFFAD92C9))),
                    const SizedBox(height: 4),
                    Text(_history[index]['result']!,
                        style: GoogleFonts.vazirmatn(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
