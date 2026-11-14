import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/features/dashboard/widgets/health_category_card.dart';
import 'package:pulse/theme/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      const _CategoryData(
        title: 'Blood',
        icon: Icons.water_drop_outlined,
        stable: 12,
        review: 3,
        critical: 1,
      ),
      const _CategoryData(
        title: 'Urine',
        icon: Icons.science_outlined,
        stable: 1,
        review: 1,
        critical: 0,
      ),
      const _CategoryData(
        title: 'Non-invasive',
        icon: Icons.monitor_heart_outlined,
        stable: 2,
        review: 0,
        critical: 0,
      ),
      const _CategoryData(
        title: 'Eye health',
        icon: Icons.visibility_outlined,
        stable: 1,
        review: 0,
        critical: 1,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final columns = availableWidth < 380 ? 1 : 2;
            final horizontalPadding = availableWidth < 600 ? 16.0 : 28.0;
            const spacing = 14.0;

            final cardWidth =
                (availableWidth -
                    horizontalPadding * 2 -
                    spacing * (columns - 1)) /
                columns;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                32,
                horizontalPadding,
                130,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.monitor_heart_outlined,
                        color: AppColors.textPrimary,
                        size: 35,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'PULSE',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: categories.map((category) {
                      return SizedBox(
                        width: cardWidth,
                        height: 270,
                        child: HealthCategoryCard(
                          title: category.title,
                          icon: category.icon,
                          stable: category.stable,
                          review: category.review,
                          critical: category.critical,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryData {
  final String title;
  final IconData icon;
  final int stable;
  final int review;
  final int critical;

  const _CategoryData({
    required this.title,
    required this.icon,
    required this.stable,
    required this.review,
    required this.critical,
  });
}
