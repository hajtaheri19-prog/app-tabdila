import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Unit {
  final String name;
  final String symbol;
  final double
      factor; // Base factor (usually to the most common unit in category)

  Unit({required this.name, required this.symbol, required this.factor});
}

class UnitCategory {
  final String name;
  final IconData icon;
  final List<Unit> units;
  final String baseUnitName;

  UnitCategory({
    required this.name,
    required this.icon,
    required this.units,
    required this.baseUnitName,
  });
}

class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  late List<UnitCategory> _categories;
  late UnitCategory _selectedCategory;
  late Unit _fromUnit;
  late Unit _toUnit;
  String _inputValue = "1";

  @override
  void initState() {
    super.initState();
    _initializeData();
    _selectedCategory = _categories[0];
    _fromUnit = _selectedCategory.units[0];
    _toUnit = _selectedCategory.units[1];
  }

  void _initializeData() {
    _categories = [
      UnitCategory(
        name: 'طول (Length)',
        icon: Icons.straighten,
        baseUnitName: 'متر',
        units: [
          Unit(name: 'متر', symbol: 'm', factor: 1.0),
          Unit(name: 'کیلومتر', symbol: 'km', factor: 0.001),
          Unit(name: 'سانتی‌متر', symbol: 'cm', factor: 100.0),
          Unit(name: 'میلی‌متر', symbol: 'mm', factor: 1000.0),
          Unit(name: 'اینچ', symbol: 'in', factor: 39.3701),
          Unit(name: 'فوت', symbol: 'ft', factor: 3.28084),
          Unit(name: 'یارد', symbol: 'yd', factor: 1.09361),
          Unit(name: 'مایل', symbol: 'mi', factor: 0.000621371),
        ],
      ),
      UnitCategory(
        name: 'وزن (Weight)',
        icon: Icons.scale,
        baseUnitName: 'گرم',
        units: [
          Unit(name: 'گرم', symbol: 'g', factor: 1.0),
          Unit(name: 'کیلوگرم', symbol: 'kg', factor: 0.001),
          Unit(name: 'میلی‌گرم', symbol: 'mg', factor: 1000.0),
          Unit(name: 'پوند', symbol: 'lb', factor: 0.00220462),
          Unit(name: 'اونس', symbol: 'oz', factor: 0.035274),
          Unit(name: 'تن', symbol: 't', factor: 0.000001),
        ],
      ),
      UnitCategory(
        name: 'دما (Temp)',
        icon: Icons.thermostat,
        baseUnitName: 'سلسیوس',
        units: [
          Unit(name: 'سلسیوس', symbol: '°C', factor: 1.0),
          Unit(name: 'فارنهایت', symbol: '°F', factor: 1.0), // Special handling
          Unit(name: 'کلوین', symbol: 'K', factor: 1.0), // Special handling
        ],
      ),
      UnitCategory(
        name: 'حجم (Volume)',
        icon: Icons.science,
        baseUnitName: 'لیتر',
        units: [
          Unit(name: 'لیتر', symbol: 'L', factor: 1.0),
          Unit(name: 'میلی‌لیتر', symbol: 'mL', factor: 1000.0),
          Unit(name: 'گالن', symbol: 'gal', factor: 0.264172),
          Unit(name: 'فنجان', symbol: 'cup', factor: 4.22675),
          Unit(name: 'متر مکعب', symbol: 'm³', factor: 0.001),
        ],
      ),
      UnitCategory(
        name: 'مساحت (Area)',
        icon: Icons.square_foot,
        baseUnitName: 'متر مربع',
        units: [
          Unit(name: 'متر مربع', symbol: 'm²', factor: 1.0),
          Unit(name: 'هکتار', symbol: 'ha', factor: 0.0001),
          Unit(name: 'آکر', symbol: 'acre', factor: 0.000247105),
          Unit(name: 'کیلومتر مربع', symbol: 'km²', factor: 0.000001),
          Unit(name: 'فوت مربع', symbol: 'ft²', factor: 10.7639),
        ],
      ),
    ];
  }

  double _convertValue(double value, Unit from, Unit to, String category) {
    if (category == 'دما (Temp)') {
      // Celsius base
      double celsius;
      if (from.name == 'سلسیوس') {
        celsius = value;
      } else if (from.name == 'فارنهایت') {
        celsius = (value - 32) * 5 / 9;
      } else {
        celsius = value - 273.15;
      }

      if (to.name == 'سلسیوس') return celsius;
      if (to.name == 'فارنهایت') return (celsius * 9 / 5) + 32;
      return celsius + 273.15;
    }

    // Default linear conversion
    double baseValue = value / from.factor;
    return baseValue * to.factor;
  }

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'backspace') {
        if (_inputValue.length > 1) {
          _inputValue = _inputValue.substring(0, _inputValue.length - 1);
        } else {
          _inputValue = "0";
        }
      } else if (key == '.') {
        if (!_inputValue.contains('.')) {
          _inputValue += ".";
        }
      } else {
        if (_inputValue == "0") {
          _inputValue = key;
        } else {
          _inputValue += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double inputNum = double.tryParse(_inputValue) ?? 0;
    final double result =
        _convertValue(inputNum, _fromUnit, _toUnit, _selectedCategory.name);

    return Scaffold(
      backgroundColor: const Color(0xFF191022),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'تبدیل واحد (Unit Converter)',
                        style: GoogleFonts.vazirmatn(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer for balance
                ],
              ),
            ),

            // Category Selector
            SizedBox(
              height: 50,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                          _fromUnit = cat.units[0];
                          _toUnit = cat.units[1];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF7F13EC)
                              : const Color(0xFF362348),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: const Color(0xFF7F13EC)
                                          .withOpacity(0.3),
                                      blurRadius: 10)
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(cat.icon,
                                color: Colors.white
                                    .withOpacity(isSelected ? 1 : 0.7),
                                size: 20),
                            const SizedBox(width: 8),
                            Text(
                              cat.name,
                              style: GoogleFonts.vazirmatn(
                                color: Colors.white
                                    .withOpacity(isSelected ? 1 : 0.7),
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // From Unit Card
                    _buildUnitCard(
                      label: 'از واحد (From Unit)',
                      value: _inputValue,
                      unit: _fromUnit,
                      isPrimary: true,
                      onUnitTap: () => _showUnitPicker(true),
                    ),

                    // Swap Button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            final temp = _fromUnit;
                            _fromUnit = _toUnit;
                            _toUnit = temp;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF362348),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF191022), width: 3),
                          ),
                          child: const Icon(Icons.swap_vert,
                              color: Color(0xFF7F13EC), size: 20),
                        ),
                      ),
                    ),

                    // To Unit Card
                    _buildUnitCard(
                      label: 'به واحد (To Unit)',
                      value: result
                          .toStringAsFixed(4)
                          .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""),
                      unit: _toUnit,
                      isPrimary: false,
                      onUnitTap: () => _showUnitPicker(false),
                    ),

                    const SizedBox(height: 24),

                    // Other Conversions
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'سایر تبدیل‌ها (OTHER CONVERSIONS)',
                        style: GoogleFonts.vazirmatn(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: _selectedCategory.units
                          .where((u) => u != _fromUnit && u != _toUnit)
                          .take(4)
                          .map((u) => _buildResultItem(u, inputNum))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Numeric Keypad
            _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard({
    required String label,
    required String value,
    required Unit unit,
    required bool isPrimary,
    required VoidCallback onUnitTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrimary
            ? const Color(0xFF2A1E36)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPrimary
              ? const Color(0xFF7F13EC)
              : Colors.white.withOpacity(0.1),
          width: isPrimary ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // RTL: Right aligned
        children: [
          Text(
            label,
            style: GoogleFonts.vazirmatn(
                color: Colors.white.withOpacity(0.6), fontSize: 11),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onUnitTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF362348),
                    borderRadius: BorderRadius.circular(
                        100), // More rounded like screenshot
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.expand_more,
                          color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${unit.name} (${unit.symbol})',
                        style: GoogleFonts.vazirmatn(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.jetBrainsMono(
                    color: isPrimary ? Colors.white : const Color(0xFF7F13EC),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(Unit unit, double baseValue) {
    final result =
        _convertValue(baseValue, _fromUnit, unit, _selectedCategory.name);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF362348).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                      color: const Color(0xFF7F13EC).withOpacity(0.5),
                      shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Text('${unit.name} (${unit.symbol})',
                  style: GoogleFonts.vazirmatn(
                      color: Colors.white.withOpacity(0.8), fontSize: 13)),
            ],
          ),
          Text(
            result
                .toStringAsFixed(4)
                .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), ""),
            style: GoogleFonts.jetBrainsMono(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF2A1E36),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(2)),
              margin: const EdgeInsets.only(bottom: 16)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 2,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            children: [
              '1',
              '2',
              '3',
              '4',
              '5',
              '6',
              '7',
              '8',
              '9',
              '.',
              '0',
              'backspace'
            ].map((key) {
              if (key == 'backspace') {
                return _buildKeypadButton(key,
                    icon: Icons.backspace, color: const Color(0xFF7F13EC));
              }
              return _buildKeypadButton(key);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String key, {IconData? icon, Color? color}) {
    return InkWell(
      onTap: () => _onKeyPress(key),
      child: Center(
        child: icon != null
            ? Icon(icon, color: color ?? Colors.white, size: 24)
            : Text(
                key,
                style: GoogleFonts.vazirmatn(
                    color: color ?? Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.normal),
              ),
      ),
    );
  }

  void _showUnitPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A1E36),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _selectedCategory.units.length,
          itemBuilder: (context, index) {
            final unit = _selectedCategory.units[index];
            return ListTile(
              title: Text(
                '${unit.name} (${unit.symbol})',
                style: GoogleFonts.vazirmatn(color: Colors.white, fontSize: 14),
              ),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    _fromUnit = unit;
                  } else {
                    _toUnit = unit;
                  }
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
