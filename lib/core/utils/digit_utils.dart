class DigitUtils {
  static const _english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const _farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  static const _arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  static String toFarsi(String input) {
    String result = input;
    for (int i = 0; i < _english.length; i++) {
      result = result.replaceAll(_english[i], _farsi[i]);
    }
    return result;
  }

  static String toEnglish(String input) {
    String result = input;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(_farsi[i], _english[i]);
      result = result.replaceAll(_arabic[i], _english[i]);
    }
    return result;
  }

  static String clean(String input) {
    return toEnglish(input.replaceAll(',', '').replaceAll(' ', ''));
  }

  static double parseDouble(String input, {double defaultValue = 0.0}) {
    if (input.isEmpty) return defaultValue;
    try {
      return double.parse(clean(input));
    } catch (_) {
      return defaultValue;
    }
  }

  static int parseInt(String input, {int defaultValue = 0}) {
    if (input.isEmpty) return defaultValue;
    try {
      return int.parse(clean(input));
    } catch (_) {
      return defaultValue;
    }
  }

  static bool isLuhnValid(String number) {
    String cleanNumber = clean(number);
    if (cleanNumber.length < 13 || cleanNumber.length > 19) return false;

    int sum = 0;
    bool alternate = false;
    for (int i = cleanNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cleanNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n -= 9;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return (sum % 10 == 0);
  }
}
