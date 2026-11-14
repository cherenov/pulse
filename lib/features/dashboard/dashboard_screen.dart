import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/features/dashboard/widgets/health_category_card.dart';
import 'package:pulse/home_screen.dart';
import 'package:pulse/theme/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  ({int stable, int review, int critical}) _groupStats(
    MetricGroup group,
    List<Measurement> latest,
  ) {
    final latestById = {for (final m in latest) m.metricId: m};
    var stable = 0;
    var review = 0;
    var critical = 0;

    for (final metric in metrics.where((m) => m.group == group)) {
      final measurement = latestById[metric.id];
      if (measurement == null) continue;

      switch (metric.status(measurement.values)) {
        case MetricStatus.ok:
          stable++;
        case MetricStatus.warning:
          review++;
        case MetricStatus.critical:
          critical++;
      }
    }

    return (stable: stable, review: review, critical: critical);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestAllProvider).value ?? [];

    final categories = [
      _CategoryData(
        title: 'Blood',
        group: MetricGroup.blood,
        icon: Icons.water_drop_outlined,
        stats: _groupStats(MetricGroup.blood, latest),
      ),
      _CategoryData(
        title: 'Urine',
        group: MetricGroup.urine,
        icon: Icons.science_outlined,
        stats: _groupStats(MetricGroup.urine, latest),
      ),
      _CategoryData(
        title: 'Non-invasive',
        group: MetricGroup.trackers,
        icon: Icons.monitor_heart_outlined,
        stats: _groupStats(MetricGroup.trackers, latest),
      ),
      _CategoryData(
        title: 'Eye health',
        group: MetricGroup.eyes,
        icon: Icons.visibility_outlined,
        stats: _groupStats(MetricGroup.eyes, latest),
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
                          stable: category.stats.stable,
                          review: category.stats.review,
                          critical: category.stats.critical,
                          onTap: () {
                            ref
                                .read(selectedMetricGroupProvider.notifier)
                                .setGroup(category.group);
                            ref
                                .read(selectedIndexProvider.notifier)
                                .setIndex(1);
                          },
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
  final MetricGroup group;
  final IconData icon;
  final ({int stable, int review, int critical}) stats;

  const _CategoryData({
    required this.title,
    required this.group,
    required this.icon,
    required this.stats,
  });
}
