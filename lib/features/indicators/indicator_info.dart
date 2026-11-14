import 'package:flutter/material.dart';

import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/theme/app_colors.dart';

const indicatorDescriptions = <String, String>{
  'troponin': 'A marker associated with heart muscle injury.',
  'nt_probnp': 'A marker used to assess cardiac strain.',
  'potassium': 'An electrolyte important for muscle and nerve function.',
  'magnesium': 'An electrolyte involved in muscle and nerve function.',
  'nfl': 'A marker associated with nerve cell injury.',
  'osteocalcin': 'A protein associated with bone metabolism.',
  'cpk': 'An enzyme associated with muscle activity and injury.',
  'hemoglobin': 'A protein in red blood cells that carries oxygen.',
  'alc': 'A measure of lymphocytes in the blood.',
  'il6': 'A marker associated with inflammatory activity.',
  'tnf_alpha': 'A marker associated with inflammatory activity.',
  'hscrp': 'A marker used to evaluate inflammation.',
  'cortisol_am': 'A measurement of morning cortisol levels.',
  'alt_ast': 'Enzymes commonly used to assess liver health.',
  'creatinine': 'A marker used in assessing kidney function.',
  'urea': 'A marker associated with protein metabolism and kidney function.',
  'urine_calcium': 'The amount of calcium excreted in urine over 24 hours.',
  'ntx_ctx': 'Markers associated with bone breakdown.',
  'hrv_sdnn': 'A measurement of variability between heartbeats.',
  'bp': 'The pressure of circulating blood in the arteries.',
  'bp_ext': 'Blood pressure measurements from both arms.',
  'onsd': 'A measurement of the optic nerve sheath diameter.',
  'iop': 'A measurement of pressure inside the eye.',
};

List<double?> measurementValues(Measurement measurement) => measurement.values;

String formatMeasurementDate(DateTime timestamp) {
  final date = timestamp.toLocal();

  String two(int value) => value.toString().padLeft(2, '0');

  return '${two(date.day)}.${two(date.month)}.${date.year} '
      '${two(date.hour)}:${two(date.minute)}';
}

Color statusColor(MetricStatus status) => switch (status) {
  MetricStatus.ok => AppColors.accent,
  MetricStatus.warning => const Color(0xFFF6CB55),
  MetricStatus.critical => AppColors.critical,
};

class IndicatorAssessment {
  final String label;
  final String message;
  final Color color;
  final bool showWarning;
  final bool isCritical;
  final bool hasInvalidThresholds;

  const IndicatorAssessment({
    required this.label,
    required this.message,
    required this.color,
    this.showWarning = false,
    this.isCritical = false,
    this.hasInvalidThresholds = false,
  });
}

String _direction(MetricDef metric, List<double?> values, MetricStatus status) {
  var below = false;
  var above = false;

  for (var i = 0; i < metric.fields.length; i++) {
    final value = values[i];
    if (value == null || metric.fieldStatus(i, value) != status) continue;

    final min = metric.normal[i][0];
    final max = metric.normal[i][1];
    if (min != null && value < min) below = true;
    if (max != null && value > max) above = true;
  }

  if (below && above) return 'Values are outside the normal range';
  if (below) return 'Indicator is below normal';
  if (above) return 'Indicator is above normal';
  return 'Indicator requires attention';
}

IndicatorAssessment assessIndicator(
  MetricDef metric,
  Measurement? measurement,
) {
  if (measurement == null) {
    return const IndicatorAssessment(
      label: 'No data',
      message: 'No measurements recorded',
      color: AppColors.textDisabled,
    );
  }

  final values = measurement.values;
  final status = metric.status(values);

  if (status == MetricStatus.ok) {
    return IndicatorAssessment(
      label: 'Normal',
      message: 'Indicator is within normal range',
      color: statusColor(status),
    );
  }

  final critical = status == MetricStatus.critical;

  return IndicatorAssessment(
    label: critical ? 'Critical' : 'Caution',
    message: _direction(metric, values, status),
    color: statusColor(status),
    showWarning: true,
    isCritical: critical,
  );
}
