import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['رسمی', 'مذهبی', 'باستانی', 'جهانی'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final primaryColor = const Color(0xFF7311D4);
    final accentRed = const Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: backgroundColor,
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
                  ),
                  Text(
                    'مناسبت‌ها و تعطیلات',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
            ),

            // Filters
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedFilterIndex;
                  return Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primaryColor
                              : (isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.grey[200]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4))
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _filters[index],
                          style: GoogleFonts.vazirmatn(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Main Content Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Calendar Section
                    _buildCalendarCard(isDark, primaryColor, accentRed),
                    const SizedBox(height: 24),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'رویدادهای این ماه',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87),
                        ),
                        Text(
                          'مشاهده همه',
                          style: GoogleFonts.vazirmatn(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Events List
                    _buildEventCard(
                      isDark: isDark,
                      accentColor: accentRed, // Holiday Red
                      day: '۰۱',
                      weekday: 'چهارشنبه',
                      title: 'عید نوروز',
                      tagLabel: 'تعطیل رسمی',
                      tagColor: accentRed,
                      desc: 'آغاز سال ۱۴۰۳ شمسی',
                      isHoliday: true,
                    ),
                    const SizedBox(height: 12),
                    _buildEventCard(
                      isDark: isDark,
                      accentColor: accentRed,
                      day: '۱۳',
                      weekday: 'دوشنبه',
                      title: 'روز طبیعت',
                      tagLabel: 'تعطیل رسمی',
                      tagColor: accentRed,
                      desc: 'سیزده بدر',
                      isHoliday: true,
                    ),
                    const SizedBox(height: 12),
                    _buildEventCard(
                      isDark: isDark,
                      accentColor: Colors.grey, // Neutral
                      day: '۲۰',
                      weekday: 'دوشنبه',
                      title: 'روز ملی فناوری هسته‌ای',
                      tagLabel: 'مناسبت ملی',
                      tagColor: Colors.grey,
                      desc: '',
                      isHoliday: false,
                    ),
                    const SizedBox(height: 12),
                    _buildEventCard(
                      isDark: isDark,
                      accentColor: primaryColor, // Recursive
                      day: '۲۳',
                      weekday: 'پنجشنبه',
                      title: 'عید سعید فطر',
                      tagLabel: 'مذهبی',
                      tagColor: primaryColor,
                      desc: 'پایان ماه رمضان',
                      isHoliday: false,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard(bool isDark, Color primary, Color accentRed) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF251A30) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Month Navigator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_right,
                      color: isDark ? Colors.grey[400] : Colors.grey[600])),
              Column(
                children: [
                  Text(
                    'فروردین ۱۴۰۳',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  Text(
                    'March - April',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                        letterSpacing: 1.5),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_left,
                      color: isDark ? Colors.grey[400] : Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 16),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 7 + 3 + 31, // Header + Empty + Days
            itemBuilder: (context, index) {
              // Header
              if (index < 7) {
                final days = ['ش', '۱ش', '۲ش', '۳ش', '۴ش', '۵ش', 'ج'];
                return Center(
                  child: Text(
                    days[index],
                    style: GoogleFonts.vazirmatn(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: index == 6
                          ? accentRed.withOpacity(0.7)
                          : (isDark ? Colors.white38 : Colors.black38),
                    ),
                  ),
                );
              }

              final cellIndex = index - 7;
              // Empty cells (assuming month starts on Tuesday)
              // Actually based on design: 1st is Wednesday (index 3 in 0-6 sat-fri range: Sat=0, Sun=1, Mon=2, Tue=3, Wed=4)
              // Wait, the design shows 1st under "۴ش" (Wednesday).
              // So 0:Sat, 1:Sun, 2:Mon, 3:Tue are empty.
              // That means 4 empty cells.
              // Design shows 3 empty cells? Let's look closer at Screenshot/Code.
              // "Empty Slots for prev month ... 3 spans".
              // So 1st is on Tuesday? No, Code says 1st is Wednesday.
              // Let's stick to the visual: 1st is under 4th day index (Wed).
              // Indexes: 0(Sat), 1(Sun), 2(Mon), 3(Tue), 4(Wed).
              // If there are 3 empty slots, then day 1 is at index 3 (Tuesday).
              // Let's refine based on the "Event Card" saying "01 Wednesday".
              // So 1st is Wednesday.
              // Sat, Sun, Mon, Tue -> 4 empty slots.
              // I'll adjust empty slots to match.

              const emptySlots = 4; // Sat, Sun, Mon, Tue
              if (cellIndex < emptySlots) return const SizedBox();

              final day = cellIndex - emptySlots + 1;
              if (day > 31) return const SizedBox();

              // Special styling for holidays (Fridays + 1, 2, 3, 4, 12, 13 etc)
              // Fridays are at index where (index % 7) == 6 (Jomeh)
              final isFriday = (index % 7) == 6;
              final isHoliday = isFriday ||
                  [1, 2, 3, 4, 12, 13].contains(day); // Based on visual

              final isSelected = day == 5; // Example selected

              return Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                                color: primary.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4))
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '$day',
                          style: GoogleFonts.vazirmatn(
                            fontSize: 14,
                            fontWeight: isSelected || isHoliday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isHoliday
                                    ? accentRed
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black87)),
                          ),
                        ),
                        if (isHoliday && !isSelected)
                          Positioned(
                            bottom: 2,
                            child: Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: accentRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required bool isDark,
    required Color accentColor,
    required String day,
    required String weekday,
    required String title,
    required String tagLabel,
    required Color tagColor,
    required String desc,
    required bool isHoliday,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF251A30) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: 4,
              color: accentColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Date Box
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: accentColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: GoogleFonts.vazirmatn(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            height: 1),
                      ),
                      Text(
                        weekday,
                        style: GoogleFonts.vazirmatn(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: accentColor.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: tagColor.withOpacity(0.2), width: 0.5),
                            ),
                            child: Text(
                              tagLabel,
                              style: GoogleFonts.vazirmatn(
                                fontSize: 10,
                                color: tagColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (desc.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                desc,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Notif Button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.grey[400],
                    size: 20,
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
