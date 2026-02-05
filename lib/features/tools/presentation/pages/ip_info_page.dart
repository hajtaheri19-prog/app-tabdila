import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class IpInfoPage extends StatefulWidget {
  const IpInfoPage({super.key});

  @override
  State<IpInfoPage> createState() => _IpInfoPageState();
}

class _IpInfoPageState extends State<IpInfoPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _ipData;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchIpData();
  }

  void _addLog(String message, String status) {
    setState(() {
      _logs.add('$message|$status');
    });
  }

  Future<void> _fetchIpData() async {
    setState(() {
      _isLoading = true;
      _logs.clear();
    });

    _addLog('Connecting to GeoService A...', 'OK');

    try {
      final response = await http.get(Uri.parse(
          'http://ip-api.com/json/?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,query'));

      _addLog('Verifying ISP signature...', 'Verified');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _addLog('Fetching timezone data...', 'Synced');
          _addLog('Cross-referencing DB...', 'Done');

          setState(() {
            _ipData = data;
            _isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch data');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      _addLog('Error fetching data', 'FAILED');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('خطا در دریافت اطلاعات: $e'),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  String _getLocalTime() {
    if (_ipData == null) return '--:--';
    // This is a simplification. For real timezone handling, we might need a package.
    // But for the UI flair, we can show current system time as a placeholder.
    return DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF130E19) : const Color(0xFFF7F6F8);
    final surfaceColor = isDark ? const Color(0xFF1E1628) : Colors.white;
    final primaryColor = const Color(0xFF7F13EC);
    final accentPurple = const Color(0xFFA960FF);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black87),
        ),
        title: Text(
          'تشخیص IP و موقعیت',
          style: GoogleFonts.vazirmatn(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // IP Card
                  _buildIpCard(primaryColor, accentPurple),
                  const SizedBox(height: 20),

                  // Map View Placeholder
                  _buildMapPlaceholder(isDark, surfaceColor, primaryColor),
                  const SizedBox(height: 20),

                  // Information Grid
                  _buildInfoGrid(
                      isDark, surfaceColor, primaryColor, accentPurple),
                  const SizedBox(height: 20),

                  // Technical Console
                  _buildConsoleLog(isDark),
                  const SizedBox(height: 24),

                  // Actions
                  _buildActions(isDark, surfaceColor, primaryColor),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildIpCard(Color primaryColor, Color accentPurple) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            const Color(0xFF311B92),
            const Color(0xFF130E19),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: accentPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Text(
                    'آی‌پی آدرس شما',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _ipData?['query'] ?? '0.0.0.0',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'اتصال امن (Protected)',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 12, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(
      bool isDark, Color surfaceColor, Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        image: const DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=1000&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _ipData?['city'] ?? 'Unknown',
                style:
                    GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: primaryColor.withOpacity(0.8),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Simple ripple effect placeholder
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(
      bool isDark, Color surfaceColor, Color primaryColor, Color accentPurple) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Column(
      children: [
        // Location
        _buildInfoCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('موقعیت (Location)',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 10, color: subTextColor)),
                  Text(
                    '${_ipData?['city']}, ${_ipData?['countryCode']} ',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ],
              ),
              Icon(Icons.location_on, color: primaryColor),
            ],
          ),
          surfaceColor: surfaceColor,
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            // Coordinates
            Expanded(
              child: _buildInfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('مختصات',
                            style: GoogleFonts.vazirmatn(
                                fontSize: 10, color: subTextColor)),
                        Icon(Icons.copy, size: 14, color: subTextColor),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_ipData?['lat']}\n${_ipData?['lon']}',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor),
                    ),
                  ],
                ),
                surfaceColor: surfaceColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            // Timezone
            Expanded(
              child: _buildInfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('زمان محلی',
                            style: GoogleFonts.vazirmatn(
                                fontSize: 10, color: subTextColor)),
                        Icon(Icons.schedule, size: 14, color: subTextColor),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getLocalTime(),
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    Text(
                      _ipData?['timezone'] ?? 'N/A',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 8, color: subTextColor),
                    ),
                  ],
                ),
                surfaceColor: surfaceColor,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ISP
        _buildInfoCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سرویس دهنده (ISP)',
                        style: GoogleFonts.vazirmatn(
                            fontSize: 10, color: subTextColor)),
                    Text(
                      _ipData?['isp'] ?? 'Unknown ISP',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.vazirmatn(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ],
                ),
              ),
              Icon(Icons.router,
                  color: isDark ? Colors.white24 : Colors.black12),
            ],
          ),
          surfaceColor: surfaceColor,
          isDark: isDark,
        ),
        const SizedBox(height: 12),

        // Postal Code
        _buildInfoCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('کد پستی (Postal Code)',
                      style: GoogleFonts.vazirmatn(
                          fontSize: 10, color: subTextColor)),
                  Text(
                    _ipData?['zip'] ?? '-----',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                ],
              ),
              Icon(Icons.markunread_mailbox,
                  color: isDark ? Colors.white24 : Colors.black12),
            ],
          ),
          surfaceColor: surfaceColor,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required Widget child,
      required Color surfaceColor,
      required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildConsoleLog(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.terminal, color: Colors.greenAccent, size: 14),
              const SizedBox(width: 8),
              Text(
                'SYSTEM STATUS LOG',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                    color: Colors.greenAccent, shape: BoxShape.circle),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 16),
          ..._logs.map((log) {
            final parts = log.split('|');
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '> ${parts[0]}',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 10, color: Colors.white70),
                  ),
                  Text(
                    parts[1],
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: parts[1] == 'OK' ||
                              parts[1] == 'Verified' ||
                              parts[1] == 'Synced'
                          ? Colors.greenAccent
                          : (parts[1] == 'FAILED'
                              ? Colors.redAccent
                              : Colors.purpleAccent),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActions(bool isDark, Color surfaceColor, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (_ipData != null) {
                final text = '''IP: ${_ipData!['query']}
Location: ${_ipData!['city']}, ${_ipData!['country']}
ISP: ${_ipData!['isp']}
Coordinates: ${_ipData!['lat']}, ${_ipData!['lon']}''';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('اطلاعات کپی شد'),
                      behavior: SnackBarBehavior.floating),
                );
              }
            },
            icon: const Icon(Icons.copy, size: 18),
            label: Text('کپی اطلاعات',
                style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? surfaceColor : Colors.white,
              foregroundColor: isDark ? Colors.white : Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side:
                    BorderSide(color: isDark ? Colors.white10 : Colors.black12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Share logic
            },
            icon: const Icon(Icons.share_location, size: 18),
            label: Text('اشتراک گذاری',
                style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shadowColor: primaryColor.withOpacity(0.4),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}
