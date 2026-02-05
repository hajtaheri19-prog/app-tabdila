class AppConstants {
  static const String appName = 'تبدیلا';
  static const String appTagline = 'دستیار هوشمند شما ✨';
  static const String appVersion = '2.4.0';
  
  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String quotesKey = 'daily_quotes';
  static const String pricesKey = 'market_prices';
  
  // API endpoints (for online features)
  static const String baseUrl = 'https://api.tabdila.ir';
  static const String pricesEndpoint = '/api/prices';
  static const String quotesEndpoint = '/api/quotes';
  
  // Update intervals
  static const Duration pricesUpdateInterval = Duration(seconds: 10);
  static const Duration quotesUpdateInterval = Duration(days: 1);
}

