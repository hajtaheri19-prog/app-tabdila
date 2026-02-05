import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import '../../../../core/utils/digit_utils.dart';

class Course {
  String name;
  double? grade; // Changed to double? to handle cases with no grade
  int? units;

  Course({this.name = '', this.grade, this.units});
}

class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});

  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  final List<Course> _courses = [
    Course(),
  ];

  double get _totalGpa {
    List<Course> validCourses =
        _courses.where((c) => c.grade != null && c.units != null).toList();
    if (validCourses.isEmpty) return 0;
    double weightedSum = 0;
    int totalUnits = 0;
    for (var course in validCourses) {
      weightedSum += course.grade! * course.units!;
      totalUnits += course.units!;
    }
    return totalUnits == 0 ? 0 : weightedSum / totalUnits;
  }

  int get _totalUnits {
    // Only count units for courses that have a grade and valid units
    return _courses
        .where((c) => c.grade != null && c.units != null)
        .fold(0, (sum, item) => sum + item.units!);
  }

  String _getGpaStatus(double gpa) {
    if (gpa >= 17) return 'عالی';
    if (gpa >= 15) return 'خوب';
    if (gpa >= 12) return 'متوسط';
    return 'مشروط';
  }

  Color _getStatusColor(double gpa) {
    if (gpa >= 17) return const Color(0xFF10B981);
    if (gpa >= 15) return const Color(0xFF7F13EC);
    if (gpa >= 12) return Colors.orange;
    return Colors.red;
  }

  void _addCourse() {
    setState(() {
      _courses.add(Course());
    });
  }

  void _removeCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      _courses.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);
    const borderColor = Color(0xFF4D3267);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'معدلسنج هوشمند',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      // Calculation Formula Guide
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: primaryColor.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'فرمول: مجموع (نمره × واحد) ÷ مجموع واحدها. درس‌های حذف‌شده را وارد نکنید یا سطر آن‌ها را حذف کنید.',
                                style: GoogleFonts.vazirmatn(
                                  fontSize: 11,
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ترم جاری (۱۴۰۳-۱۴۰۴)',
                            style: GoogleFonts.vazirmatn(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: _clearAll,
                            child: Row(
                              children: [
                                Text(
                                  'پاک‌کردن همه',
                                  style: GoogleFonts.vazirmatn(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.delete_sweep,
                                    color: primaryColor, size: 18),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 140),
                    itemCount: _courses.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _courses.length) {
                        return _buildAddButton(primaryColor);
                      }
                      return _buildCourseCard(index, isDark, surfaceDark,
                          primaryColor, borderColor);
                    },
                  ),
                ),
              ],
            ),
            _buildFloatingResultCard(isDark, surfaceDark, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(
      int index, bool isDark, Color surface, Color primary, Color border) {
    final course = _courses[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark
                ? border.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('نام درس'),
              _buildNameInput(index, isDark, surface, course),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('نمره (۰-۲۰)'),
                        _buildGradeInput(index, isDark, surface, course),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('تعداد واحد'),
                        _buildUnitInput(index, isDark, surface, course),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => _removeCourse(index),
              child: const Icon(Icons.delete_outline,
                  color: Colors.redAccent, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, right: 4),
      child: Text(
        text,
        style: GoogleFonts.vazirmatn(
            fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildNameInput(int index, bool isDark, Color surface, Course course) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: (v) => course.name = v,
        controller: TextEditingController(text: course.name)
          ..selection = TextSelection.collapsed(offset: course.name.length),
        style: GoogleFonts.vazirmatn(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'مثال: فیزیک',
          hintStyle: GoogleFonts.vazirmatn(color: Colors.grey, fontSize: 13),
          prefixIcon: const Icon(Icons.menu_book, color: Colors.grey, size: 18),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildGradeInput(
      int index, bool isDark, Color surface, Course course) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (v) {
          setState(() {
            course.grade = v.isEmpty ? null : double.tryParse(v);
          });
        },
        controller: TextEditingController(
            text: course.grade == null ? '' : course.grade.toString())
          ..selection = TextSelection.collapsed(
              offset:
                  course.grade == null ? 0 : course.grade.toString().length),
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: '0',
          prefixIcon:
              const Icon(Icons.grade_outlined, color: Colors.grey, size: 18),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildUnitInput(int index, bool isDark, Color surface, Course course) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (v) {
          setState(() {
            course.units = v.isEmpty ? null : int.tryParse(v);
          });
        },
        controller: TextEditingController(
            text: course.units == null ? '' : course.units.toString())
          ..selection = TextSelection.collapsed(
              offset:
                  course.units == null ? 0 : course.units.toString().length),
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintText: '0',
          prefixIcon:
              const Icon(Icons.layers_outlined, color: Colors.grey, size: 18),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAddButton(Color primary) {
    return GestureDetector(
      onTap: _addCourse,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: primary.withOpacity(0.4),
              width: 2,
              style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: primary),
            const SizedBox(width: 8),
            Text(
              'افزودن درس جدید',
              style: GoogleFonts.vazirmatn(
                  color: primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingResultCard(bool isDark, Color surface, Color primary) {
    final gpa = _totalGpa;
    final status = _getGpaStatus(gpa);
    final statusColor = _getStatusColor(gpa);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              isDark ? const Color(0xFF191022) : Colors.white.withOpacity(0.8),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? surface : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, -5),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'وضعیت کل ترم',
                    style:
                        GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        DigitUtils.toFarsi(gpa.toStringAsFixed(2)),
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.vazirmatn(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'مجموع واحد: ${DigitUtils.toFarsi(_totalUnits.toString())}',
                    style:
                        GoogleFonts.vazirmatn(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: gpa / 20,
                      strokeWidth: 6,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      color: primary,
                    ),
                  ),
                  Icon(Icons.school, color: primary, size: 28),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
