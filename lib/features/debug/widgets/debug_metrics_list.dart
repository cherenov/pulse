import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/theme/app_colors.dart';

class DebugMetricsList extends ConsumerWidget {
  const DebugMetricsList({super.key}); // Виправлено назву конструктора

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(dbWatchProvider);
    await ref.read(dbWatchProvider.future);
  }

  double _round(double v, int decimals) {
    final k = pow(10, decimals);
    return (v * k).round() / k;
  }

  double _randomValue(MetricDef m, int i) {
    final rng = Random();
    final lim = m.limits[i];
    final r = rng.nextDouble();
    final range = r < 0.6 ? m.normal[i] : (r < 0.85 ? m.critical[i] : lim);
    final lo = range[0] ?? lim[0];
    final hi = range[1] ?? lim[1];
    final v = _round(lo + rng.nextDouble() * (hi - lo), m.decimals);
    return v.clamp(lim[0], lim[1]).toDouble();
  }

  void addRandomMeasurement(WidgetRef ref) {
    final rng = Random();
    final metric = metrics[rng.nextInt(metrics.length)];
    final values = [
      for (var i = 0; i < metric.fields.length; i++) _randomValue(metric, i),
    ];
    ref
        .read(dbProvider)
        .addMeasurement(ref.read(activeProfileIdProvider), metric.id, values);
  }

  Color getStatusColor(MetricStatus status) {
    switch (status) {
      case MetricStatus.critical:
        return AppColors.critical;
      case MetricStatus.warning:
        return AppColors.warning;
      case MetricStatus.ok:
        return AppColors.ok;
    }
  }

  String _getGroupName(MetricGroup group) {
    switch (group) {
      case MetricGroup.blood:
        return 'BLOOD ANALYSIS';
      case MetricGroup.urine:
        return 'URINE ANALYSIS';
      case MetricGroup.trackers:
        return 'NON-INVASIVE & TRACKERS';
      case MetricGroup.eyes:
        return 'OCULAR DIAGNOSTICS';
    }
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Measurement m,
    MetricDef? def,
  ) {
    final fieldsCount =
        def?.fields.length ?? m.values.whereType<double>().length;

    final controllers = List.generate(
      fieldsCount,
      (i) => TextEditingController(
        text: m.values[i] != null ? m.values[i].toString() : '',
      ),
    );

    DateTime selectedDateTime = m.takenAt;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final dateStr =
              '${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')}';
          final timeStr =
              '${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}';

          return AlertDialog(
            title: Text('Edit ${def?.title ?? m.metricId}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(fieldsCount, (i) {
                    final fieldName = def?.fields[i] ?? 'Field ${i + 1}';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: TextField(
                        controller: controllers[i],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: '$fieldName (${def?.unit ?? ""})',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 6),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date & Time'),
                    subtitle: Text('$dateStr  $timeStr'),
                    trailing: const Icon(Icons.edit_calendar),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDateTime,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate == null) return;

                      if (!context.mounted) return;
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                      );
                      if (pickedTime == null) return;

                      setState(() {
                        selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newV0 = double.tryParse(controllers[0].text);
                  final newV1 = controllers.length > 1
                      ? double.tryParse(controllers[1].text)
                      : null;
                  final newV2 = controllers.length > 2
                      ? double.tryParse(controllers[2].text)
                      : null;
                  final newV3 = controllers.length > 3
                      ? double.tryParse(controllers[3].text)
                      : null;

                  ref
                      .read(dbProvider)
                      .editMeasurementFields(
                        id: m.id,
                        takenAt: selectedDateTime,
                        v0: newV0,
                        v1: Value(newV1),
                        v2: Value(newV2),
                        v3: Value(newV3),
                      );
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(dbWatchProvider)
        .when(
          data: (items) {
            if (items.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => _refresh(ref),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => addRandomMeasurement(ref),
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Measurement'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(child: Text('No measurements yet')),
                  ],
                ),
              );
            }

            // 1. Групуємо записи за metricId
            final Map<String, List<Measurement>> byMetricId = {};
            for (final item in items) {
              byMetricId.putIfAbsent(item.metricId, () => []).add(item);
            }

            // 2. Групуємо за MetricGroup
            final Map<MetricGroup?, Map<String, List<Measurement>>>
            groupedByGroup = {};
            for (final entry in byMetricId.entries) {
              final def = metricsById[entry.key];
              final group = def?.group;
              groupedByGroup.putIfAbsent(group, () => {})[entry.key] =
                  entry.value;
            }

            return RefreshIndicator(
              onRefresh: () => _refresh(ref),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 100,
                  left: 16,
                  right: 16,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Total Records: ${items.length} | Metrics: ${byMetricId.keys.length}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => addRandomMeasurement(ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Random'),
                  ),
                  ...groupedByGroup.entries.map((groupEntry) {
                    final group = groupEntry.key;
                    final metricsMap = groupEntry.value;
                    final groupTitle = group != null
                        ? _getGroupName(group)
                        : 'UNCATEGORIZED';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 8.0,
                            left: 4.0,
                          ),
                          child: Text(
                            groupTitle,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ),
                        ...metricsMap.entries.map((entry) {
                          final metricId = entry.key;
                          final metricItems = entry.value;
                          final def = metricsById[metricId];
                          final latest = metricItems.first;
                          final latestStatus = def?.status(latest.values);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ExpansionTile(
                              leading: CircleAvatar(
                                radius: 6,
                                backgroundColor: latestStatus == null
                                    ? Colors.grey
                                    : getStatusColor(latestStatus),
                              ),
                              title: Text(
                                def?.title ?? metricId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('Count: ${metricItems.length}'),
                              trailing: Text(
                                def == null
                                    ? latest.values.whereType<double>().join(
                                        ' / ',
                                      )
                                    : [
                                        for (
                                          var k = 0;
                                          k < def.fields.length;
                                          k++
                                        )
                                          def.format(latest.values[k]),
                                      ].join(' / '),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              children: metricItems.map((m) {
                                final status = def?.status(m.values);
                                final timeStr =
                                    '${m.takenAt.hour.toString().padLeft(2, '0')}:${m.takenAt.minute.toString().padLeft(2, '0')}:${m.takenAt.second.toString().padLeft(2, '0')}';

                                return Dismissible(
                                  key: Key('m_${m.id}'),
                                  background: Container(
                                    color: AppColors.critical,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (_) {
                                    ref
                                        .read(dbProvider)
                                        .deleteMeasurement(m.id);
                                  },
                                  child: ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: status == null
                                          ? Colors.grey
                                          : getStatusColor(status),
                                    ),
                                    title: Text(timeStr),
                                    subtitle: Text('ID: ${m.id}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          def == null
                                              ? m.values
                                                    .whereType<double>()
                                                    .join(' / ')
                                              : [
                                                  for (
                                                    var k = 0;
                                                    k < def.fields.length;
                                                    k++
                                                  )
                                                    def.format(m.values[k]),
                                                ].join(' / '),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 18,
                                          ),
                                          onPressed: () => _showEditDialog(
                                            context,
                                            ref,
                                            m,
                                            def,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        );
  }
}
