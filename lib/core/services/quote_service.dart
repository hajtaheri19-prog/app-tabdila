import 'dart:math';
import '../models/quote_model.dart';
import '../utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class QuoteService {
  Future<Quote> getDailyQuote() async {
    // Try to load from cache first
    final prefs = await SharedPreferences.getInstance();
    final cachedQuoteJson = prefs.getString(AppConstants.quotesKey);
    
    if (cachedQuoteJson != null) {
      final cachedData = json.decode(cachedQuoteJson) as Map<String, dynamic>;
      final cachedDate = DateTime.parse(cachedData['date'] as String);
      
      // If quote is from today, return it
      if (_isSameDay(cachedDate, DateTime.now())) {
        return Quote.fromJson(cachedData);
      }
    }
    
    // Get a random quote from defaults (offline)
    final quotes = Quote.getDefaultQuotes();
    final random = Random();
    final selectedQuote = quotes[random.nextInt(quotes.length)];
    
    // Cache the quote
    await prefs.setString(
      AppConstants.quotesKey,
      json.encode(selectedQuote.toJson()),
    );
    
    return selectedQuote;
  }
  
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  // For future: fetch from API when online
  Future<Quote> fetchQuoteFromApi() async {
    // TODO: Implement API call when needed
    throw UnimplementedError('API integration not yet implemented');
  }
}

