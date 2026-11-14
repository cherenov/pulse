import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/database/metrics_registory.dart';

extension on MetricGroup {
  String get label => switch (this) {
    MetricGroup.blood => 'Blood',
    MetricGroup.urine => 'Urine',
    MetricGroup.trackers => 'Trackers',
    MetricGroup.eyes => 'Eyes',
  };

  IconData get icon => switch (this) {
    MetricGroup.blood => Icons.water_drop_outlined,
    MetricGroup.urine => Icons.science_outlined,
    MetricGroup.trackers => Icons.monitor_heart_outlined,
    MetricGroup.eyes => Icons.visibility_outlined,
  };
}

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddMetricsScreenState();
}

class _AddMetricsScreenState extends ConsumerState<AddRecordScreen> {
  static const _bg = Color(0xFF111116);
  static const _card = Color(0xFF1A1A20);
  static const _field = Color(0xFF24242B);
  static const _accent = Color(0xFFB8E36E);

  static final _groups = MetricGroup.values
      .where((g) => metrics.any((m) => m.group == g))
      .toList();

  final _ctrls = List.generate(4, (_) => TextEditingController());
  List<String?> _errors = List.filled(4, null);
  late MetricGroup _group = _groups.first;
  late MetricDef _def = _metricsOf(_group).first;
  DateTime _when = DateTime.now();
  bool _saving = false;

  List<MetricDef> _metricsOf(MetricGroup g) =>
      metrics.where((m) => m.group == g).toList();

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _resetFields() {
    for (final c in _ctrls) {
      c.clear();
    }
    _errors = List.filled(4, null);
  }

  void _setGroup(MetricGroup g) => setState(() {
    _group = g;
    _def = _metricsOf(g).first;
    _resetFields();
  });

  void _setMetric(MetricDef m) => setState(() {
    _def = m;
    _resetFields();
  });

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (time == null) return;
    setState(
      () => _when = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  String _format(DateTime d) {
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    String two(int n) => n.toString().padLeft(2, '0');
    return '${m[d.month - 1]} ${d.day}, ${d.year}, ${two(d.hour)}:${two(d.minute)}';
  }

  Future<void> _save() async {
    final values = <double>[];
    final errors = List<String?>.filled(4, null);
    for (var i = 0; i < _def.fields.length; i++) {
      final v = double.tryParse(_ctrls[i].text.trim().replaceAll(',', '.'));
      if (v == null) {
        errors[i] = 'Enter a number';
      } else {
        errors[i] = _def.validate(i, v);
        values.add(v);
      }
    }
    setState(() => _errors = errors);
    if (errors.any((e) => e != null)) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(dbProvider)
          .addMeasurement(
            ref.read(activeProfileIdProvider),
            _def.id,
            values,
            at: _when,
          );
      if (!mounted) return;
      setState(_resetFields);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved: ${_def.status(values).name}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not save: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _fieldRow(int i) {
    final error = _errors[i];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error == null ? Colors.white24 : Colors.redAccent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrls[i],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  cursorColor: _accent,
                  decoration: InputDecoration(
                    labelText: _def.fields.length > 1 ? _def.fields[i] : null,
                    labelStyle: const TextStyle(color: Colors.white54),
                    hintText: 0.toStringAsFixed(_def.decimals),
                    hintStyle: const TextStyle(color: Colors.white24),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                _def.unit,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Text(
              error,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 28),
              child: Text(
                'PULSE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                ),
              ),
            ),
            _LabeledCard(
              label: 'Category',
              child: _Dropdown<MetricGroup>(
                value: _group,
                items: _groups,
                labelOf: (g) => g.label,
                iconOf: (g) => Icon(g.icon, color: _accent),
                onChanged: _setGroup,
              ),
            ),
            const SizedBox(height: 16),
            _LabeledCard(
              label: 'Indicator',
              child: _Dropdown<MetricDef>(
                value: _def,
                items: _metricsOf(_group),
                labelOf: (m) => m.title,
                iconOf: (_) => const Icon(
                  Icons.science_outlined,
                  color: Color(0xFFF2C14E),
                ),
                onChanged: _setMetric,
              ),
            ),
            const SizedBox(height: 16),
            _LabeledCard(
              label: 'Value',
              child: Column(
                children: [
                  for (var i = 0; i < _def.fields.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _fieldRow(i),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _pickDateTime,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white70,
                      ),
                    ),
                    const Text(
                      'Date & time',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _field,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _format(_when),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              height: 56,
              child: FilledButton.icon(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Save measurement'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LabeledCard extends StatelessWidget {
  const _LabeledCard({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A20),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          child,
        ],
      ),
    );
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.iconOf,
  });

  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final Widget Function(T)? iconOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF24242B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF24242B),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
          items: [
            for (final item in items)
              DropdownMenuItem<T>(
                value: item,
                child: Row(
                  children: [
                    if (iconOf != null) ...[
                      iconOf!(item),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        labelOf(item),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
