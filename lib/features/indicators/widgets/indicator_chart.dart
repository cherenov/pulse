import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:math';

import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/features/indicators/indicator_info.dart';
import 'package:pulse/theme/app_colors.dart';

class IndicatorChart extends ConsumerStatefulWidget {
  final MetricDef metric;

  const IndicatorChart({super.key, required this.metric});

  @override
  ConsumerState<IndicatorChart> createState() => _IndicatorChartState();
}

class _IndicatorChartState extends ConsumerState<IndicatorChart> {
  int selectedDays = 7;
  int selectedField = 0;
  bool smooth = true;
  late DateTime periodEnd;

  @override
  void initState() {
    super.initState();
    periodEnd = DateTime.now();
  }

  void selectPeriod(int days) {
    setState(() {
      selectedDays = days;
      periodEnd = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final metric = widget.metric;
    final from = periodEnd.subtract(Duration(days: selectedDays));
    final query = (metricId: metric.id, from: from, to: periodEnd);
    final measurementsAsync = ref.watch(seriesProvider(query));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Measurement chart',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _PeriodButton(
                  label: '7D',
                  selected: selectedDays == 7,
                  onTap: () => selectPeriod(7),
                ),
                _PeriodButton(
                  label: '30D',
                  selected: selectedDays == 30,
                  onTap: () => selectPeriod(30),
                ),
                _PeriodButton(
                  label: '90D',
                  selected: selectedDays == 90,
                  onTap: () => selectPeriod(90),
                ),
                _PeriodButton(
                  label: '1Y',
                  selected: selectedDays == 365,
                  onTap: () => selectPeriod(365),
                ),
                Container(
                  width: 1,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8),
                  color: AppColors.border,
                ),
                _PeriodButton(
                  label: 'Smooth',
                  selected: smooth,
                  onTap: () => setState(() => smooth = !smooth),
                ),
              ],
            ),
          ),
          if (metric.fields.length > 1) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: List.generate(metric.fields.length, (index) {
                return ChoiceChip(
                  label: Text(metric.fields[index]),
                  selected: selectedField == index,
                  onSelected: (_) => setState(() => selectedField = index),
                  selectedColor: AppColors.accent,
                  backgroundColor: AppColors.surfaceHigh,
                  labelStyle: TextStyle(
                    color: selectedField == index
                        ? AppColors.onAccent
                        : AppColors.textSecondary,
                  ),
                );
              }),
            ),
          ],
          const SizedBox(height: 22),
          measurementsAsync.when(
            loading: () => const SizedBox(
              height: 240,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
            ),
            error: (error, stack) => SizedBox(
              height: 240,
              child: Center(
                child: Text(
                  'Unable to load chart data.\n$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
            data: (measurements) => _buildChart(
              metric: metric,
              measurements: measurements,
              from: from,
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
    );
  }

  List<FlSpot> _dedupe(List<FlSpot> pts) {
    final out = <FlSpot>[];
    for (final p in pts) {
      if (out.isNotEmpty && p.x - out.last.x < 1e-6) {
        out[out.length - 1] = p;
      } else {
        out.add(p);
      }
    }
    return out;
  }

  List<FlSpot> _smooth(List<FlSpot> pts) {
    if (pts.length < 3) return pts;

    final xs = <double>[];
    final ys = <double>[];
    for (final p in pts) {
      if (xs.isNotEmpty && p.x - xs.last < 1e-9) {
        ys[ys.length - 1] = p.y;
      } else {
        xs.add(p.x);
        ys.add(p.y);
      }
    }

    final n = xs.length;
    if (n < 3) return pts;

    final d = List<double>.filled(n - 1, 0);
    for (var i = 0; i < n - 1; i++) {
      d[i] = (ys[i + 1] - ys[i]) / (xs[i + 1] - xs[i]);
    }

    final m = List<double>.filled(n, 0);
    m[0] = d[0];
    m[n - 1] = d[n - 2];
    for (var i = 1; i < n - 1; i++) {
      m[i] = d[i - 1] * d[i] <= 0 ? 0 : (d[i - 1] + d[i]) / 2;
    }

    for (var i = 0; i < n - 1; i++) {
      if (d[i] == 0) {
        m[i] = 0;
        m[i + 1] = 0;
        continue;
      }
      final a = m[i] / d[i];
      final b = m[i + 1] / d[i];
      final s = a * a + b * b;
      if (s > 9) {
        final t = 3 / sqrt(s);
        m[i] = t * a * d[i];
        m[i + 1] = t * b * d[i];
      }
    }

    final steps = (240 / (n - 1)).round().clamp(2, 16);
    final out = <FlSpot>[];
    for (var i = 0; i < n - 1; i++) {
      final h = xs[i + 1] - xs[i];
      for (var s = 0; s < steps; s++) {
        final t = s / steps;
        final t2 = t * t;
        final t3 = t2 * t;
        final y =
            (2 * t3 - 3 * t2 + 1) * ys[i] +
            (t3 - 2 * t2 + t) * h * m[i] +
            (-2 * t3 + 3 * t2) * ys[i + 1] +
            (t3 - t2) * h * m[i + 1];
        out.add(FlSpot(xs[i] + h * t, y));
      }
    }
    out.add(FlSpot(xs.last, ys.last));
    return out;
  }

  List<LineChartBarData> _zoneLines(MetricDef metric, List<FlSpot> spots) {
    final f = selectedField;
    final cuts = <double>{
      ...[?metric.critical[f][0], ?metric.critical[f][1]],
      ...[?metric.normal[f][0], ?metric.normal[f][1]],
    }.toList()..sort();

    final bars = <LineChartBarData>[];
    var piece = <FlSpot>[];
    MetricStatus? pieceStatus;

    void flush() {
      if (piece.length > 1 && pieceStatus != null) {
        bars.add(_line(piece, statusColor(pieceStatus!)));
      }
      piece = [];
    }

    void add(FlSpot a, FlSpot b) {
      final status = metric.fieldStatus(f, (a.y + b.y) / 2);
      if (status != pieceStatus) {
        flush();
        pieceStatus = status;
        piece = [a];
      }
      piece.add(b);
    }

    for (var i = 0; i < spots.length - 1; i++) {
      final a = spots[i];
      final b = spots[i + 1];
      final lo = a.y < b.y ? a.y : b.y;
      final hi = a.y < b.y ? b.y : a.y;
      final inside = cuts.where((c) => c > lo && c < hi).toList();
      final crossings = a.y < b.y ? inside : inside.reversed.toList();

      var from = a;
      for (final c in crossings) {
        final t = (c - a.y) / (b.y - a.y);
        final point = FlSpot(a.x + (b.x - a.x) * t, c);
        add(from, point);
        from = point;
      }
      add(from, b);
    }
    flush();
    return bars;
  }

  LineChartBarData _dots(MetricDef metric, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      color: Colors.transparent,
      barWidth: 0,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) {
          final status = metric.fieldStatus(selectedField, spot.y);
          return FlDotCirclePainter(
            radius: 4,
            color: statusColor(status),
            strokeWidth: 0,
          );
        },
      ),
    );
  }

  String _normalText(MetricDef m, double? min, double? max) {
    if (min != null && max != null) {
      return 'Normal range: ${m.format(min)}–${m.format(max)} ${m.unit}';
    }
    if (min != null) return 'Normal: from ${m.format(min)} ${m.unit}';
    if (max != null) return 'Normal: up to ${m.format(max)} ${m.unit}';
    return 'Normal range not specified';
  }

  String _criticalText(MetricDef m, double? min, double? max) {
    final parts = <String>[
      if (min != null) 'below ${m.format(min)}',
      if (max != null) 'above ${m.format(max)}',
    ];
    if (parts.isEmpty) return 'Critical limits not specified';
    return 'Critical: ${parts.join(' or ')} ${m.unit}';
  }

  Widget _buildChart({
    required MetricDef metric,
    required List<Measurement> measurements,
    required DateTime from,
  }) {
    final normalMin = metric.normal[selectedField][0];
    final normalMax = metric.normal[selectedField][1];
    final criticalMin = metric.critical[selectedField][0];
    final criticalMax = metric.critical[selectedField][1];

    final records =
        measurements.where((m) => m.values[selectedField] != null).toList()
          ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

    final spots = _dedupe(
      records.map((m) {
        final days =
            m.takenAt.difference(from).inSeconds / Duration.secondsPerDay;
        return FlSpot(days, m.values[selectedField]!);
      }).toList(),
    );

    final values = <double>[
      ?normalMin,
      ?normalMax,
      ?criticalMin,
      ?criticalMax,
      ...spots.map((spot) => spot.y),
    ];

    if (values.isEmpty) {
      values.addAll(metric.limits[selectedField]);
    }

    final lowest = values.reduce((a, b) => a < b ? a : b);
    final highest = values.reduce((a, b) => a > b ? a : b);

    final span = highest - lowest;
    final padding = span > 0
        ? span * 0.20
        : (highest.abs() * 0.15).clamp(1.0, double.infinity);

    final chartMinY = lowest - padding;
    final chartMaxY = highest + padding;

    final okColor = statusColor(MetricStatus.ok);
    final criticalColor = statusColor(MetricStatus.critical);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.fields[selectedField],
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: selectedDays.toDouble(),
              minY: chartMinY,
              maxY: chartMaxY,
              rangeAnnotations: RangeAnnotations(
                horizontalRangeAnnotations: [
                  if (normalMin != null || normalMax != null)
                    HorizontalRangeAnnotation(
                      y1: normalMin ?? chartMinY,
                      y2: normalMax ?? chartMaxY,
                      color: okColor.withValues(alpha: 0.10),
                    ),
                ],
              ),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  if (normalMin != null)
                    HorizontalLine(
                      y: normalMin,
                      color: okColor,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  if (normalMax != null)
                    HorizontalLine(
                      y: normalMax,
                      color: okColor,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  if (criticalMin != null)
                    HorizontalLine(
                      y: criticalMin,
                      color: criticalColor,
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                    ),
                  if (criticalMax != null)
                    HorizontalLine(
                      y: criticalMax,
                      color: criticalColor,
                      strokeWidth: 1.5,
                      dashArray: [6, 4],
                    ),
                ],
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: AppColors.border, strokeWidth: 1),
                getDrawingVerticalLine: (value) =>
                    FlLine(color: AppColors.border, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                ..._zoneLines(metric, smooth ? _smooth(spots) : spots),
                if (spots.isNotEmpty) _dots(metric, spots),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            _LegendDot(color: statusColor(MetricStatus.ok), label: 'Normal'),
            _LegendDot(
              color: statusColor(MetricStatus.warning),
              label: 'Caution',
            ),
            _LegendDot(
              color: statusColor(MetricStatus.critical),
              label: 'Critical',
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          _normalText(metric, normalMin, normalMax),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          _criticalText(metric, criticalMin, criticalMax),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        if (spots.isEmpty) ...[
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'No measurements for this period',
              style: TextStyle(color: AppColors.textDisabled, fontSize: 13),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _PeriodButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? AppColors.accent : AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.onAccent : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
