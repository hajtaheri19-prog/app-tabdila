import 'package:intl/intl.dart';

class NumberFormatter {
  static String formatNumber(num value, {int? decimals}) {
    if (decimals != null) {
      return NumberFormat('#,###.${'0' * decimals}').format(value);
    }
    return NumberFormat('#,###').format(value);
  }
  
  static String formatCurrency(num value, String currency) {
    return '${formatNumber(value)} $currency';
  }
  
  static String formatPercent(double value) {
    return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(2)}%';
  }
}

