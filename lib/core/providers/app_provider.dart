import 'package:flutter/foundation.dart';
import '../models/quote_model.dart';
import '../models/price_model.dart';
import '../services/quote_service.dart';
import '../services/price_service.dart';

class AppProvider extends ChangeNotifier {
  Quote? _dailyQuote;
  List<Price> _prices = [];
  bool _isLoading = false;
  DateTime? _lastUpdate;
  
  Quote? get dailyQuote => _dailyQuote;
  List<Price> get prices => _prices;
  bool get isLoading => _isLoading;
  DateTime? get lastUpdate => _lastUpdate;
  
  final QuoteService _quoteService = QuoteService();
  final PriceService _priceService = PriceService();
  
  AppProvider() {
    _initializeData();
  }
  
  Future<void> _initializeData() async {
    await loadDailyQuote();
    await loadPrices();
  }
  
  Future<void> loadDailyQuote() async {
    try {
      _dailyQuote = await _quoteService.getDailyQuote();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading quote: $e');
    }
  }
  
  Future<void> loadPrices() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _prices = await _priceService.getPrices();
      _lastUpdate = DateTime.now();
    } catch (e) {
      debugPrint('Error loading prices: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> refreshPrices() async {
    await loadPrices();
  }
}

