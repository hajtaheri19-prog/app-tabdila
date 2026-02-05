class Quote {
  final String text;
  final String author;
  final String? source;
  final DateTime date;
  
  Quote({
    required this.text,
    required this.author,
    this.source,
    required this.date,
  });
  
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] as String,
      author: json['author'] as String,
      source: json['source'] as String?,
      date: DateTime.parse(json['date'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'source': source,
      'date': date.toIso8601String(),
    };
  }
  
  // Default quotes for offline use
  static List<Quote> getDefaultQuotes() {
    return [
      Quote(
        text: 'در عجبم از آدمی، که خویش را بیش از همه دوست می‌دارد، با این حال نظر خود نسبت به خویش را از نظر دیگران نسبت به خویش، سبک‌تر می‌شمارد...',
        author: 'مارکوس اورلیوس',
        date: DateTime.now(),
      ),
      Quote(
        text: 'زندگی همان چیزی است که برای شما اتفاق می‌افتد در حالی که مشغول برنامه‌ریزی برای چیزهای دیگر هستید.',
        author: 'جان لنون',
        date: DateTime.now(),
      ),
      Quote(
        text: 'تنها راه انجام کارهای بزرگ، عشق ورزیدن به آنچه انجام می‌دهید است.',
        author: 'استیو جابز',
        date: DateTime.now(),
      ),
    ];
  }
}

