import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/providers/app_provider.dart';
import '../../../../core/models/price_model.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/price_action_card.dart';
import '../widgets/market_index_card.dart';
import '../widgets/global_market_card.dart';

class PricesPage extends StatefulWidget {
  const PricesPage({super.key});

  @override
  State<PricesPage> createState() => _PricesPageState();
}

class _PricesPageState extends State<PricesPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'همه',
    'طلا و سکه',
    'ارزها',
    'بورس',
    'جهانی',
    'ارز دیجیتال',
  ];

  @override
  void initState() {
    super.initState();
    // Trigger refresh when page opens to ensure fresh data if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadPrices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatNumber(double number) {
    final formatter = intl.NumberFormat("#,##0.##", "en_US");
    return _toPersianDigits(formatter.format(number));
  }

  String _toPersianDigits(String text) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < english.length; i++) {
      text = text.replaceAll(english[i], persian[i]);
    }
    return text;
  }

  Price? _findPrice(List<Price> prices, String id) {
    try {
      return prices.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final prices = provider.prices;
          List<Price> _getFilteredPrices(List<Price> allPrices) {
            if (_selectedCategoryIndex == 0) return allPrices; // همه

            // Define category filters
            final goldCoins = [
              'coin_emami',
              'gold_18',
              'gold_mithqal',
              'gold_ounce'
            ];
            final currencies = ['usd', 'eur', 'aed', 'try'];
            final stock = ['stock'];
            final global = ['gold_ounce', 'oil', 'sp500'];
            final crypto = ['bitcoin', 'ethereum', 'tether'];

            switch (_selectedCategoryIndex) {
              case 1: // طلا و سکه
                return allPrices
                    .where((p) => goldCoins.contains(p.id))
                    .toList();
              case 2: // ارزها
                return allPrices
                    .where((p) => currencies.contains(p.id))
                    .toList();
              case 3: // بورس
                return allPrices.where((p) => stock.contains(p.id)).toList();
              case 4: // جهانی
                return allPrices.where((p) => global.contains(p.id)).toList();
              case 5: // ارز دیجیتال
                return allPrices.where((p) => crypto.contains(p.id)).toList();
              default:
                return allPrices;
            }
          }

          final filteredPrices = _getFilteredPrices(prices);

          final stock = _findPrice(filteredPrices, 'stock');
          final coin = _findPrice(filteredPrices, 'coin_emami');
          final gold18 = _findPrice(filteredPrices, 'gold_18');
          final goldMithqal = _findPrice(filteredPrices, 'gold_mithqal');
          final usd = _findPrice(filteredPrices, 'usd');
          final tether = _findPrice(filteredPrices, 'tether');
          final bitcoin = _findPrice(filteredPrices, 'bitcoin');
          final goldOunce = _findPrice(filteredPrices, 'gold_ounce');

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => provider.loadPrices(),
              child: Column(
                children: [
                  _buildHeader(isDark, provider),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildSearchBar(isDark),
                          const SizedBox(height: 16),
                          _buildLastUpdate(isDark, provider.lastUpdate),
                          const SizedBox(height: 16),
                          _buildCategories(isDark),
                          const SizedBox(height: 16),
                          if (stock != null)
                            MarketIndexCard(
                              title: 'شاخص کل بورس',
                              value: _formatNumber(stock.value),
                              change:
                                  '${stock.isPositive ? '+' : ''}${_formatNumber(stock.change)} (${_formatNumber(stock.changePercent)}٪)',
                              isPositive: stock.isPositive,
                              volLabel: 'وضعیت',
                              volValue: 'باز', // Placeholder as not in scraping
                              valLabel: 'زمان',
                              valValue: _formatTime(stock.lastUpdate),
                            ),
                          const SizedBox(height: 32),
                          _buildSectionHeader('طلا و سکه', isDark),
                          const SizedBox(height: 12),
                          if (coin != null)
                            PriceActionCard(
                              icon: Icons.circle,
                              title: 'سکه امامی',
                              subtitle: 'طرح جدید',
                              price: _formatNumber(coin.value),
                              change: '${_formatNumber(coin.changePercent)}٪',
                              isPositive: coin.isPositive,
                              sparklineData: const [
                                25,
                                22,
                                28,
                                15,
                                18,
                                8,
                                12,
                                5,
                                10
                              ], // Placeholder sparkline
                              iconColor: const Color(0xFFFFD700),
                            ),
                          const SizedBox(height: 12),
                          if (gold18 != null)
                            PriceActionCard(
                              icon: Icons.diamond_outlined,
                              title: 'طلا ۱۸ عیار',
                              subtitle: 'گرم',
                              price: _formatNumber(gold18.value),
                              change: '${_formatNumber(gold18.changePercent)}٪',
                              isPositive: gold18.isPositive,
                              sparklineData: const [10, 15, 12, 22, 18, 28],
                              iconColor: const Color(0xFFFFD700),
                            ),
                          const SizedBox(height: 12),
                          if (goldMithqal != null)
                            PriceActionCard(
                              icon: Icons.scale,
                              title: 'مثقال طلا',
                              subtitle: 'مظنه',
                              price: _formatNumber(goldMithqal.value),
                              change:
                                  '${_formatNumber(goldMithqal.changePercent)}٪',
                              isPositive: goldMithqal.isPositive,
                              sparklineData: const [20, 18, 22, 12, 15, 5],
                              iconColor: const Color(0xFFFFD700),
                            ),
                          const SizedBox(height: 32),
                          _buildSectionHeader('ارزها', isDark),
                          const SizedBox(height: 12),
                          if (usd != null)
                            PriceActionCard(
                              icon: Icons.attach_money,
                              title: 'دلار',
                              subtitle: 'بازار آزاد',
                              price: _formatNumber(usd.value),
                              change: '${_formatNumber(usd.changePercent)}٪',
                              isPositive: usd.isPositive,
                              sparklineData: const [20, 18, 22, 5, 15],
                              iconColor: Colors.green,
                            ),
                          const SizedBox(height: 12),
                          if (tether != null)
                            PriceActionCard(
                              icon: Icons.currency_bitcoin,
                              title: 'تتر (USDT)',
                              subtitle: 'استیبل‌کوین',
                              price: _formatNumber(tether.value),
                              change: '${_formatNumber(tether.changePercent)}٪',
                              isPositive: tether.isPositive,
                              sparklineData: const [16, 15, 17, 16, 16],
                              iconColor: const Color(0xFF10B981),
                            ),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            'بازارهای جهانی',
                            isDark,
                            showViewAll: false,
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                            children: [
                              if (goldOunce != null)
                                GlobalMarketCard(
                                  icon: Icons.monetization_on_outlined,
                                  title: 'انس طلا',
                                  price: '\$${_formatNumber(goldOunce.value)}',
                                  change:
                                      '${goldOunce.isPositive ? '+' : ''}${_formatNumber(goldOunce.changePercent)}٪',
                                  isPositive: goldOunce.isPositive,
                                  sparklineData: const [25, 20, 22, 10, 12, 5],
                                  iconColor: Colors.amber,
                                ),
                              if (bitcoin != null)
                                GlobalMarketCard(
                                  icon: Icons.currency_bitcoin,
                                  title: 'بیت‌کوین',
                                  price: '\$${_formatNumber(bitcoin.value)}',
                                  change:
                                      '${bitcoin.isPositive ? '+' : ''}${_formatNumber(bitcoin.changePercent)}٪',
                                  isPositive: bitcoin.isPositive,
                                  sparklineData: const [5, 8, 15, 25, 20, 28],
                                  iconColor: Colors.orange,
                                ),
                            ],
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
        },
      ),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  String _formatTime(DateTime date) {
    return _toPersianDigits(intl.DateFormat('HH:mm').format(date));
  }

  Widget _buildHeader(bool isDark, AppProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF191022).withOpacity(0.8)
            : const Color(0xFFF7F6F8).withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu),
          Text(
            'قیمت‌های لحظه‌ای',
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: provider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
            onPressed: () => provider.loadPrices(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1B38) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'جستجو در ارزها، طلا یا نمادها...',
          hintStyle: GoogleFonts.vazirmatn(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildLastUpdate(bool isDark, DateTime? lastUpdate) {
    String timeString = '...';
    if (lastUpdate != null) {
      final jalali = Jalali.fromDateTime(lastUpdate);
      final f = jalali.formatter;
      timeString =
          '${f.d} ${f.mN} ${f.yyyy}، ساعت ${_formatNumber(lastUpdate.hour.toDouble()).split('.')[0].padLeft(2, '۰')}:${_formatNumber(lastUpdate.minute.toDouble()).split('.')[0].padLeft(2, '۰')}';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF10B981),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'آخرین بروزرسانی: $timeString',
          style: GoogleFonts.vazirmatn(
            fontSize: 12,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(bool isDark) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF7F13EC)
                      : (isDark
                          ? const Color(0xFF2A1B38)
                          : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.transparent),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  _categories[index],
                  style: GoogleFonts.vazirmatn(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF334155)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    bool isDark, {
    bool showViewAll = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        if (showViewAll)
          TextButton(
            onPressed: () {},
            child: Text(
              'مشاهده همه',
              style: GoogleFonts.vazirmatn(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF7F13EC),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF191022).withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'خانه', false, isDark),
              _buildNavItem(Icons.insights, 'بازارها', true, isDark),
              const SizedBox(width: 48), // Space for center button
              _buildNavItem(Icons.wallet, 'دارایی‌ها', false, isDark,
                  isComingSoon: true),
              _buildNavItem(Icons.history, 'تاریخچه', false, isDark),
            ],
          ),
          Positioned(
            top: -24,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.tools);
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7F13EC),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF191022)
                              : const Color(0xFFF7F6F8),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7F13EC).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.settings_suggest,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ابزارها',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    bool isDark, {
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: isComingSoon
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('این قابلیت به زودی فعال می‌شود',
                      style: GoogleFonts.vazirmatn()),
                  backgroundColor: const Color(0xFF7F13EC),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          : () {
              if (label == 'خانه') {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              } else if (label == 'تاریخچه') {
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
              }
            },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isSelected ? const Color(0xFF7F13EC) : const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.vazirmatn(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF7F13EC)
                  : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
