import 'package:flutter/material.dart';

class ConvertersPage extends StatelessWidget {
  const ConvertersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final converterCategories = [
      _ConverterCategory(
        title: 'مبدل‌ها',
        icon: Icons.swap_horiz,
        color: Colors.blue,
        converters: [
          'تبدیل واحد (طول، وزن، دما)',
          'تبدیل ارزهای رایج',
          'تبدیل تاریخ شمسی و میلادی',
          'تبدیل ریال و تومان',
          'تبدیل عدد به حروف',
          'تبدیل ارقام فارسی و انگلیسی',
          'تبدیل متن و باینری',
          'مبدل مبنای اعداد',
          'مبدل رنگ (HEX, RGB, HSL)',
          'تبدیل متن و فایل به Base64',
          'مبدل تایم‌استمپ',
        ],
      ),
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('مبدل‌ها'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: converterCategories.length,
        itemBuilder: (context, index) {
          return _ConverterCategoryCard(category: converterCategories[index]);
        },
      ),
    );
  }
}

class _ConverterCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> converters;
  
  _ConverterCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.converters,
  });
}

class _ConverterCategoryCard extends StatelessWidget {
  final _ConverterCategory category;
  
  const _ConverterCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(category.icon, color: category.color),
        title: Text(
          category.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: category.converters.map((converter) {
          return ListTile(
            title: Text(converter),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to specific converter
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$converter در حال توسعه است')),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

