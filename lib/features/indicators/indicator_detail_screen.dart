import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/features/indicators/indicator_info.dart';
import 'package:pulse/features/indicators/widgets/indicator_chart.dart';
import 'package:pulse/features/indicators/widgets/indicator_history.dart';
import 'package:pulse/features/indicators/widgets/indicator_warning_card.dart';
import 'package:pulse/theme/app_colors.dart';

class IndicatorDetailScreen extends ConsumerWidget {
  final String metricId;

  const IndicatorDetailScreen({super.key, required this.metricId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metric = metricsById[metricId];

    if (metric == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Text(
              'Indicator not found',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ),
      );
    }

    final latestAsync = ref.watch(latestProvider(metricId));
    final historyAsync = ref.watch(indicatorHistoryProvider(metricId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Indicator details',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),

      // Один прокручуваний екран.
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Text(
                    indicatorDescriptions[metric.id] ??
                        'Health monitoring indicator.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Останній запис і попередження.
                  latestAsync.when(
                    loading: () => const SizedBox(
                      height: 120,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    error: (error, stack) => const _MessageCard(
                      text: 'Unable to load the latest measurement',
                    ),
                    data: (measurement) {
                      final assessment = assessIndicator(metric, measurement);

                      return Column(
                        children: [
                          _LatestMeasurementCard(
                            metric: metric,
                            measurement: measurement,
                            assessment: assessment,
                          ),

                          if (assessment.showWarning) ...[
                            const SizedBox(height: 16),
                            IndicatorWarningCard(
                              key: ValueKey(
                                '${metric.id}-'
                                '${measurement?.takenAt.toIso8601String()}',
                              ),
                              assessment: assessment,
                            ),
                          ],
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  // Універсальний графік.
                  IndicatorChart(key: ValueKey(metric.id), metric: metric),

                  const SizedBox(height: 28),

                  const Text(
                    'Measurement history',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Previous recorded values',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Історія завантажується окремо.
          historyAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            ),
            error: (error, stack) => const SliverToBoxAdapter(
              child: _MessageCard(text: 'Unable to load measurement history'),
            ),
            data: (records) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: IndicatorHistory(metric: metric, measurements: records),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About this indicator',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      indicatorDescriptions[metric.id] ??
                          'Health monitoring indicator.',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Unit: ${metric.unit}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }
}

class _LatestMeasurementCard extends StatelessWidget {
  final MetricDef metric;
  final Measurement? measurement;
  final IndicatorAssessment assessment;

  const _LatestMeasurementCard({
    required this.metric,
    required this.measurement,
    required this.assessment,
  });

  @override
  Widget build(BuildContext context) {
    final values = measurement == null
        ? <double?>[]
        : measurementValues(measurement!);

    final formatted = <String>[];

    if (measurement != null) {
      for (var i = 0; i < metric.fields.length; i++) {
        final value = values[i];

        if (value == null) continue;

        formatted.add(
          metric.fields.length == 1
              ? '${metric.format(value)} ${metric.unit}'
              : '${metric.fields[i]}: '
                    '${metric.format(value)} ${metric.unit}',
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest measurement',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),

          const SizedBox(height: 12),

          Text(
            formatted.isEmpty ? 'No data' : formatted.join('\n'),
            style: TextStyle(
              color: formatted.isEmpty
                  ? AppColors.textDisabled
                  : AppColors.textPrimary,
              fontSize: formatted.length > 1 ? 20 : 28,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: assessment.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  assessment.label,
                  style: TextStyle(
                    color: assessment.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (measurement != null) ...[
            const SizedBox(height: 10),
            Text(
              formatMeasurementDate(measurement!.takenAt),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],

          if (assessment.hasInvalidThresholds) ...[
            const SizedBox(height: 10),
            Text(
              assessment.message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final String text;

  const _MessageCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
