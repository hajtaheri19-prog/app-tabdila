import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../../../core/utils/digit_utils.dart';

class GoldCalculatorPage extends StatefulWidget {
  final int initialIndex;
  const GoldCalculatorPage({super.key, this.initialIndex = 0});

  @override
  State<GoldCalculatorPage> createState() => _GoldCalculatorPageState();
}

class _GoldCalculatorPageState extends State<GoldCalculatorPage> {
  late int _activeMode;
  final _formatter = NumberFormat("#,###");

  // General Controllers
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _wageController = TextEditingController();
  final TextEditingController _profitController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  // Coin Bubble Controllers
  final TextEditingController _coinMarketPriceController =
      TextEditingController();
  final TextEditingController _globalOunceController = TextEditingController();
  final TextEditingController _usdRateController = TextEditingController();

  // Reverse Calculation Controller
  final TextEditingController _totalPaidController = TextEditingController();

  String _goldPurity = '18';
  String _coinType = 'emami';
  bool _isWagePercentage = true;

  // Results
  double _finalResult = 0.0;
  double _rawGoldPriceResult = 0.0;
  double _wageAmountResult = 0.0;
  double _profitAmountResult = 0.0;
  double _taxAmountResult = 0.0;
  double _bubbleAmountResult = 0.0;
  double _bubblePercentResult = 0.0;
  double _intrinsicValueResult = 0.0;

  @override
  void initState() {
    super.initState();
    _activeMode = widget.initialIndex;
  }

  void _calculate() {
    setState(() {
      if (_activeMode == 0) {
        _calculateGoldPrice();
      } else if (_activeMode == 1) {
        _calculateCoinBubble();
      } else if (_activeMode == 2) {
        _calculateConstructionWage();
      } else if (_activeMode == 3) {
        _calculateWageFromInvoice();
      }
    });
  }

  void _calculateGoldPrice() {
    double pricePerGram = DigitUtils.parseDouble(_priceController.text);
    double weight = DigitUtils.parseDouble(_weightController.text);
    double wage = DigitUtils.parseDouble(_wageController.text);
    double profit = DigitUtils.parseDouble(_profitController.text);
    double tax = DigitUtils.parseDouble(_taxController.text);

    if (weight <= 0 || pricePerGram <= 0) return;

    _rawGoldPriceResult = pricePerGram * weight;
    if (_isWagePercentage) {
      _wageAmountResult = _rawGoldPriceResult * (wage / 100);
    } else {
      _wageAmountResult = wage * weight;
    }

    double taxableAmount = _rawGoldPriceResult + _wageAmountResult;
    _profitAmountResult = taxableAmount * (profit / 100);
    _taxAmountResult = (taxableAmount + _profitAmountResult) * (tax / 100);

    _finalResult = taxableAmount + _profitAmountResult + _taxAmountResult;
  }

  void _calculateCoinBubble() {
    double ounce = DigitUtils.parseDouble(_globalOunceController.text);
    double usdRate = DigitUtils.parseDouble(_usdRateController.text);
    double marketPrice =
        DigitUtils.parseDouble(_coinMarketPriceController.text);

    if (ounce <= 0 || usdRate <= 0 || marketPrice <= 0) return;

    double weight = 8.133; // Emami
    if (_coinType == 'half') weight = 4.066;
    if (_coinType == 'quarter') weight = 2.033;
    if (_coinType == 'gram') weight = 1.1;

    // Standard formula: ((Ounce / 31.103) * USD Rate * 0.9 * Weight) + Minting Fee
    _intrinsicValueResult = ((ounce / 31.103) * usdRate * 0.9 * weight) + 50000;
    _bubbleAmountResult = marketPrice - _intrinsicValueResult;
    _bubblePercentResult = (_bubbleAmountResult / marketPrice) * 100;
    _finalResult = marketPrice;
  }

  void _calculateConstructionWage() {
    double pricePerGram = DigitUtils.parseDouble(_priceController.text);
    double wage = DigitUtils.parseDouble(_wageController.text);
    double weight = DigitUtils.parseDouble(_weightController.text);

    if (pricePerGram <= 0 || weight <= 0) return;

    if (_isWagePercentage) {
      _wageAmountResult = (pricePerGram * weight) * (wage / 100);
    } else {
      _wageAmountResult = wage * weight;
    }
    _finalResult = _wageAmountResult;
  }

