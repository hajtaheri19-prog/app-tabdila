class Price {
  final String id;
  final String name;
  final String symbol;
  final double value;
  final double change;
  final double changePercent;
  final String unit;
  final DateTime lastUpdate;
  
  Price({
    required this.id,
    required this.name,
    required this.symbol,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.unit,
    required this.lastUpdate,
  });
  
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      value: (json['value'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      changePercent: (json['changePercent'] as num).toDouble(),
      unit: json['unit'] as String,
      lastUpdate: DateTime.parse(json['lastUpdate'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'value': value,
      'change': change,
      'changePercent': changePercent,
      'unit': unit,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }
  
  bool get isPositive => change >= 0;
  
  // Default prices for offline use
  static List<Price> getDefaultPrices() {
    final now = DateTime.now();
    return [
      Price(
        id: 'stock',
        name: 'بورس',
        symbol: 'شاخص',
        value: 3042933,
        change: 24181,
        changePercent: 0.8,
        unit: '',
        lastUpdate: now,
      ),
      Price(
        id: 'gold_ounce',
        name: 'انس طلا',
        symbol: 'XAU',
        value: 4107.89,
        change: 89.59,
        changePercent: 2.23,
        unit: 'دلار',
        lastUpdate: now,
      ),
      Price(
        id: 'gold_mithqal',
        name: 'مثقال طلا',
        symbol: 'GOLD',
        value: 473640000,
        change: 3930000,
        changePercent: 0.84,
        unit: 'ریال',
        lastUpdate: now,
      ),
      Price(
        id: 'gold_18',
        name: 'طلا ۱۸',
        symbol: 'G18',
        value: 109345000,
        change: 921000,
        changePercent: 0.85,
        unit: 'ریال',
        lastUpdate: now,
      ),
      Price(
        id: 'coin_emami',
        name: 'سکه امامی',
        symbol: 'COIN',
        value: 1133050000,
        change: 3900000,
        changePercent: 0.34,
        unit: 'ریال',
        lastUpdate: now,
      ),
      Price(
        id: 'usd',
        name: 'دلار',
        symbol: 'USD',
        value: 1112000,
        change: 9400,
        changePercent: 0.85,
        unit: 'ریال',
        lastUpdate: now,
      ),
      Price(
        id: 'brent',
        name: 'نفت برنت',
        symbol: 'BRENT',
        value: 63.55,
        change: 0.82,
        changePercent: 1.31,
        unit: 'دلار',
        lastUpdate: now,
      ),
      Price(
        id: 'tether',
        name: 'تتر',
        symbol: 'USDT',
        value: 1121000,
        change: 17520,
        changePercent: 1.56,
        unit: 'ریال',
        lastUpdate: now,
      ),
      Price(
        id: 'bitcoin',
        name: 'بیت کوین',
        symbol: 'BTC',
        value: 115644.03,
        change: 804.9,
        changePercent: 0.7,
        unit: 'دلار',
        lastUpdate: now,
      ),
    ];
  }
}

