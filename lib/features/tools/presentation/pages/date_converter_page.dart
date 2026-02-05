import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DateConverterPage extends StatefulWidget {
  const DateConverterPage({super.key});

  @override
  State<DateConverterPage> createState() => _DateConverterPageState();
}

class _DateConverterPageState extends State<DateConverterPage> {
  int _conversionType =
      0; // 0: Solar to Gregorian, 1: Gregorian to Solar, 2: Lunar

  // Selected Date Components
  int _selectedYear = 1402;
  int _selectedMonth = 3;
  int _selectedDay = 11;

  final FixedExtentScrollController _yearController =
      FixedExtentScrollController(initialItem: 1402 - 1300); // Base year 1300
  final FixedExtentScrollController _monthController =
      FixedExtentScrollController(initialItem: 2);
  final FixedExtentScrollController _dayController =
      FixedExtentScrollController(initialItem: 10);

  final List<String> _jalaliMonths = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند'
  ];

  final List<String> _gregorianMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> _lunarMonths = [
    'محرم',
    'صفر',
    'ربیع‌الاول',
    'ربیع‌الثانی',
    'جمادی‌الاول',
    'جمادی‌الثانی',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذیقعده',
    'ذیحجه'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with current date solar
    final now = Jalali.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;
    _selectedDay = now.day;

    // Update controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_yearController.hasClients)
        _yearController.jumpToItem(_selectedYear - 1300);
      if (_monthController.hasClients)
        _monthController.jumpToItem(_selectedMonth - 1);
      if (_dayController.hasClients)
        _dayController.jumpToItem(_selectedDay - 1);
    });
  }

  void _updateDate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = const Color(0xFF7F13EC);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildConversionTypeTabs(isDark, primary),
                    const SizedBox(height: 24),
                    _buildDatePickerWheel(isDark, primary),
                    const SizedBox(height: 24),
                    _buildCalendarView(isDark, primary),
                    const SizedBox(height: 24),
                    _buildResultCard(isDark, primary),
                    const SizedBox(height: 24),
                    _buildActionButtons(isDark, primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_forward,
                color: isDark ? Colors.white : Colors.black87),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          Text(
            'تبدیل تاریخ',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 48), // Balance
        ],
      ),
    );
  }

  Widget _buildConversionTypeTabs(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF362348) : Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
              ],
      ),
      child: Row(
        children: [
          _buildTabItem('قمری', 2, isDark, primary),
          _buildTabItem('میلادی به شمسی', 1, isDark, primary),
          _buildTabItem('شمسی به میلادی', 0, isDark, primary),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index, bool isDark, Color primary) {
    final isSelected = _conversionType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _conversionType = index;
            // Logic to convert current selected date to new type could go here
            // For simplicity, we just reset or keep numbers (user readjusts)
            // or better: preserve the actual point in time.
            _convertAndSetDate(index);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: primary.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.vazirmatn(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDark ? const Color(0xFFAD92C9) : Colors.grey[600]),
            ),
          ),
        ),
      ),
    );
  }

  void _convertAndSetDate(int newType) {
    // Current state to Gregorian
    DateTime greg;
    if (_conversionType == 0) {
      // Was solar
      Jalali j = Jalali(_selectedYear, _selectedMonth, _selectedDay);
      greg = j.toDateTime();
    } else if (_conversionType == 1) {
      // Was Gregorian
      greg = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    } else {
      // Was Lunar (Simplification: treat as Solar/Greg for now or use complex lib)
      // Assuming input was Solar for better UX flow if switching from lunar (which is complex)
      // or just reset to Now
      greg = DateTime.now();
    }

    if (newType == 0) {
      // To Solar
      Jalali j = Jalali.fromDateTime(greg);
      _selectedYear = j.year;
      _selectedMonth = j.month;
      _selectedDay = j.day;
    } else if (newType == 1) {
      // To Gregorian
      _selectedYear = greg.year;
      _selectedMonth = greg.month;
      _selectedDay = greg.day;
    } else {
      // To Lunar - Not supported in standard shamsi_date fully for conversion TO lunar easily in this context without extra libs perhaps
      // Let's reset to a safe default
    }

    // Update scroll controllers
    _safeJumpTo(
        _yearController, _selectedYear - (_conversionType == 1 ? 1900 : 1300));
    _safeJumpTo(_monthController, _selectedMonth - 1);
    _safeJumpTo(_dayController, _selectedDay - 1);
  }

  void _safeJumpTo(FixedExtentScrollController controller, int index) {
    if (controller.hasClients) {
      controller.jumpToItem(index < 0 ? 0 : index);
    }
  }

  Widget _buildDatePickerWheel(bool isDark, Color primary) {
    // Determine ranges based on type
    final isGregorianInput = _conversionType == 1;
    final minYear = isGregorianInput ? 1900 : 1300;
    final maxYear = isGregorianInput ? 2100 : 1500;
    final months = isGregorianInput
        ? _gregorianMonths
        : (_conversionType == 2 ? _lunarMonths : _jalaliMonths);

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1E36) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200]!),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Highlight Bar
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: primary.withOpacity(isDark ? 0.2 : 0.1),
              ),
            ),
          ),
          Row(
            children: [
              _buildWheelColumn(
                controller: _yearController,
                itemCount: maxYear - minYear + 1,
                builder: (context, index) {
                  final year = minYear + index;
                  return Center(
                      child: Text('$year',
                          style:
                              _wheelTextStyle(isDark, year == _selectedYear)));
                },
                onChanged: (index) {
                  setState(() => _selectedYear = minYear + index);
                },
              ),
              _buildWheelColumn(
                controller: _monthController,
                itemCount: 12,
                builder: (context, index) {
                  return Center(
                      child: Text(months[index],
                          style: _wheelTextStyle(
                              isDark, index + 1 == _selectedMonth)));
                },
                onChanged: (index) {
                  setState(() => _selectedMonth = index + 1);
                },
                flex: 2,
              ),
              _buildWheelColumn(
                controller: _dayController,
                itemCount: 31,
                builder: (context, index) {
                  final day = index + 1;
                  return Center(
                      child: Text('${day.toString().padLeft(2, '0')}',
                          style: _wheelTextStyle(isDark, day == _selectedDay)));
                },
                onChanged: (index) {
                  setState(() => _selectedDay = index + 1);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _wheelTextStyle(bool isDark, bool isSelected) {
    return GoogleFonts.vazirmatn(
      fontSize: isSelected ? 20 : 16,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      color: isSelected
          ? (isDark ? Colors.white : Colors.black)
          : (isDark ? Colors.grey[600] : Colors.grey[400]),
    );
  }

  Widget _buildWheelColumn({
    required FixedExtentScrollController controller,
    required int itemCount,
    required Widget Function(BuildContext, int) builder,
    required ValueChanged<int> onChanged,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        perspective: 0.005,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: builder,
          childCount: itemCount,
        ),
      ),
    );
  }

  Widget _buildCalendarView(bool isDark, Color primary) {
    // Simplified Calendar View
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_right,
                      color: isDark ? Colors.white : Colors.grey[600])),
              Text(
                _conversionType == 0
                    ? '${_jalaliMonths[_selectedMonth - 1]} $_selectedYear'
                    : '${_gregorianMonths[_selectedMonth - 1]} $_selectedYear',
                style: GoogleFonts.vazirmatn(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87),
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_left,
                      color: isDark ? Colors.white : Colors.grey[600])),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2A1E36) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج']
                    .map((d) => Text(d,
                        style: GoogleFonts.vazirmatn(
                            fontSize: 12, color: Colors.grey[500])))
                    .toList(),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7),
                itemCount: 30, // Dummy
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = day == _selectedDay;
                  return Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected ? primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[700])),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(bool isDark, Color primary) {
    // Determine conversion result
    DateTime resultDate;
    Jalali resultJalali;
    String dayName = '';

    if (_conversionType == 0) {
      // Input Solar -> Output Gregorian
      try {
        final j = Jalali(_selectedYear, _selectedMonth, _selectedDay);
        resultDate = j.toDateTime();
        resultJalali = j; // Source
        dayName = _getDayName(resultDate.weekday);
      } catch (e) {
        resultDate = DateTime.now();
        resultJalali = Jalali.now();
      }
    } else {
      // Input Greg -> Output Solar
      resultDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
      resultJalali = Jalali.fromDateTime(resultDate);
      dayName = _getDayName(resultDate.weekday);
    }

    final displayDate = _conversionType == 0
        ? '${resultDate.day} ${_gregorianMonths[resultDate.month - 1]} ${resultDate.year}'
        : '${resultJalali.day} ${_jalaliMonths[resultJalali.month - 1]} ${resultJalali.year}';

    final secondaryDate = _conversionType == 0
        ? '${resultJalali.day} ${_jalaliMonths[resultJalali.month - 1]} ${resultJalali.year}'
        : '${resultDate.day} ${_gregorianMonths[resultDate.month - 1]} ${resultDate.year}';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7F13EC), Color(0xFF4A0D8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          // Abstract BG
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                  decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage(
                      'https://lh3.googleusercontent.com/u/0/drive-viewer/AKGpihbP3qQzXkP-yK3P0J1KqC5D6z0P8X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9X0_3lK7TzX8P9X3qL9'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                ),
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تاریخ تبدیل شده',
                    style: GoogleFonts.vazirmatn(
                        color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(displayDate,
                        style: GoogleFonts.vazirmatn(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(dayName,
                        style: GoogleFonts.vazirmatn(
                            color: Colors.white, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(secondaryDate,
                        style: GoogleFonts.vazirmatn(
                            color: Colors.white70, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildResultInfoBox(
                            Icons.stars, 'نماد ماه', 'جوزا ♊️')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildResultInfoBox(
                            Icons.event_repeat, 'سال کبیسه', 'نیست')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultInfoBox(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 4),
          Text(label,
              style:
                  GoogleFonts.vazirmatn(color: Colors.white70, fontSize: 10)),
          Text(value,
              style: GoogleFonts.vazirmatn(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark, Color primary) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon:
                Icon(Icons.copy, color: isDark ? Colors.white : Colors.black87),
            label: Text('کپی',
                style: GoogleFonts.vazirmatn(
                    color: isDark ? Colors.white : Colors.black87)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? const Color(0xFF2A1E36) : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                      color: isDark ? Colors.white10 : Colors.grey.shade300)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.event_available, color: Colors.white),
            label: Text('افزودن به تقویم',
                style: GoogleFonts.vazirmatn(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              shadowColor: primary.withOpacity(0.4),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  String _getDayName(int weekday) {
    const days = [
      'دوشنبه',
      'سه‌شنبه',
      'چهارشنبه',
      'پنجشنبه',
      'جمعه',
      'شنبه',
      'یکشنبه'
    ];
    return days[weekday - 1];
  }
}
