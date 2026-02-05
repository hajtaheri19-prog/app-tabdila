import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';

class FeatureGrid extends StatelessWidget {
  const FeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: Icons.auto_awesome,
        title: 'ابزارهای هوش مصنوعی',
        route: AppRoutes.tools,
        color: Colors.purple,
      ),
      _FeatureItem(
        icon: Icons.swap_horiz,
        title: 'مبدل‌ها',
        route: AppRoutes.converters,
        color: Colors.blue,
      ),
      _FeatureItem(
        icon: Icons.calculate,
        title: 'محاسبات',
        route: AppRoutes.tools,
        color: Colors.green,
      ),
      _FeatureItem(
        icon: Icons.fitness_center,
        title: 'ورزش و سلامت',
        route: AppRoutes.tools,
        color: Colors.orange,
      ),
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return _FeatureCard(feature: features[index]);
      },
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String route;
  final Color color;
  
  _FeatureItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.color,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem feature;
  
  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, feature.route),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                feature.color.withOpacity(0.1),
                feature.color.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature.icon,
                  size: 32,
                  color: feature.color,
                ),
                const SizedBox(height: 8),
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

