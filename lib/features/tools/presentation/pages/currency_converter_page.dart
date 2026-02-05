import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../../core/providers/app_provider.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class CurrencyInfo {
  final String code;
  final String name;
  final String flag;
  double rateToUsd; // Changed to mutable double

  CurrencyInfo({
    required this.code,
    required this.name,
    required this.flag,
    required this.rateToUsd,
  });
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  late CurrencyInfo _fromCurrency;
  late CurrencyInfo _toCurrency;
  bool _ratesUpdated = false;

  final List<CurrencyInfo> _currencies = [
    CurrencyInfo(
        code: 'USD',
        name: 'دلار آمریکا',
        flag: 'https://flagcdn.com/w80/us.png',
        rateToUsd: 1.0),
    CurrencyInfo(
        code: 'IRT',
        name: 'تومان ایران',
        flag: 'https://flagcdn.com/w80/ir.png',
        rateToUsd: 61500.0), // Default fallback
    // ... other currencies
    CurrencyInfo(
        code: 'EUR',
        name: 'یورو',
        flag: 'https://flagcdn.com/w80/eu.png',
        rateToUsd: 0.92),
    CurrencyInfo(
        code: 'GBP',
        name: 'پوند انگلیس',
        flag: 'https://flagcdn.com/w80/gb.png',
        rateToUsd: 0.79),
    CurrencyInfo(
        code: 'AED',
        name: 'درهم امارات',
        flag: 'https://flagcdn.com/w80/ae.png',
        rateToUsd: 3.67),
    CurrencyInfo(
        code: 'TRY',
        name: 'لیر ترکیه',
        flag: 'https://flagcdn.com/w80/tr.png',
        rateToUsd: 32.5),
    CurrencyInfo(
        code: 'CNY',
        name: 'یوآن چین',
        flag: 'https://flagcdn.com/w80/cn.png',
        rateToUsd: 7.23),
    CurrencyInfo(
        code: 'CAD',
        name: 'دلار کانادا',
        flag: 'https://flagcdn.com/w80/ca.png',
        rateToUsd: 1.36),
    CurrencyInfo(
        code: 'AUD',
        name: 'دلار استرالیا',
        flag: 'https://flagcdn.com/w80/au.png',
        rateToUsd: 1.52),
    CurrencyInfo(
        code: 'JPY',
        name: 'ین ژاپن',
        flag: 'https://flagcdn.com/w80/jp.png',
        rateToUsd: 154.0),
    CurrencyInfo(
        code: 'SAR',
        name: 'ریال عربستان',
        flag: 'https://flagcdn.com/w80/sa.png',
        rateToUsd: 3.75),
    CurrencyInfo(
        code: 'KWD',
        name: 'دینار کویت',
        flag: 'https://flagcdn.com/w80/kw.png',
        rateToUsd: 0.31),
    CurrencyInfo(
        code: 'IQD',
        name: 'دینار عراق',
        flag: 'https://flagcdn.com/w80/iq.png',
        rateToUsd: 1310.0),
    CurrencyInfo(
        code: 'RUB',
        name: 'روبل روسیه',
        flag: 'https://flagcdn.com/w80/ru.png',
        rateToUsd: 93.0),
    CurrencyInfo(
        code: 'AFN',
        name: 'افغانی افعانستان',
        flag: 'https://flagcdn.com/w80/af.png',
        rateToUsd: 71.0),
  ];

  @override
  void initState() {
    super.initState();
    _fromCurrency = _currencies[0]; // USD
    _toCurrency = _currencies[1]; // IRT

    // Trigger price refresh when entering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().refreshPrices();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_ratesUpdated) {
      _updateRatesFromProvider();
    }
  }

  void _updateRatesFromProvider() {
    final provider = context.read<AppProvider>();
    final prices = provider.prices;
    if (prices.isNotEmpty) {
      // Find USD price in Rials
      final usdPrice = prices.firstWhere((p) => p.symbol == 'USD',
          orElse: () => prices.first // Fallback
          );

      if (usdPrice.symbol == 'USD') {
        // Price is in Rials, convert to Toman
        double tomanRate = usdPrice.value / 10;
        if (tomanRate > 0) {
          // Update IRT rate
          final irt = _currencies.firstWhere((c) => c.code == 'IRT');
          setState(() {
            irt.rateToUsd = tomanRate;
            _ratesUpdated = true;
          });
        }
      }
    }
  }

  double get _exchangeRate {
    return _toCurrency.rateToUsd / _fromCurrency.rateToUsd;
  }

  final currencyFormatter = intl.NumberFormat('#,###', 'fa_IR');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
    });
  }

  void _showCurrencyPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCurrencySelector(isFrom),
    );
  }

  Widget _buildCurrencySelector(bool isFrom) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final list = _currencies.where((c) {
          final query = _searchController.text.toLowerCase();
          return c.code.toLowerCase().contains(query) || c.name.contains(query);
        }).toList();

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF191022) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Text(
                      'انتخاب ارز',
                      style: GoogleFonts.vazirmatn(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setModalState(() {}),
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'جستجوی ارز (نام یا کد)...',
                      hintStyle: GoogleFonts.vazirmatn(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final currency = list[index];
                    final isSelected = isFrom
                        ? currency.code == _fromCurrency.code
                        : currency.code == _toCurrency.code;

                    return ListTile(
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            _fromCurrency = currency;
                          } else {
                            _toCurrency = currency;
                          }
                        });
                        _searchController.clear();
                        Navigator.pop(context);
                      },
                      leading: Text(
                        currency.code,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? const Color(0xFF7F13EC)
                              : (isDark ? Colors.white70 : Colors.black54),
                        ),
                      ),
                      title: Text(
                        currency.name,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.vazirmatn(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      trailing: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(currency.flag),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF2A1D35) : Colors.white;
    final primaryColor = const Color(0xFF7F13EC);

    double amount = double.tryParse(_amountController.text) ?? 0;
    double result = amount * _exchangeRate;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87),
        ),
        title: Text(
          'تبدیل ارز',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert,
                color: isDark ? Colors.white : Colors.black87),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Amount Input
            Text(
              'مبلغ',
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  TextField(
                    controller: _amountController,
                    onChanged: (val) => setState(() {}),
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      hintText: '0',
                      hintStyle: TextStyle(
                          color: isDark ? Colors.white10 : Colors.black12),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _fromCurrency.code,
                        style: GoogleFonts.vazirmatn(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Conversion Path
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    _buildCurrencyCard(
                      label: 'از ارز',
                      name: '${_fromCurrency.name} (${_fromCurrency.code})',
                      imagePath: _fromCurrency.flag,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                      onTap: () => _showCurrencyPicker(true),
                    ),
                    const SizedBox(height: 12),
                    _buildCurrencyCard(
                      label: 'به ارز',
                      name: '${_toCurrency.name} (${_toCurrency.code})',
                      imagePath: _toCurrency.flag,
                      surfaceColor: surfaceColor,
                      isDark: isDark,
                      onTap: () => _showCurrencyPicker(false),
                    ),
                  ],
                ),
                Positioned(
                  right: 32,
                  child: GestureDetector(
                    onTap: _swapCurrencies,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: backgroundColor, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.swap_vert, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Result Card
            _buildResultCard(result, primaryColor),
            const SizedBox(height: 24),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                      Icons.content_copy, 'کپی مبلغ', surfaceColor, isDark),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                      Icons.share, 'اشتراک', surfaceColor, isDark),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Chart Section
            _buildChartSection(primaryColor, isDark),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(primaryColor, surfaceColor, isDark),
    );
  }

  Widget _buildCurrencyCard({
    required String label,
    required String name,
    required String imagePath,
    required Color surfaceColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 80,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 10,
                      color: isDark ? Colors.white60 : Colors.black45,
                    ),
                  ),
                  Text(
                    name,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.expand_more,
              color: isDark ? Colors.white24 : Colors.black12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(double result, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D4EDD), Color(0xFF5A189A)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'نتیجه تبدیل',
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              currencyFormatter.format(result),
              style: GoogleFonts.vazirmatn(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getSpelledOutResult(result),
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.update, color: Colors.white60, size: 14),
                const SizedBox(width: 4),
                Text(
                  'نرخ لحظه‌ای - ۱ دقیقه پیش',
                  style: GoogleFonts.vazirmatn(
                    fontSize: 10,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color surfaceColor, bool isDark) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isDark ? Colors.white : Colors.black87),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(Color primaryColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'روند قیمت',
              style: GoogleFonts.vazirmatn(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            Row(
              children: [
                _buildTimeTag('۲۴ ساعت', true, primaryColor),
                const SizedBox(width: 8),
                _buildTimeTag('۱ هفته', false, primaryColor),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A1D35) : Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(double.infinity, 160),
                painter: _ChartPainter(primaryColor),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Text(
                  '112,000',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Text(
                  '110,500',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeTag(String label, bool isSelected, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.vazirmatn(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? primaryColor : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color primaryColor, Color surfaceColor, bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.currency_exchange, 'تبدیل', true, primaryColor),
          _buildNavItem(Icons.trending_up, 'بازار', false, primaryColor),
          _buildNavItem(
              Icons.account_balance_wallet, 'کیف پول', false, primaryColor),
          _buildNavItem(Icons.settings, 'تنظیمات', false, primaryColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? primaryColor : Colors.white24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.vazirmatn(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? primaryColor : Colors.white24,
          ),
        ),
      ],
    );
  }

  String _getSpelledOutResult(double result) {
    if (result == 0) return '';
    return 'نرخ لحظه‌ای محاسبه شد.';
  }
}

class _ChartPainter extends CustomPainter {
  final Color primaryColor;

  _ChartPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.7,
        size.width * 0.2, size.height * 0.75);
    path.cubicTo(size.width * 0.3, size.height * 0.85, size.width * 0.4,
        size.height * 0.5, size.width * 0.5, size.height * 0.6);
    path.cubicTo(size.width * 0.6, size.height * 0.7, size.width * 0.7,
        size.height * 0.3, size.width * 0.8, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.9, size.height * 0.2, size.width, size.height * 0.1);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [primaryColor.withOpacity(0.4), primaryColor.withOpacity(0)],
    );

    canvas.drawPath(
        fillPath,
        Paint()
          ..shader = gradient
              .createShader(Rect.fromLTRB(0, 0, size.width, size.height)));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
