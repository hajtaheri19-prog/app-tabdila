import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class WhoisResultsPage extends StatefulWidget {
  final String domain;
  const WhoisResultsPage({super.key, required this.domain});

  @override
  State<WhoisResultsPage> createState() => _WhoisResultsPageState();
}

class _WhoisResultsPageState extends State<WhoisResultsPage> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetchWhoisData();
  }

  Future<void> _fetchWhoisData() async {
    if (kIsWeb) {
      // Show mock data for web due to CORS restrictions
      setState(() {
        _data = {
          'ldhName': widget.domain,
          'events': [
            {
              'eventAction': 'registration',
              'eventDate': '2020-01-15T00:00:00Z'
            },
            {'eventAction': 'expiration', 'eventDate': '2026-01-15T00:00:00Z'},
          ],
          'entities': [
            {
              'roles': ['registrar'],
              'vcardArray': [
                'vcard',
                [
                  ['fn', {}, 'text', 'Example Registrar Inc.']
                ]
              ]
            }
          ],
          'nameservers': [
            {'ldhName': 'ns1.example.com'},
            {'ldhName': 'ns2.example.com'}
          ]
        };
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'در نسخه وب، اطلاعات نمونه نمایش داده می‌شود. برای اطلاعات واقعی از نسخه دسکتاپ استفاده کنید.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    try {
      final response =
          await http.get(Uri.parse('https://rdap.org/domain/${widget.domain}'));

      if (response.statusCode == 200) {
        setState(() {
          _data = json.decode(response.body);
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _error = 'دامنه یافت نشد. لطفاً نام دامنه را بررسی کنید.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'خطا در دریافت اطلاعات. لطفاً دوباره تلاش کنید.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'خطای شبکه. لطفا اتصال اینترنت خود را بررسی کنید.';
        _isLoading = false;
      });
    }
  }

  String _getRegistryValue(String key) {
    if (_data == null) return 'نامشخص';

    final events = _data!['events'] as List<dynamic>?;
    if (events != null) {
      for (var event in events) {
        if (event['eventAction'] == key) {
          return (event['eventDate'] as String).split('T').first;
        }
      }
    }

    if (key == 'registration' && _data!['registrationDate'] != null)
      return _data!['registrationDate'].toString().split('T').first;
    if (key == 'expiration' && _data!['expirationDate'] != null)
      return _data!['expirationDate'].toString().split('T').first;

    return 'نامشخص';
  }

  String _getRegistrar() {
    if (_data == null) return 'نامشخص';
    final entities = _data!['entities'] as List<dynamic>?;
    if (entities != null) {
      for (var entity in entities) {
        final roles = entity['roles'] as List<dynamic>?;
        if (roles != null && roles.contains('registrar')) {
          final vcard = entity['vcardArray'] as List<dynamic>?;
          if (vcard != null && vcard.length > 1) {
            final props = vcard[1] as List<dynamic>?;
            if (props != null) {
              for (var prop in props) {
                if (prop[0] == 'fn') return prop[3].toString();
              }
            }
          }
        }
      }
    }
    return 'نامشخص';
  }

  List<String> _getNameServers() {
    if (_data == null) return [];
    final ns = _data!['nameservers'] as List<dynamic>?;
    if (ns != null) {
      return ns.map((e) => e['ldhName'].toString()).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF261933);
    const successColor = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: isDark ? backgroundDark : const Color(0xFFF7F6F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'نتایج WHOIS',
          style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor))
            : _error != null
                ? _buildErrorView(primaryColor, isDark)
                : _buildResultsView(isDark, primaryColor, backgroundDark,
                    surfaceDark, successColor),
      ),
    );
  }

  Widget _buildErrorView(Color primaryColor, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Colors.redAccent.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: GoogleFonts.vazirmatn(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _fetchWhoisData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('تلاش مجدد', style: GoogleFonts.vazirmatn()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView(bool isDark, Color primaryColor,
      Color backgroundDark, Color surfaceDark, Color successColor) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                _buildHeroSection(
                    isDark, primaryColor, surfaceDark, successColor),
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildCardHeader(primaryColor, 'اطلاعات دامنه'),
                      const Divider(height: 1, color: Colors.white10),
                      _buildDetailRow('تاریخ ثبت',
                          _getRegistryValue('registration'), isDark),
                      _buildDetailRow('تاریخ انقضا',
                          _getRegistryValue('expiration'), isDark,
                          isHighlighted: true, primary: primaryColor),
                      _buildDetailRow('آخرین بروزرسانی',
                          _getRegistryValue('last update'), isDark),
                      _buildDetailRow('ثبت کننده', _getRegistrar(), isDark),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سرورهای نام',
                              style: GoogleFonts.vazirmatn(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ..._getNameServers()
                                .map((ns) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: _buildNSTile(ns, isDark),
                                    ))
                                .toList(),
                            if (_getNameServers().isEmpty)
                              Text('نامشخص',
                                  style: GoogleFonts.manrope(
                                      color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildFooterAction(isDark, backgroundDark, primaryColor),
      ],
    );
  }

  Widget _buildHeroSection(
      bool isDark, Color primaryColor, Color surfaceDark, Color successColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 10)
                ],
              ),
              child: Icon(Icons.language, color: primaryColor, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              widget.domain.toLowerCase(),
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: successColor.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: successColor, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'فعال (Active)',
                    style: GoogleFonts.vazirmatn(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: successColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardHeader(Color primaryColor, String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.info, color: primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.vazirmatn(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark,
      {bool isHighlighted = false, Color? primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? (primary?.withOpacity(0.1) ?? Colors.transparent)
            : Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isHighlighted) ...[
                Container(
                  width: 3,
                  height: 20,
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.vazirmatn(
                  fontSize: 13,
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                  color: isHighlighted ? primary : Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            value,
            textDirection: TextDirection.ltr,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNSTile(String ns, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF191022) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.dns, color: Colors.grey, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ns,
              textDirection: TextDirection.ltr,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterAction(
      bool isDark, Color backgroundDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? backgroundDark.withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_data == null) return;
            final text =
                'WHOIS Result for ${widget.domain}:\nRegistrar: ${_getRegistrar()}\nCreated: ${_getRegistryValue('registration')}\nExpires: ${_getRegistryValue('expiration')}';
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('نتایج در حافظه کپی شد',
                    style: GoogleFonts.vazirmatn()),
                backgroundColor: primaryColor,
              ),
            );
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.content_copy, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  'کپی نتایج',
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
    );
  }
}
