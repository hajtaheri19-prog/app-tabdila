import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DistanceCalculatorPage extends StatefulWidget {
  const DistanceCalculatorPage({super.key});

  @override
  State<DistanceCalculatorPage> createState() => _DistanceCalculatorPageState();
}

class _DistanceCalculatorPageState extends State<DistanceCalculatorPage> {
  String _origin = 'تهران';
  String _destination = 'شیراز';
  final List<String> _cities = [
    'تهران',
    'اصفهان',
    'شیراز',
    'مشهد',
    'تبریز',
    'اهواز',
    'کرمان',
  ];

  // Mock distance data
  final int _distance = 934;
  final String _carTime = '10:45';
  final String _busTime = '12:30';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    const primaryColor = Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Main Content Scrollable
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Map Section
                    _buildMapHeader(isDark, primaryColor),

                    // Input Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildInputCard(
                            label: 'مبدأ',
                            value: _origin,
                            icon: Icons.location_on,
                            iconColor: primaryColor,
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            onChanged: (val) => setState(() => _origin = val!),
                          ),
                          _buildSwapButton(primaryColor, backgroundColor),
                          _buildInputCard(
                            label: 'مقصد',
                            value: _destination,
                            icon: Icons.flag,
                            iconColor: const Color(0xFFA855F7),
                            isDark: isDark,
                            surfaceColor: surfaceColor,
                            onChanged: (val) =>
                                setState(() => _destination = val!),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Custom Header (Floating)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          const Icon(Icons.arrow_forward, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'محاسبه مسافت بین شهرها',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.vazirmatn(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer for center alignment
                  ],
                ),
              ),
            ),
          ),

          // Bottom Results Panel
          _buildResultsPanel(isDark, surfaceColor, primaryColor),
        ],
      ),
    );
  }

  Widget _buildMapHeader(bool isDark, Color primaryColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF261933),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        child: Stack(
          children: [
            // Mock Map Image
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAeoMxIM1C5gU1OAhmd4SbyBVHqbYWiiFMFUlAHABMRSS5qTfHZqT7QaYxEG_H-lCsXUr0b2O9CGCG_A-cbiw4vN-XshSP-_7rWGjcQBSbu-0Z6cNu_ac5NET9-nuPiiZzfoek2v_N6PeRNDKdjGiW8HNnJ9ZLi2hzjjagI-wKLaycVTNtVTMfqTDteB3MEu9tvnNS4aNA_4Z7cvQPqpkhsmblz90E1qXr2QGFH1uv_-AT6Q2YGVgorF4MFHt6e_iWeM827Cj8yP5U',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              opacity: const AlwaysStoppedAnimation(0.6),
            ),
            // Overlay Gradients
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    primaryColor.withOpacity(0.1),
                    const Color(0xFF191022).withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Glowing Points
            _buildMapDot(
              top: 0.3,
              left: 0.25,
              size: 12,
              color: primaryColor,
              animate: true,
            ),
            _buildMapDot(
              top: 0.5,
              right: 0.33,
              size: 8,
              color: const Color(0xFFA855F7),
              animate: false,
            ),
            _buildMapDot(
              bottom: 0.3,
              left: 0.5,
              size: 10,
              color: Colors.white,
              animate: false,
            ),

            // Hint text
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Text(
                'لطفا مبدأ و مقصد را انتخاب کنید',
                textAlign: TextAlign.center,
                style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapDot({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required double size,
    required Color color,
    bool animate = false,
  }) {
    return Positioned(
      top: top != null ? MediaQuery.of(context).size.height * 0.45 * top : null,
      left: left != null ? MediaQuery.of(context).size.width * left : null,
      right: right != null ? MediaQuery.of(context).size.width * right : null,
      bottom: bottom != null
          ? MediaQuery.of(context).size.height * 0.45 * bottom
          : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    required Color surfaceColor,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.vazirmatn(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: surfaceColor,
                icon:
                    const Icon(Icons.expand_more, size: 20, color: Colors.grey),
                style: GoogleFonts.vazirmatn(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwapButton(Color primaryColor, Color backgroundColor) {
    return Transform.translate(
      offset: const Offset(0, -25),
      child: Center(
        child: InkWell(
          onTap: () {
            setState(() {
              final temp = _origin;
              _origin = _destination;
              _destination = temp;
            });
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF191022), width: 4),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.swap_vert, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsPanel(
    bool isDark,
    Color surfaceColor,
    Color primaryColor,
  ) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Distance row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مسافت تقریبی',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$_distance',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'کیلومتر',
                            style: GoogleFonts.vazirmatn(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.route, color: primaryColor, size: 32),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white10),
              ),
              // Travel times
              Row(
                children: [
                  Expanded(
                    child: _buildTimeItem(
                      icon: Icons.directions_car,
                      label: 'خودرو شخصی',
                      time: _carTime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimeItem(
                      icon: Icons.directions_bus,
                      label: 'اتوبوس',
                      time: _busTime,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeItem({
    required IconData icon,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF362348),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 10,
                    color: Colors.grey[400],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.vazirmatn(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: time),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: 'ساعت',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
