import 'package:flutter/material.dart';

import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/features/indicators/indicator_info.dart';
import 'package:pulse/theme/app_colors.dart';

class IndicatorHistory extends StatelessWidget {
  final MetricDef metric;
  final List<Measurement> measurements;

  const IndicatorHistory({
    super.key,
    required this.metric,
    required this.measurements,
  });

  @override
  Widget build(BuildContext context) {
    final records = [...measurements]
      ..sort((a, b) => b.takenAt.compareTo(a.takenAt));

    if (records.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: Text(
              'No measurements recorded',
              style: TextStyle(color: AppColors.textDisabled, fontSize: 14),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final measurement = records[index];
        final values = measurementValues(measurement);
        final assessment = assessIndicator(metric, measurement);

        final formattedValues = <String>[];

        for (var i = 0; i < metric.fields.length; i++) {
          final value = values[i];

          if (value == null) continue;

          formattedValues.add(
            metric.fields.length == 1
                ? '${metric.format(value)} ${metric.unit}'
                : '${metric.fields[i]}: '
                      '${metric.format(value)} ${metric.unit}',
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 44,
                  decoration: BoxDecoration(
                    color: assessment.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatMeasurementDate(measurement.takenAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 7),

                      Text(
                        formattedValues.isEmpty
                            ? 'No data'
                            : formattedValues.join('\n'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  assessment.label,
                  style: TextStyle(
                    color: assessment.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }, childCount: records.length),
    );
  }
}
