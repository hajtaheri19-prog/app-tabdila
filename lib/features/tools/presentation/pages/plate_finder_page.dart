import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlateFinderPage extends StatefulWidget {
  const PlateFinderPage({super.key});

  @override
  State<PlateFinderPage> createState() => _PlateFinderPageState();
}

class _PlateFinderPageState extends State<PlateFinderPage> {
  final TextEditingController _leftController = TextEditingController();
  final TextEditingController _middleController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  String _selectedLetter = 'ب';
  bool _showResult = false;
  String _resultLocation = '';
  String _resultRegionCode = '';

  final List<String> _letters = [
    'الف',
    'ب',
    'پ',
    'ت',
    'ث',
    'ج',
    'د',
    'ز',
    'س',
    'ش',
    'ص',
    'ط',
    'ع',
    'ق',
    'ک',
    'گ',
    'ل',
    'م',
    'ن',
    'و',
    'ه',
    'ی',
  ];

  // Mock data for region codes
  final Map<String, String> _regionMap = {
    '11': 'تهران (جنوب)',
    '22': 'تهران (غرب)',
    '33': 'تهران (شمال)',
    '44': 'تهران (شرق)',
    '55': 'تهران (مرکز)',
    '66': 'تهران (اسلامشهر)',
    '77': 'تهران (پاکدشت/ورامین)',
    '88': 'تهران (کرج)',
    '99': 'تهران (قدس/شهریار)',
    '10': 'مرکزی (اراک)',
    '20': 'گیلان (رشت)',
    '30': 'مازندران (ساری)',
    '40': 'آذربایجان شرقی (تبریز)',
    '50': 'اصفهان (اصفهان)',
    '60': 'فارس (شیراز)',
    '70': 'قزوین (قزوین)',
    '80': 'خوزستان (اهواز)',
    '90': 'کردستان (سنندج)',
    '12': 'یزد (یزد)',
    '24': 'خوزستان (دزفول)',
  };

  void _searchPlate() {
    String region = _regionController.text.trim();
    if (region.isEmpty) return;

    setState(() {
      _resultRegionCode = region;
      _resultLocation = _regionMap[region] ?? 'شهر نامشخص (کد $region)';
      _showResult = true;
    });
  }

  @override
  void dispose() {
    _leftController.dispose();
    _middleController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    const primaryColor = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF1A1122).withOpacity(0.9) : Colors.white,
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
          'پلاکیاب هوشمند',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Text(
              'استعلام پلاک',
              style: GoogleFonts.vazirmatn(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'شماره پلاک مورد نظر را روی تصویر زیر وارد کنید',
              textAlign: TextAlign.center,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 48),

            // Plate Component
            _buildPlate(isDark, primaryColor),

            const SizedBox(height: 40),

            // Search Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _searchPlate,
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'جستجو',
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

            if (_showResult) ...[
              const SizedBox(height: 32),
              _buildResultSection(isDark, primaryColor),
            ],

            const SizedBox(height: 40),
            _buildRecentSearches(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildPlate(bool isDark, Color primaryColor) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[400]!.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Blue Strip
          Container(
            width: 48,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDeQj7Hvqs8ghF1GLgwQxqwBVFaVv19K7lPVZf_bjmUqkqJnqaHy0uE9bWKmGbDRxdfCCjD3XSg6ZBhFvWQrUhpYI-JKmpvrNTDl5bA1AGPyu3LP3Gdh6AKLkjzUdd9yx1KS3jtHnYOM7Ql8E4jYh6ERUPWCFrxgx5eYy3bQZLYSTv9uujIS0rxlF6RnaUUtAbSmL4Khya2GRcRXNGVwLb3l4TKcB7pAseUHIauJIeoIdHqXStCFkimsDDO1iGBCTzvxI6Q1wQQ70I',
                  width: 32,
                  fit: BoxFit.contain,
                ),
                Text(
                  'I.R.\nIRAN',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Main Number Entry Area
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  children: [
                    // Left 2 digits
                    Expanded(
                      flex: 25,
                      child: TextField(
                        controller: _leftController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 2,
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          hintText: '11',
                        ),
                      ),
                    ),
                    // Letter
                    Expanded(
                      flex: 20,
                      child: PopupMenuButton<String>(
                        onSelected: (val) =>
                            setState(() => _selectedLetter = val),
                        itemBuilder: (context) => _letters
                            .map((l) => PopupMenuItem(value: l, child: Text(l)))
                            .toList(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _selectedLetter,
                              style: GoogleFonts.vazirmatn(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: primaryColor,
                              ),
                            ),
                            const Icon(
                              Icons.expand_more,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Middle 3 digits
                    Expanded(
                      flex: 30,
                      child: TextField(
                        controller: _middleController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 3,
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          hintText: '234',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Divider
          Container(width: 1, color: Colors.black.withOpacity(0.1)),

          // Region Box (Right)
          Container(
            width: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: Text(
                    'ایران',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: _regionController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: '77',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(bool isDark, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF251A30),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Text(
                'نتیجه استعلام',
                style: GoogleFonts.vazirmatn(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Location Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF362348),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDmGg9dmW7-B5DA0fZ8dvNI0jjv3CL05zdOmMJmWcd6-6kufXB-YoKu9QHNO0ju-hHQemQxYcxhTvAcdKCB7vPM98eNVy7h1Z8zJPOi47Afd8kmQUjAFV4c08gfbjrargXOISg_k4w-xy1y9LccDh9dGyo_MGrpwyCBsTnwtGbFkrsN7Zj9fXLmVNtki1rRS97Pw9k-5udsx_xhfNpvhkGR_mMUYGvguZrXd05AtBeLfUxLLRHwuqby0iwTFCu5Dl8P8dlRJ81-7fU',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'استان و شهر',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 10,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        _resultLocation,
                        style: GoogleFonts.vazirmatn(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildResultItem(
                  'نوع پلاک',
                  'شخصی',
                  Icons.badge,
                  primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildResultItem(
                  'کد منطقه',
                  _resultRegionCode,
                  Icons.numbers,
                  primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
    String label,
    String value,
    IconData icon,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF362348),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.vazirmatn(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearches(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 12),
          child: Text(
            'جستجوهای اخیر',
            style: GoogleFonts.vazirmatn(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1122) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '12 B 456 - 88',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'یزد، یزد',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
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
}