  void _calculateWageFromInvoice() {
    double totalPaid = DigitUtils.parseDouble(_totalPaidController.text);
    double pricePerGram = DigitUtils.parseDouble(_priceController.text);
    double weight = DigitUtils.parseDouble(_weightController.text);
    double profit = DigitUtils.parseDouble(_profitController.text);
    double tax = DigitUtils.parseDouble(_taxController.text);

    if (totalPaid <= 0 || pricePerGram <= 0 || weight <= 0) return;

    _rawGoldPriceResult = pricePerGram * weight;

    // Total = (Raw + Wage) * (1 + Profit/100) * (1 + Tax/100)
    // Wage = (Total / ((1+Profit/100)*(1+Tax/100))) - Raw
    double multiplier = (1 + (profit / 100)) * (1 + (tax / 100));
    _wageAmountResult = (totalPaid / multiplier) - _rawGoldPriceResult;

    if (_wageAmountResult < 0) _wageAmountResult = 0;

    _bubblePercentResult = (_wageAmountResult / _rawGoldPriceResult) * 100;
    _intrinsicValueResult = _rawGoldPriceResult;
    _finalResult = totalPaid;
  }

  void _reset() {
    setState(() {
      _weightController.clear();
      _totalPaidController.clear();
      _finalResult = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const goldColor = Color(0xFFFBBF24);
    const backgroundDark = Color(0xFF0F0816);
    const surfaceDark = Color(0xFF1A1025);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _activeMode == 0
              ? 'محاسبه قیمت طلا'
              : _activeMode == 1
                  ? 'محاسبه حباب سکه'
                  : _activeMode == 2
                      ? 'محاسبه اجرت ساخت'
                      : 'اجرت از فاکتور',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _reset,
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Stack(
          children: [
            // Background Glows
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle),
                child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(color: Colors.transparent)),
              ),
            ),

            Column(
              children: [
                _buildTabs(primaryColor, surfaceDark, isDark),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (_activeMode == 1 && _finalResult > 0)
                          _buildBubbleHeader(goldColor),
                        if (_activeMode == 2)
                          _buildConstructionHeader(primaryColor),
                        if (_activeMode == 3 && _finalResult > 0)
                          _buildExtractionResult(primaryColor),
                        const SizedBox(height: 20),
                        _buildForm(
                            primaryColor, goldColor, surfaceDark, isDark),
                        const SizedBox(height: 24),
                        _buildCalculateButton(primaryColor, goldColor),
                        const SizedBox(height: 24),
                        if (_activeMode == 0 && _finalResult > 0)
                          _buildGoldInvoice(goldColor, surfaceDark, isDark),
                        if (_activeMode == 2 && _finalResult > 0)
                          _buildWageResultCard(
                              primaryColor, surfaceDark, isDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(Color primary, Color surface, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildTabItem('قیمت طلا', 0, primary, isDark),
          _buildTabItem('حباب سکه', 1, primary, isDark),
          _buildTabItem('اجرت ساخت', 2, primary, isDark),
          _buildTabItem('آنالیز فاکتور', 3, primary, isDark),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index, Color primary, bool isDark) {
    bool isActive = _activeMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _activeMode = index;
          _finalResult = 0;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.vazirmatn(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : (isDark ? Colors.grey : Colors.black54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Color primary, Color gold, Color surface, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_activeMode == 0 || _activeMode == 2 || _activeMode == 3) ...[
          _buildLabel('عیار طلا'),
          _buildKaratDropdown(gold, surface, isDark),
          const SizedBox(height: 16),
          _buildLabel('قیمت هر گرم طلا (تومان)'),
          _buildInputField(
              _priceController, Icons.payments, primary, surface, isDark,
              isPrice: true),
          const SizedBox(height: 16),
          _buildLabel('وزن طلا (گرم)'),
          _buildInputField(
              _weightController, Icons.scale, gold, surface, isDark,
              hint: 'مثلا 4.5'),
          const SizedBox(height: 16),
        ],
        if (_activeMode == 0 || _activeMode == 2) ...[
          _buildLabel('اجرت ساخت'),
          Row(
            children: [
              Expanded(
                  child: _buildInputField(_wageController, Icons.construction,
                      primary, surface, isDark,
                      hint: '18')),
              const SizedBox(width: 8),
              _buildWageToggle(primary, surface, isDark),
            ],
          ),
          const SizedBox(height: 16),
        ],
        if (_activeMode == 0 || _activeMode == 3) ...[
          if (_activeMode == 3) ...[
            _buildLabel('قیمت کل پرداختی (تومان)'),
            _buildInputField(_totalPaidController, Icons.account_balance_wallet,
                primary, surface, isDark,
                isPrice: true),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('سود فروشنده (%)'),
                    _buildInputField(_profitController, Icons.percent,
                        Colors.orange, surface, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('مالیات (%)'),
                    _buildInputField(_taxController, Icons.receipt,
                        Colors.redAccent, surface, isDark),
                  ],
                ),
              ),
            ],
          ),
        ],
        if (_activeMode == 1) ...[
          _buildLabel('نوع سکه'),
          _buildCoinDropdown(gold, surface, isDark),
          const SizedBox(height: 16),
          _buildLabel('قیمت بازار سکه (تومان)'),
          _buildInputField(_coinMarketPriceController, Icons.payments, primary,
              surface, isDark,
              isPrice: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('انس جهانی (\$)'),
                    _buildInputField(_globalOunceController, Icons.public,
                        Colors.blue, surface, isDark),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('نرخ دلار (تومان)'),
                    _buildInputField(_usdRateController,
                        Icons.currency_exchange, Colors.green, surface, isDark,
                        isPrice: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(text,
          style: GoogleFonts.vazirmatn(fontSize: 13, color: Colors.grey)),
    );
  }

  Widget _buildInputField(TextEditingController controller, IconData icon,
      Color iconColor, Color surface, bool isDark,
      {bool isPrice = false, String hint = 'وارد کنید'}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        textAlign: isPrice ? TextAlign.left : TextAlign.center,
        onChanged: (v) {
          if (isPrice) {
            String val = v.replaceAll(',', '');
            if (val.isNotEmpty) {
              controller.value = TextEditingValue(
                text: _formatter.format(int.parse(val)),
                selection: TextSelection.collapsed(
                    offset: _formatter.format(int.parse(val)).length),
              );
            }
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: iconColor, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildKaratDropdown(Color gold, Color surface, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _goldPurity,
          isExpanded: true,
          dropdownColor: surface,
          onChanged: (v) => setState(() => _goldPurity = v!),
          items: [
            DropdownMenuItem(
                value: '18',
                child: Text('۱۸ عیار (۷۵۰)', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: '24',
                child: Text('۲۴ عیار (۹۹۹)', style: GoogleFonts.vazirmatn())),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinDropdown(Color gold, Color surface, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _coinType,
          isExpanded: true,
          dropdownColor: surface,
          onChanged: (v) => setState(() => _coinType = v!),
          items: [
            DropdownMenuItem(
                value: 'emami',
                child: Text('سکه تمام امامی', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: 'half',
                child: Text('نیم سکه', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: 'quarter',
                child: Text('ربع سکه', style: GoogleFonts.vazirmatn())),
            DropdownMenuItem(
                value: 'gram',
                child: Text('سکه گرمی', style: GoogleFonts.vazirmatn())),
          ],
        ),
      ),
    );
  }

  Widget _buildWageToggle(Color primary, Color surface, bool isDark) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildToggleButton('%', _isWagePercentage, primary),
          _buildToggleButton('تومان', !_isWagePercentage, primary),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool active, Color primary) {
    return GestureDetector(
      onTap: () => setState(() => _isWagePercentage = label == '%'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(label,
              style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: active ? Colors.white : Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildCalculateButton(Color primary, Color gold) {
    return GestureDetector(
      onTap: _calculate,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primary, primary.withOpacity(0.8)]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calculate, color: Colors.white),
            const SizedBox(width: 12),
            Text('محاسبه نتیجه',
                style: GoogleFonts.vazirmatn(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleHeader(Color gold) {
    bool isHighRisk = _bubblePercentResult > 12;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: gold.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const ui.Size(200, 100),
                painter: BubbleGaugePainter(percent: _bubblePercentResult),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(_bubblePercentResult.toStringAsFixed(1) + '%',
                      style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text('نسبت حباب',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isHighRisk
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning,
                    size: 14, color: isHighRisk ? Colors.red : Colors.green),
                const SizedBox(width: 6),
                Text(
                    isHighRisk
                        ? 'حباب زیاد (ریسک بالا)'
                        : 'حباب کم (ریسک پایین)',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12,
                        color: isHighRisk ? Colors.red : Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildSmallBox('ارزش واقعی',
                  '${_formatter.format(_intrinsicValueResult.round())}'),
              const SizedBox(width: 12),
              _buildSmallBox('میزان حباب',
                  '+${_formatter.format(_bubbleAmountResult.round())}',
                  color: gold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallBox(String label, String value, {Color? color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.vazirmatn(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            FittedBox(
                child: Text(DigitUtils.toFarsi(value),
                    style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color))),
          ],
        ),
      ),
    );
  }

  Widget _buildConstructionHeader(Color primary) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: primary.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.diamond, color: primary, size: 40),
        ),
        const SizedBox(height: 12),
        Text('برآورد اجرت ساخت',
            style: GoogleFonts.vazirmatn(
                fontSize: 18, fontWeight: FontWeight.bold)),
        Text('محاسبه دقیق هزینه تولید طلا',
            style: GoogleFonts.vazirmatn(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  Widget _buildExtractionResult(Color primary) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primary, primary.withOpacity(0.7)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text('اجرت استخراج شده (در هر گرم)',
              style:
                  GoogleFonts.vazirmatn(color: Colors.white70, fontSize: 13)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                  DigitUtils.toFarsi(
                      _formatter.format(_wageAmountResult.round())),
                  style: GoogleFonts.manrope(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              SizedBox(width: 4),
              Text('تومان',
                  style:
                      GoogleFonts.vazirmatn(fontSize: 14, color: Colors.white)),
            ],
          ),
          Divider(color: Colors.white24, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildExtractionMini(
                  'درصد اجرت', '${_bubblePercentResult.toStringAsFixed(1)}%'),
              _buildExtractionMini('قیمت پایه طلا',
                  '${_formatter.format(_intrinsicValueResult.round())}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtractionMini(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(fontSize: 11, color: Colors.white70)),
        Text(DigitUtils.toFarsi(value),
            style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildGoldInvoice(Color gold, Color surface, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: gold.withOpacity(0.2)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long, color: gold, size: 20),
              const SizedBox(width: 8),
              Text('جزئیات فاکتور خرید',
                  style: GoogleFonts.vazirmatn(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          _buildInvoiceRow('قیمت طلای خام', _rawGoldPriceResult),
          _buildInvoiceRow('اجرت ساخت', _wageAmountResult),
          _buildInvoiceRow('سود فروشنده', _profitAmountResult),
          _buildInvoiceRow('مالیات بر ارزش افزوده', _taxAmountResult),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('قیمت نهایی پرداختی',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 16, fontWeight: FontWeight.bold, color: gold)),
              Text(
                  DigitUtils.toFarsi(_formatter.format(_finalResult.round())) +
                      ' تومان',
                  style: GoogleFonts.manrope(
                      fontSize: 20, fontWeight: FontWeight.w900, color: gold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.vazirmatn(fontSize: 13, color: Colors.grey)),
          Text(DigitUtils.toFarsi(_formatter.format(value.round())) + ' تومان',
              style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildWageResultCard(Color primary, Color surface, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.construction, color: primary, size: 32),
          const SizedBox(height: 12),
          Text('هزینه خالص اجرت ساخت',
              style: GoogleFonts.vazirmatn(color: Colors.grey, fontSize: 13)),
          Text(
              DigitUtils.toFarsi(_formatter.format(_finalResult.round())) +
                  ' تومان',
              style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 16),
          Text(
            'این مبلغ فقط هزینه خدمات ساخت است و شامل قیمت طلای خام، سود و مالیات نمی‌باشد.',
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class BubbleGaugePainter extends CustomPainter {
  final double percent;
  BubbleGaugePainter({required this.percent});

  @override
  void paint(Canvas canvas, ui.Size size) {
    final center = ui.Offset(size.width / 2, size.height);
    final radius = size.width * 0.45;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    // Background Arc
    paint.color = Colors.white.withOpacity(0.1);
    canvas.drawArc(ui.Rect.fromCircle(center: center, radius: radius), 3.14,
        3.14, false, paint);

    // Active Arc
    double sweepAngle = (percent / 25).clamp(0, 1) * 3.14;
    paint.shader =
        LinearGradient(colors: [Colors.green, Colors.yellow, Colors.red])
            .createShader(ui.Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(ui.Rect.fromCircle(center: center, radius: radius), 3.14,
        sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
