import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkShortenerPage extends StatefulWidget {
  const LinkShortenerPage({super.key});

  @override
  State<LinkShortenerPage> createState() => _LinkShortenerPageState();
}

class _LinkShortenerPageState extends State<LinkShortenerPage> {
  final TextEditingController _urlController = TextEditingController();
  String? _shortLink;
  bool _isLoading = false;

  final List<Map<String, String>> _recentLinks = [
    {
      'original': 'google.com/search?q=design',
      'short': 'tabdi.la/gD92',
      'time': '2m ago',
      'initial': 'G',
      'color': '0xFF1A73E8'
    },
    {
      'original': 'instagram.com/p/C8k...',
      'short': 'tabdi.la/iNs7',
      'time': '1h ago',
      'initial': 'I',
      'color': '0xFFE1306C'
    },
  ];

  void _shortenLink() {
    if (_urlController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _shortLink = "tabdi.la/x7K";
          _isLoading = false;
        });
      }
    });
  }

  void _copyLink(String link) {
    Clipboard.setData(ClipboardData(text: link));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF191022) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF261933) : Colors.white;
    final primaryColor = const Color(0xFF7F13EC);
    final mutedText = const Color(0xFFAD92C9);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(isDark, surfaceColor),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Section
                    Text(
                      'Paste your link',
                      style: GoogleFonts.inter(
                        color: mutedText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(primaryColor, surfaceColor, isDark),

                    const SizedBox(height: 24),

                    // Shorten Button
                    _buildShortenButton(primaryColor),

                    if (_shortLink != null) ...[
                      const SizedBox(height: 24),
                      _buildResultCard(
                          primaryColor, surfaceColor, mutedText, isDark),
                    ],

                    const SizedBox(height: 32),

                    // Analytics Preview
                    _buildAnalyticsHeader(primaryColor),
                    const SizedBox(height: 16),
                    _buildAnalyticsGrid(surfaceColor, mutedText, isDark),

                    const SizedBox(height: 32),

                    // Recent Links
                    _buildRecentLinksHeader(primaryColor),
                    const SizedBox(height: 16),
                    _buildRecentLinksList(
                        surfaceColor, mutedText, primaryColor),
                  ],
                ),
              ),
            ),

            // Bottom Bar
            _buildBottomBar(surfaceColor, primaryColor, mutedText, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark, Color surfaceColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.05),
              padding: const EdgeInsets.all(12),
            ),
          ),
          Text(
            'Link Shortener',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildInputField(Color primaryColor, Color surfaceColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4D3267)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        controller: _urlController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.link, color: Color(0xFFAD92C9)),
          hintText: 'https://example.com/very-long-url...',
          hintStyle: const TextStyle(color: Color(0xFFAD92C9)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildShortenButton(Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _shortenLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            else
              const Icon(Icons.auto_fix_high),
            const SizedBox(width: 12),
            Text(
              'Shorten Link',
              style:
                  GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(
      Color primaryColor, Color surfaceColor, Color mutedText, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4D3267)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SHORT LINK GENERATED',
                      style: GoogleFonts.inter(
                        color: mutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () =>
                          launchUrl(Uri.parse("https://${_shortLink!}")),
                      child: Row(
                        children: [
                          Text(
                            _shortLink!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.open_in_new,
                              color: primaryColor, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: "https://tabdi.la/x7K",
                  version: QrVersions.auto,
                  size: 48,
                  gapless: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSmallActionButton(
                  icon: Icons.content_copy,
                  label: 'Copy',
                  onTap: () => _copyLink(_shortLink!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSmallActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: () => Share.share("Short link: https://$_shortLink"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsHeader(Color primaryColor) {
    return Row(
      children: [
        Icon(Icons.analytics, color: primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          'Analytics Preview',
          style: GoogleFonts.inter(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAnalyticsGrid(Color surfaceColor, Color mutedText, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildAnalyticsCard(
          title: 'Total Clicks',
          value: '1,428',
          trend: '+12% this week',
          icon: Icons.ads_click,
          surfaceColor: surfaceColor,
          mutedText: mutedText,
        ),
        _buildAnalyticsCard(
          title: 'Top Location',
          value: 'Tehran',
          trend: '45% of traffic',
          icon: Icons.public,
          surfaceColor: surfaceColor,
          mutedText: mutedText,
          isGlobe: true,
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required Color surfaceColor,
    required Color mutedText,
    bool isGlobe = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4D3267)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, color: Colors.white.withOpacity(0.05), size: 80),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                    color: mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(isGlobe ? Icons.arrow_upward : Icons.trending_up,
                          color: const Color(0xFF0BDA73), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        trend,
                        style: GoogleFonts.inter(
                            color: const Color(0xFF0BDA73),
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLinksHeader(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Links',
          style: GoogleFonts.inter(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text('View All',
              style: GoogleFonts.inter(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }

  Widget _buildRecentLinksList(
      Color surfaceColor, Color mutedText, Color primaryColor) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentLinks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final link = _recentLinks[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: surfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF4D3267).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(link['color']!)),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    link['initial']!,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link['original']!,
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      link['short']!,
                      style:
                          GoogleFonts.inter(color: primaryColor, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                link['time']!,
                style: GoogleFonts.inter(color: mutedText, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(
      Color surfaceColor, Color primaryColor, Color mutedText, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
            top: BorderSide(color: const Color(0xFF4D3267).withOpacity(0.5))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBottomNavItem(
              Icons.home, 'Home', true, primaryColor, mutedText),
          _buildBottomNavItem(
              Icons.history, 'History', false, primaryColor, mutedText),
          Transform.translate(
            offset: const Offset(0, -20),
            child: _buildFab(primaryColor),
          ),
          _buildBottomNavItem(
              Icons.bar_chart, 'Stats', false, primaryColor, mutedText),
          _buildBottomNavItem(
              Icons.person, 'Profile', false, primaryColor, mutedText),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isActive,
      Color primaryColor, Color mutedText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? primaryColor : mutedText, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: isActive ? primaryColor : mutedText,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFab(Color primaryColor) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFF191022), width: 4),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }
}
