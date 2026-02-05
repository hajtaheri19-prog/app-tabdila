import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'همه',
    'هوش مصنوعی',
    'مبدل‌ها',
    'زمان و تاریخ',
    'مالی و عمومی',
    'سلامت',
    'بازی',
    'فال',
    'کاربردی',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _shouldShowSection(int index) {
    if (_searchController.text.isNotEmpty) return true;
    if (_selectedCategoryIndex == 0) return true;
    return _selectedCategoryIndex == index;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF7F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isDark),

            // Category Filters
            _buildCategoryFilters(isDark),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    if (_shouldShowSection(1)) _buildAIToolsSection(isDark),
                    if (_shouldShowSection(2)) _buildConvertersSection(isDark),
                    if (_shouldShowSection(3)) _buildTimeDateSection(isDark),
                    if (_shouldShowSection(4)) _buildFinancialSection(isDark),
                    if (_shouldShowSection(5)) _buildHealthSection(isDark),
                    if (_shouldShowSection(6)) _buildGamesSection(isDark),
                    if (_shouldShowSection(7)) _buildFalSection(isDark),
                    if (_shouldShowSection(8)) _buildUtilitySection(isDark),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F0F0F).withOpacity(0.8)
            : const Color(0xFFF7F6F8).withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'جعبه ابزار تبدیلا',
                style: GoogleFonts.vazirmatn(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Row(
                children: [
                  _buildHeaderButton(Icons.history, isDark, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تاریخچه به زودی فعال می‌شود',
                            style: GoogleFonts.vazirmatn()),
                        backgroundColor: const Color(0xFF7F13EC),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  _buildHeaderButton(Icons.person, isDark, () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              textDirection: TextDirection.rtl,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'جستجو در ۱۰۰+ ابزار و مبدل...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, bool isDark, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.grey[400] : Colors.grey[700],
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(bool isDark) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: FilterChip(
              label: Text(
                _categories[index],
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              backgroundColor:
                  isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
              selectedColor: const Color(0xFF7F13EC),
              side: BorderSide(
                color:
                    isSelected ? const Color(0xFF7F13EC) : Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAIToolsSection(bool isDark) {
    return _buildSection(
      title: 'ابزارهای هوش مصنوعی',
      icon: Icons.auto_awesome,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildToolCard(
            icon: Icons.summarize,
            title: 'خلاصه‌ساز هوشمند',
            description: 'خلاصه متن با AI',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.summarizer),
          ),
          _buildToolCard(
            icon: Icons.gavel,
            title: 'دستیار حقوقی/مالی',
            description: 'چت‌بات هوای قوانین',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.legalChatbot),
          ),
          _buildToolCard(
            icon: Icons.post_add,
            title: 'تولید پست',
            description: 'محتوای شبکه‌های اجتماعی',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.socialPostGenerator),
          ),
          _buildToolCard(
            icon: Icons.document_scanner,
            title: 'OCR هوشمند',
            description: 'متن از عکس و PDF',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.ocrExtractor),
          ),
          _buildToolCard(
            icon: Icons.history_edu,
            title: 'مولد قرارداد',
            description: 'ساخت قرارداد هوشمند',
            isDark: isDark,
            isComingSoon: true,
          ),
          _buildToolCard(
            icon: Icons.picture_as_pdf,
            title: 'PDF به Word',
            description: 'تبدیل فرمت‌های متنی',
            isDark: isDark,
            isComingSoon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildConvertersSection(bool isDark) {
    return _buildSection(
      title: 'مبدل‌ها',
      icon: Icons.sync_alt,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildToolCard(
            icon: Icons.straighten,
            title: 'تبدیل واحد',
            description: 'طول، وزن، دما و...',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.unitConverter),
          ),
          _buildToolCard(
            icon: Icons.currency_exchange,
            title: 'ارزهای رایج',
            description: 'دلار، یورو و غیره',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.currencyConverter),
          ),
          _buildToolCard(
            icon: Icons.calendar_month,
            title: 'تبدیل تاریخ',
            description: 'شمسی، میلادی، قمری',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.dateConverter),
          ),
          _buildToolCard(
            icon: Icons.money,
            title: 'ریال و تومان',
            description: 'تبدیل سریع مبالغ',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.digitConverter),
          ),
          _buildToolCard(
            icon: Icons.text_fields,
            title: 'عدد به حروف',
            description: 'تبدیل اعداد به متن',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.numberToWords),
          ),
          _buildToolCard(
            icon: Icons.numbers,
            title: 'ارقام فارسی',
            description: 'تبدیل انگلیسی به فارسی',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.farsiDigitConverter),
          ),
          _buildToolCard(
            icon: Icons.code,
            title: 'متن و باینری',
            description: 'تبدیل متن به 0 و 1',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.binaryConverter),
          ),
          _buildToolCard(
            icon: Icons.exposure_zero,
            title: 'مبنای اعداد',
            description: 'دودویی، دهدهی، هگز',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.numberBaseConverter),
          ),
          _buildToolCard(
            icon: Icons.palette,
            title: 'مبدل رنگ',
            description: 'HEX, RGB, HSL',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.colorConverter),
          ),
          _buildToolCard(
            icon: Icons.security,
            title: 'Base64',
            description: 'تبدیل متن و فایل',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.base64Converter),
          ),
          _buildToolCard(
            icon: Icons.history_toggle_off,
            title: 'تایماستمپ',
            description: 'یونیکس به تاریخ',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.timestampConverter),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDateSection(bool isDark) {
    return _buildSection(
      title: 'زمان و تاریخ',
      icon: Icons.schedule,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildToolCard(
            icon: Icons.cake,
            title: 'محاسبه سن',
            description: 'دقیق بر اساس تولد',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.ageCalculator),
          ),
          _buildToolCard(
            icon: Icons.timer,
            title: 'کرنومتر',
            description: 'زمان‌سنج حرفه‌ای',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.stopwatch),
          ),
          _buildToolCard(
            icon: Icons.hourglass_bottom,
            title: 'تایمر معکوس',
            description: 'شمارش‌گر زمان',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.timer),
          ),
          _buildToolCard(
            icon: Icons.event_note,
            title: 'مناسبت‌ها',
            description: 'تعطیلات رسمی ایران',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.events),
          ),
          _buildToolCard(
            icon: Icons.public,
            title: 'ساعت ایران',
            description: 'زمان دقیق رسمی',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.worldClock),
          ),
          _buildToolCard(
            icon: Icons.alarm,
            title: 'زنگ هشدار',
            description: 'آلارم آنلاین هوشمند',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.alarm),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSection(bool isDark) {
    return _buildSection(
      title: 'محاسبات عمومی و مالی',
      icon: Icons.account_balance,
      isDark: isDark,
      child: Column(
        children: [
          _buildFinancialCard(
            icon: Icons.school,
            title: 'معدل‌سنج هوشمند',
            description: 'محاسبه معدل ترم و کل',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.gpaCalculator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.trending_up,
            title: 'نرخ بازار زنده',
            description: 'طلا، سکه، دلار و ارز دیجیتال',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.prices),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.calculate,
            title: 'محاسبه وام',
            description: 'اقساط، سود و دوره بازپرداخت',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.loanCalculator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.savings,
            title: 'سود سپرده',
            description: 'محاسبه سود بانکی ساده و مرکب',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.depositCalculator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.account_balance_wallet,
            title: 'محاسبه‌گر پس‌انداز',
            description: 'زمان رسیدن به هدف مالی',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.savingsCalculator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.percent,
            title: 'محاسبه درصد',
            description: 'درصد افزایش، کاهش و تخفیف',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.percentCalculator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.receipt_long,
            title: 'مالیات و ارزش افزوده',
            description: 'VAT و مالیات ثابت',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.vatCalculator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.auto_graph,
            title: 'تبدیل ارزش پول',
            description: 'بررسی قدرت خرید در زمان',
            isDark: isDark,
            isComingSoon: true,
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.menu_book,
            title: 'زمان مطالعه',
            description: 'تخمین زمان خواندن متن',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.readingTime),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.monetization_on,
            title: 'طلا و سکه',
            description: 'محاسبه‌گر فاکتور و حباب',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.goldDashboard),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.badge,
            title: 'اعتبارسنجی کد ملی',
            description: 'بررسی صحت و محل صدور کدملی',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.nationalIdValidator),
          ),
          _buildFinancialCard(
            icon: Icons.credit_card,
            title: 'اعتبارسنجی کارت بانکی',
            description: 'تشخیص بانک و صحت شماره کارت',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.bankCardValidator),
          ),
          const SizedBox(height: 12),
          _buildFinancialCard(
            icon: Icons.gavel,
            title: 'محاسبه حق‌الوکاله',
            description: 'تعرفه کانون وکلای دادگستری',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.attorneyFee),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildToolCardSimple(
                title: 'فاکتورساز',
                subtitle: 'صدور PDF',
                isDark: isDark,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.invoiceMaker),
              ),
              _buildToolCardSimple(
                title: 'مهریه',
                subtitle: 'نرخ روز',
                isDark: isDark,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.mahriehCalculator),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthSection(bool isDark) {
    return _buildSection(
      title: 'ورزش و سلامت',
      icon: Icons.fitness_center,
      isDark: isDark,
      child: Column(
        children: [
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHorizontalHealthCard(
                  icon: Icons.monitor_weight,
                  title: 'شاخص BMI',
                  description: 'توده بدنی و ایده‌آل',
                  isDark: isDark,
                  isHighlighted: true,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.bmiCalculator),
                ),
                const SizedBox(width: 12),
                _buildHorizontalHealthCard(
                  icon: Icons.timer,
                  title: 'زمان‌سنج تمرین',
                  description: 'حرفه‌ای و ایست‌دار',
                  isDark: isDark,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.workoutTimer),
                ),
                const SizedBox(width: 12),
                _buildHorizontalHealthCard(
                  icon: Icons.female,
                  title: 'سلامت بانوان',
                  description: 'تقویم قاعدگی',
                  isDark: isDark,
                  isComingSoon: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionSubTitle('تست‌های روانشناسی', isDark),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildToolCardSimple(
                title: 'تست افسردگی',
                subtitle: 'بک (BDI)',
                isDark: isDark,
              ),
              _buildToolCardSimple(
                title: 'میزان خوشبختی',
                subtitle: 'جامع',
                isDark: isDark,
              ),
              _buildToolCardSimple(
                title: 'اعتماد به نفس',
                subtitle: 'تست عزت نفس',
                isDark: isDark,
              ),
              _buildToolCardSimple(
                title: 'تست شنوایی',
                subtitle: 'بررسی سلامت گوش',
                isDark: isDark,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.hearingTestIntro),
              ),
              _buildToolCardSimple(
                title: 'تست بینایی',
                subtitle: 'سنجش چشم',
                isDark: isDark,
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.visionTestIntro),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGamesSection(bool isDark) {
    return _buildSection(
      title: 'سرگرمی و بازی',
      icon: Icons.sports_esports,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          _buildToolCard(
            icon: Icons.grid_4x4,
            title: 'چهار در یک ردیف',
            description: 'Connect Four',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.connectFour),
          ),
          _buildToolCard(
            icon: Icons.games,
            title: 'بازی سایمون',
            description: 'تکرار الگوی رنگ‌ها',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.simonSays),
          ),
          _buildToolCard(
            icon: Icons.lens,
            title: 'بازی اتللو',
            description: 'استراتژی مهره‌ها',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.othello),
          ),
          _buildToolCard(
            icon: Icons.extension,
            title: 'بازی حافظه',
            description: 'تقویت حافظه و تمرکز',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.memoryMatch),
          ),
          _buildToolCard(
            icon: Icons.dashboard,
            title: 'بازی 2048',
            description: 'اعتیادآور و جذاب',
            isDark: isDark,
          ),
          _buildToolCard(
            icon: Icons.view_list,
            title: 'همه بازی‌ها',
            description: 'لیست کامل بازی‌ها',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.games),
          ),
        ],
      ),
    );
  }

  Widget _buildFalSection(bool isDark) {
    return _buildSection(
      title: 'فال و طالع‌بینی',
      icon: Icons.auto_fix_high,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildToolCard(
            icon: Icons.menu_book,
            title: 'فال حافظ',
            description: 'نیت کنید و تفال بزنید',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.hafez),
          ),
          _buildToolCard(
            icon: Icons.auto_awesome,
            title: 'طالع‌بینی',
            description: 'بر اساس ماه تولد',
            isDark: isDark,
            isComingSoon: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUtilitySection(bool isDark) {
    return _buildSection(
      title: 'ابزارهای کاربردی',
      icon: Icons.category,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
        children: [
          _buildToolCard(
            icon: Icons.account_balance,
            title: 'شماره شبا',
            description: 'تبدیل کارت به شبا',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.ibanConverter),
          ),
          _buildToolCard(
            icon: Icons.badge,
            title: 'صحت کد ملی',
            description: 'اعتبارسنجی الگوریتمی',
            isDark: isDark,
          ),
          _buildToolCard(
            icon: Icons.link,
            title: 'کوتاه‌کننده',
            description: 'تبدیل لینک‌های طولانی',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.linkShortener),
          ),
          _buildToolCard(
            icon: Icons.directions_car,
            title: 'پلاک‌یاب',
            description: 'جستجوی شهر پلاک',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.plateFinder),
          ),
          _buildToolCard(
            icon: Icons.numbers,
            title: 'عدد تصادفی',
            description: 'قرعه‌کشی و شانس',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.randomNumber),
          ),
          _buildToolCard(
            icon: Icons.sync,
            title: 'قرعه‌کشی آنلاین',
            description: 'انتخاب رندوم برنده',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.raffle),
          ),
          _buildToolCard(
            icon: Icons.public,
            title: 'ساعت جهان',
            description: 'اختلاف زمانی شهرها',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.worldClock),
          ),
          _buildToolCard(
            icon: Icons.password,
            title: 'رمز عبور',
            description: 'امن و غیرقابل حدس',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.passwordGenerator),
          ),
          _buildToolCard(
            icon: Icons.qr_code,
            title: 'ساخت QR',
            description: 'لینک، متن، وای‌فای',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.qrGenerator),
          ),
          _buildToolCard(
            icon: Icons.qr_code_scanner,
            title: 'اسکن QR',
            description: 'خواندن سریع کد',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.qrScanner),
          ),
          _buildToolCard(
            icon: Icons.image,
            title: 'کاهش حجم',
            description: 'بهینه‌ساز تصاویر',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.imageCompressor),
          ),
          _buildToolCard(
            icon: Icons.text_snippet,
            title: 'تحلیلگر متن',
            description: 'تعداد کلمات و حروف',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.textAnalyzer),
          ),
          _buildToolCard(
            icon: Icons.functions,
            title: 'فاکتوریل',
            description: 'محاسبه !n',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.factorialCalculator),
          ),
          _buildToolCard(
            icon: Icons.calculate,
            title: 'جذر و توان',
            description: 'محاسبات ریاضی پایه',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.powerRootCalculator),
          ),
          _buildToolCard(
            icon: Icons.format_align_left,
            title: 'حذف فواصل اضافه',
            description: 'پاکسازی متن از فاصله‌های اضافی',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.removeSpaces),
          ),
          _buildToolCard(
            icon: Icons.map,
            title: 'مسافت شهرها',
            description: 'فاصله جاده‌ای دقیق',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.distanceCalculator),
          ),
          _buildToolCard(
            icon: Icons.draw,
            title: 'تولید امضا',
            description: 'طراحی امضای دیجیتال',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.digitalSignature),
          ),
          _buildToolCard(
            icon: Icons.settings_ethernet,
            title: 'IP و موقعیت',
            description: 'نمایش اطلاعات شبکه',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.ipInfo),
          ),
          _buildToolCard(
            icon: Icons.public,
            title: 'WHOIS دامنه',
            description: 'استعلام مالکیت دامنه',
            isDark: isDark,
            onTap: () => Navigator.pushNamed(context, AppRoutes.whoisLookup),
          ),
          _buildToolCard(
            icon: Icons.local_post_office,
            title: 'رهگیری پستی',
            description: 'استعلام مرسوله',
            isDark: isDark,
          ),
          _buildToolCard(
            icon: Icons.chat,
            title: 'لینک واتساپ',
            description: 'ارسال پیام بدون ذخیره',
            isDark: isDark,
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.whatsappLinkGenerator),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCardSimple({
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFD1D5DB).withOpacity(0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.vazirmatn(
                fontSize: 11,
                color: const Color(0xFF7F13EC),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSubTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        title,
        style: GoogleFonts.vazirmatn(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[400] : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required bool isDark,
    required Widget child,
    bool showViewAll = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF7F13EC), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.vazirmatn(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              if (showViewAll)
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'مشاهده همه',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7F13EC),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    bool isComingSoon = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isComingSoon ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFD1D5DB).withOpacity(0.5),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color:
                      isComingSoon ? Colors.grey[400] : const Color(0xFF7F13EC),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (isComingSoon)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F13EC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'بزودی',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    bool isComingSoon = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isComingSoon ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF2A2A2A)
                : const Color(0xFFD1D5DB).withOpacity(0.5),
          ),
        ),
        child: Opacity(
          opacity: isComingSoon ? 0.6 : 1.0,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isComingSoon
                      ? Colors.grey[400]!.withOpacity(0.1)
                      : const Color(0xFF7F13EC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color:
                      isComingSoon ? Colors.grey[400] : const Color(0xFF7F13EC),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.vazirmatn(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (isComingSoon) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F13EC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'بزودی',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.vazirmatn(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isComingSoon)
                Icon(
                  Icons.chevron_left,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalHealthCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
    bool isHighlighted = false,
    bool isComingSoon = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isComingSoon ? null : onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFF7F13EC).withOpacity(0.1)
              : (isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted
                ? const Color(0xFF7F13EC).withOpacity(0.2)
                : (isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFD1D5DB).withOpacity(0.5)),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color:
                      isComingSoon ? Colors.grey[400] : const Color(0xFF7F13EC),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.vazirmatn(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            if (isComingSoon)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7F13EC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'بزودی',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F0F0F).withOpacity(0.9)
            : const Color(0xFFF7F6F8).withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'خانه', false, isDark),
              _buildNavItem(Icons.grid_view, 'کاوشگر', true, isDark),
              _buildNavItem(
                Icons.favorite,
                'نشان‌شده‌ها',
                false,
                isDark,
                hasBadge: true,
              ),
              _buildNavItem(Icons.settings, 'تنظیمات', false, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    bool isDark, {
    bool hasBadge = false,
  }) {
    return GestureDetector(
      onTap: () {
        if (label == 'خانه') {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (label == 'تنظیمات') {
          Navigator.pushNamed(context, AppRoutes.settings);
        } else if (label == 'کاوشگر') {
          // Already on tools page
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF7F13EC) : Colors.grey[400],
                size: 24,
              ),
              if (hasBadge)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F13EC),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF0F0F0F)
                            : const Color(0xFFF7F6F8),
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF7F13EC) : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
