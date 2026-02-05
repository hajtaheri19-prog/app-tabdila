import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/price_model.dart';
import '../utils/app_constants.dart';

class PriceService {
  static const String _baseUrl = 'https://www.tgju.org/';

  static const String _iranJibUrl =
      'https://www.iranjib.ir/showgroup/23/realtime_price/';

  Future<List<Price>> getPrices() async {
    // Web check: Return defaults immediately to avoid CORS errors
    if (kIsWeb) {
      print('Running on Web: Using Mock/Default Prices to bypass CORS');
      return Price.getDefaultPrices();
    }

    try {
      // Try to fetch fresh data from TGJU
      final prices = await fetchPricesFromApi();
      if (prices.isNotEmpty) {
        await cachePrices(prices);
        return prices;
      }
    } catch (e) {
      print('TGJU error, trying IranJib: $e');
      try {
        // Fallback to IranJib
        final prices = await fetchPricesFromIranJib();
        if (prices.isNotEmpty) {
          await cachePrices(prices);
          return prices;
        }
      } catch (e2) {
        print('IranJib error, falling back to cache: $e2');
      }
    }

    // Fallback to cache
    final cachedPrices = await getCachedPrices();
    if (cachedPrices != null && cachedPrices.isNotEmpty) {
      return cachedPrices;
    }

    // Fallback to defaults
    return Price.getDefaultPrices();
  }

  Future<void> cachePrices(List<Price> prices) async {
    final prefs = await SharedPreferences.getInstance();
    final pricesJson = prices.map((p) => p.toJson()).toList();
    await prefs.setString(
      AppConstants.pricesKey,
      json.encode(pricesJson),
    );
  }

  Future<List<Price>?> getCachedPrices() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJson = prefs.getString(AppConstants.pricesKey);

