import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/features/indicators/indicator_detail_screen.dart';
import 'package:pulse/features/indicators/widgets/indicator_list_tile.dart';
import 'package:pulse/home_screen.dart';
import 'package:pulse/theme/app_colors.dart';

class IndicatorsGroupScreen extends ConsumerWidget {
  const IndicatorsGroupScreen({super.key});

  Map<String, Measurement> _latestOverall(List<Measurement> measurements) {
    final result = <String, Measurement>{};

    for (final measurement in measurements) {
      final previous = result[measurement.metricId];

      if (previous == null || measurement.takenAt.isAfter(previous.takenAt)) {
        result[measurement.metricId] = measurement;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectedMetricGroupProvider);
    final measurementsAsync = ref.watch(dbWatchProvider);

    final currentMetrics = metrics
        .where((metric) => metric.group == selectedGroup)
        .toList();

    final groupTitle = switch (selectedGroup) {
      MetricGroup.blood => 'Blood indicators',
      MetricGroup.urine => 'Urine indicators',
      MetricGroup.trackers => 'Non-invasive indicators',
      MetricGroup.eyes => 'Eye health indicators',
    };

    void selectGroup(MetricGroup group) {
      if (selectedGroup == group) return;
      ref.read(selectedMetricGroupProvider.notifier).setGroup(group);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.monitor_heart_outlined,
                        color: AppColors.textPrimary,
                        size: 34,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'PULSE',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryTab(
                          label: 'Blood',
                          selected: selectedGroup == MetricGroup.blood,
                          onTap: () => selectGroup(MetricGroup.blood),
                        ),
                        const SizedBox(width: 9),
                        _CategoryTab(
                          label: 'Urine',
                          selected: selectedGroup == MetricGroup.urine,
                          onTap: () => selectGroup(MetricGroup.urine),
                        ),
                        const SizedBox(width: 9),
                        _CategoryTab(
                          label: 'Non-invasive',
                          selected: selectedGroup == MetricGroup.trackers,
                          onTap: () => selectGroup(MetricGroup.trackers),
                        ),
                        const SizedBox(width: 9),
                        _CategoryTab(
                          label: 'Eye health',
                          selected: selectedGroup == MetricGroup.eyes,
                          onTap: () => selectGroup(MetricGroup.eyes),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          groupTitle,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${currentMetrics.length} total',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
            Expanded(
              child: measurementsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Unable to load measurements.\n$error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
                data: (measurements) {
                  final latestRecords = _latestOverall(measurements);

                  return ListView.separated(
                    key: ValueKey(selectedGroup),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                    itemCount: currentMetrics.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 11),
                    itemBuilder: (context, index) {
                      final metric = currentMetrics[index];

                      return IndicatorListTile(
                        metric: metric,
                        measurement: latestRecords[metric.id],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IndicatorDetailScreen(metricId: metric.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent : AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.onAccent : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