    if (cachedJson != null) {
      try {
        final List<dynamic> pricesList = json.decode(cachedJson);
        return pricesList
            .map((p) => Price.fromJson(p as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<List<Price>> fetchPricesFromApi() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );
      if (response.statusCode == 200) {
        return _parseTgjuHtml(response.body);
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<List<Price>> fetchPricesFromIranJib() async {
    try {
      final response = await http.get(
        Uri.parse(_iranJibUrl),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );
      if (response.statusCode == 200) {
        return _parseIranJibHtml(response.body);
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  List<Price> _parseTgjuHtml(String htmlContent) {
    final document = parser.parse(htmlContent);
    final List<Price> prices = [];
    final now = DateTime.now();

    // 1. Parse Info Bar Items (Top row items)
    final infoItems = {
      'stock': {'id': 'l-gc30', 'name': 'بورس', 'symbol': 'INDEX'},
      'gold_ounce': {'id': 'l-ons', 'name': 'انس طلا', 'symbol': 'XAU'},
      'gold_mithqal': {
        'id': 'l-mesghal',
        'name': 'مثقال طلا',
        'symbol': 'GOLD'
      },
      'gold_18': {'id': 'l-geram18', 'name': 'طلا ۱۸', 'symbol': 'G18'},
      'coin_emami': {'id': 'l-sekee', 'name': 'سکه', 'symbol': 'COIN'},
      'usd': {'id': 'l-price_dollar_rl', 'name': 'دلار', 'symbol': 'USD'},
      'brent': {'id': 'l-oil_brent', 'name': 'نفت برنت', 'symbol': 'BRENT'},
      'tether': {'id': 'l-crypto-tether-irr', 'name': 'تتر', 'symbol': 'USDT'},
      'bitcoin': {
        'id': 'l-crypto-bitcoin',
        'name': 'بیت کوین',
        'symbol': 'BTC'
      },
    };

    infoItems.forEach((key, info) {
      final element = document.getElementById(info['id']!);
      if (element != null) {
        try {
          // Price: <span class="info-price">4,059,339</span>
          final priceText =
              element.querySelector('.info-price')?.text.trim() ?? '0';
          final value = _parseNumber(priceText);

          // Change: <span class="info-change">107.67 (2.18%)</span> or (0%) 0
          final changeText =
              element.querySelector('.info-change')?.text.trim() ?? '';
          final changeData = _parseChangeText(changeText);

          prices.add(Price(
            id: key,
            name: info['name']!,
            symbol: info['symbol']!,
            value: value,
            change: changeData['change']!,
            changePercent: changeData['percent']!,
            unit: (key == 'gold_ounce' || key == 'brent' || key == 'bitcoin')
                ? 'دلار'
                : 'ریال',
            lastUpdate: now,
          ));
        } catch (e) {
          print('Error parsing $key: $e');
        }
      }
    });

    // 2. Parse Crypto Table (for extra items if needed, or to update existing ones if standard)
    // The user specifically asked for "Other crypto data from the table provided".
    // We'll look for rows with data-market-nameslug.
    final rows = document.querySelectorAll('tr[data-market-nameslug]');
    for (var row in rows) {
      try {
        final slug = row.attributes['data-market-nameslug'];
        if (slug == null ||
            slug == 'crypto-bitcoin' ||
            slug == 'crypto-tether') {
          continue; // Already processed in top bar or we skip duplicates
        }

        final nameEl =
            row.querySelector('.tgcss-font-semibold'); // Name container
        // Name might be nested.
        // Based on HTML: <td> ... <div> ... اتریوم ... </div> ... </td>
        // Let's rely on data-market-nameslug to determine symbol/name if extraction is hard,
        // or extract from the cell.
        // Simpler: Use the slug to create an ID.

        // Extract Price (Tether)
        final priceEl = row.querySelector('td[data-label*="قیمت ( تتـر )"]');
        final priceText = priceEl?.text.trim() ?? '0';

        // Extract Change
        final changeEl =
            row.querySelector('td[data-label*="تغییــر ( تتـر )"]');
        final changeText = changeEl?.text.trim() ?? '0';

        // Extract Percent
        final percentEl =
            row.querySelector('td[data-label*="تغییــر ( درصد )"]');
        final percentText = percentEl?.text.trim() ?? '0';

        // Name and Symbol from slug
        // slug: crypto-ethereum -> Name: Ethereum
        String name = slug.replaceFirst('crypto-', '').toUpperCase();
        String symbol = name.substring(0, name.length > 3 ? 3 : name.length);

        // Try to get Persian name if possible, or mapping
        final persianName = _getPersianCryptoName(slug);

        prices.add(Price(
          id: slug,
          name: persianName ?? name,
          symbol: symbol,
          value: _parseNumber(priceText),
          change: _parseNumber(changeText),
          changePercent: _parseNumber(percentText),
          unit: 'تتر',
          lastUpdate: now,
        ));
      } catch (e) {
        print('Error parsing crypto row: $e');
      }
    }

    return prices;
  }

  List<Price> _parseIranJibHtml(String htmlContent) {
    final document = parser.parse(htmlContent);
    final List<Price> prices = [];
    final now = DateTime.now();

    // Mapping for IranJib IDs (Price Cell ID, Change Cell ID [optional])
    final map = {
      'stock': {
        'id': 'f_6369_127_pr',
        'changeId': 'f_6369_99',
        'name': 'بورس',
        'symbol': 'INDEX',
        'unit': 'ریال'
      },
      'gold_ounce': {
        'id': 'f_83_63_pr',
        'changeId': 'f_83_64',
        'name': 'انس طلا',
        'symbol': 'XAU',
        'unit': 'دلار'
      },
      'gold_mithqal': {
        'id': 'f_84_63_pr',
        'changeId': 'f_84_64',
        'name': 'مثقال طلا',
        'symbol': 'GOLD',
        'unit': 'ریال'
      },
      'gold_18': {
        'id': 'f_85_63_pr',
        'changeId': 'f_85_64',
        'name': 'طلا ۱۸',
        'symbol': 'G18',
        'unit': 'ریال'
      },
      'coin_emami': {
        'id': 'f_87_63_pr',
        'changeId': 'f_87_64',
        'name': 'سکه',
        'symbol': 'COIN',
        'unit': 'ریال'
      },
      // Using Dollar Hawala as fallback for 'usd'
      'usd': {
        'id': 'f_8652_68_pr',
        'changeId': 'f_8652_64',
        'name': 'دلار (حواله)',
        'symbol': 'USD',
        'unit': 'ریال'
      },
      'brent': {
        'id': 'f_6371_127_pr',
        'changeId': 'f_6371_99',
        'name': 'نفت برنت',
        'symbol': 'BRENT',
        'unit': 'دلار'
      },
      'tether': {
        'id': 'f_19054_127_pr',
        'changeId': 'f_19054_99',
        'name': 'تتر',
        'symbol': 'USDT',
        'unit': 'ریال'
      },
      'bitcoin': {
        'id': 'f_8277_127_pr',
        'changeId': 'f_8277_99',
        'name': 'بیت کوین',
        'symbol': 'BTC',
        'unit': 'دلار'
      },
    };

    map.forEach((key, info) {
      try {
        final priceEl = document.getElementById(info['id']!);
        final changeEl = document.getElementById(info['changeId']!);

        if (priceEl != null) {
          final priceText = priceEl.text.trim();
          final value = _parseNumber(priceText);

          String changeText = '';
          if (changeEl != null) {
            changeText = changeEl.text.trim();
          }

          // IranJib format: (percent%) value
          final changeData = _parseChangeText(changeText);

          prices.add(Price(
            id: key,
            name: info['name']!,
            symbol: info['symbol']!,
            value: value,
            change: changeData['change']!,
            changePercent: changeData['percent']!,
            unit: info['unit']!,
            lastUpdate: now,
          ));
        }
      } catch (e) {
        print('Error parsing IranJib $key: $e');
      }
    });

    return prices;
  }

  double _parseNumber(String text) {
    if (text.isEmpty) return 0.0;
    // Remove commas
    String clean = text.replaceAll(',', '');

    // Remove extra text like " %" or parenthesis
    clean = clean.replaceAll('%', '').replaceAll('(', '').replaceAll(')', '');

    // IranJib sometimes has hidden text like &lrm; or rtl markers, clean them?
    // Regex \d should handle it if we extract first match.

    clean = _toEnglishDigits(clean);

    // Extract first valid number sequence
    final RegExp regExp = RegExp(r'-?[\d.]+');
    final match = regExp.firstMatch(clean);
    if (match != null) {
      return double.tryParse(match.group(0)!) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, double> _parseChangeText(String text) {
    // Formats: "107.67 (2.18%)" or "(0.11%) 0.11"
    // TGJU: value (percent%)
    // IranJib: (percent%) value   <-- Note the order is often flipped in visual, but in HTML text content it might be "(-0.590%) -5,000,000"

    double change = 0.0;
    double percent = 0.0;

    if (text.isEmpty) return {'change': 0.0, 'percent': 0.0};

    String clean = _toEnglishDigits(text).replaceAll(',', '');

    // Look for percent pattern: (num%)
    final percentMatch = RegExp(r'\(([-+.\d]+)%\)').firstMatch(clean);
    if (percentMatch != null) {
      percent = double.tryParse(percentMatch.group(1)!) ?? 0.0;
      // Remove it to find value
      clean = clean.replaceFirst(percentMatch.group(0)!, '');
    }

    final changeMatch = RegExp(r'[-+.\d]+').firstMatch(clean);
    if (changeMatch != null) {
      change = double.tryParse(changeMatch.group(0)!) ?? 0.0;
    }

    return {'change': change, 'percent': percent};
  }

  String _toEnglishDigits(String text) {
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    for (int i = 0; i < persian.length; i++) {
      text = text.replaceAll(persian[i], english[i]);
    }
    return text;
  }

  String? _getPersianCryptoName(String slug) {
    switch (slug) {
      case 'crypto-ethereum':
        return 'اتریوم';
      case 'crypto-tether':
        return 'تتر';
      case 'crypto-bnb':
        return 'بایننس کوین';
      case 'crypto-xrp':
        return 'ریپل';
      case 'crypto-usd-coin':
        return 'یو اس دی کوین';
      case 'crypto-solana':
        return 'سولانا';
      case 'crypto-tron':
        return 'ترون';
      case 'crypto-dogecoin':
        return 'دوج کوین';
      case 'crypto-cardano':
        return 'کاردانو';
      case 'crypto-bitcoin-cash':
        return 'بیت کوین کش';
      case 'crypto-toncoin':
        return 'تون کوین';
      case 'crypto-litecoin':
        return 'لایت کوین';
      default:
        return null;
    }
  }
}
