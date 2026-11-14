enum MetricGroup { blood, urine, trackers, eyes }

enum MetricStatus { ok, warning, critical }

class MetricDef {
  final String id, title, unit;
  final int decimals;
  final List<String> fields;
  final List<List<double>> limits;
  final List<List<double?>> normal;
  final List<List<double?>> critical;
  final MetricGroup group;

  const MetricDef(
    this.id,
    this.title,
    this.unit,
    this.decimals,
    this.fields,
    this.limits,
    this.normal,
    this.critical,
    this.group,
  );

  MetricStatus fieldStatus(int i, double? v) {
    if (v == null) return MetricStatus.ok;
    final cMin = critical[i][0], cMax = critical[i][1];
    if ((cMin != null && v < cMin) || (cMax != null && v > cMax)) {
      return MetricStatus.critical;
    }
    final nMin = normal[i][0], nMax = normal[i][1];
    if ((nMin != null && v < nMin) || (nMax != null && v > nMax)) {
      return MetricStatus.warning;
    }
    return MetricStatus.ok;
  }

  MetricStatus status(List<double?> values) {
    var worst = MetricStatus.ok;
    for (var i = 0; i < values.length && i < fields.length; i++) {
      final s = fieldStatus(i, values[i]);
      if (s.index > worst.index) worst = s;
    }
    return worst;
  }

  String? validate(int fieldIdx, double value) {
    final min = limits[fieldIdx][0];
    final max = limits[fieldIdx][1];
    if (value < min || value > max) {
      return '${fields[fieldIdx]}: allowed $min–$max $unit';
    }
    return null;
  }

  String format(double? v) => v == null ? '–' : v.toStringAsFixed(decimals);
}

const metrics = [
  // ==================== TRACKERS & NON-INVASIVE ====================
  MetricDef(
    'hrv_sdnn',
    'Heart Rate Variability (SDNN)',
    'ms',
    0,
    ['SDNN'],
    [
      [0, 300],
    ],
    [
      [30, 100],
    ],
    [
      [20, null],
    ],
    MetricGroup.trackers,
  ),
  MetricDef(
    'bp',
    'Blood Pressure',
    'mmHg',
    0,
    ['SYS', 'DIA'],
    [
      [50, 260],
      [30, 160],
    ],
    [
      [90, 120],
      [60, 80],
    ],
    [
      [90, 140],
      [60, 90],
    ],
    MetricGroup.trackers,
  ),
  MetricDef(
    'bp_ext',
    'Blood Pressure (Both Arms)',
    'mmHg',
    0,
    ['SYS L', 'DIA L', 'SYS R', 'DIA R'],
    [
      [50, 260],
      [30, 160],
      [50, 260],
      [30, 160],
    ],
    [
      [90, 120],
      [60, 80],
      [90, 120],
      [60, 80],
    ],
    [
      [70, 140],
      [40, 90],
      [70, 140],
      [40, 90],
    ],
    MetricGroup.trackers,
  ),

  // ==================== BLOOD ANALYSIS ====================
  MetricDef(
    'troponin',
    'Troponin I / T',
    'ng/mL',
    3,
    ['Troponin'],
    [
      [0.0, 10.0],
    ],
    [
      [0.0, 0.04],
    ],
    [
      [null, 0.04],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'nt_probnp',
    'Brain Natriuretic Peptide (NT-proBNP)',
    'pg/mL',
    0,
    ['NT-proBNP'],
    [
      [0, 5000],
    ],
    [
      [0, 125],
    ],
    [
      [null, 300],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'potassium',
    'Potassium (K+)',
    'mmol/L',
    1,
    ['Potassium'],
    [
      [1.0, 10.0],
    ],
    [
      [3.5, 5.0],
    ],
    [
      [3.2, 5.3],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'magnesium',
    'Magnesium (Mg2+)',
    'mmol/L',
    2,
    ['Magnesium'],
    [
      [0.2, 3.0],
    ],
    [
      [0.75, 0.95],
    ],
    [
      [0.70, null],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'nfl',
    'Neurofilament Light (NfL)',
    'pg/mL',
    1,
    ['NfL'],
    [
      [0, 200],
    ],
    [
      [0, 15],
    ],
    [
      [null, 19.5],
    ], // Baseline + 30%
    MetricGroup.blood,
  ),
  MetricDef(
    'osteocalcin',
    'Osteocalcin',
    'ng/mL',
    1,
    ['Osteocalcin'],
    [
      [0, 100],
    ],
    [
      [11, 46],
    ],
    [
      [7.7, null],
    ], // Baseline - 30%
    MetricGroup.blood,
  ),
  MetricDef(
    'cpk',
    'Creatine Kinase (CPK)',
    'U/L',
    0,
    ['CPK'],
    [
      [0, 5000],
    ],
    [
      [20, 200],
    ],
    [
      [null, 300],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'hemoglobin',
    'Hemoglobin (Hgb)',
    'g/L',
    0,
    ['Hemoglobin'],
    [
      [30, 250],
    ],
    [
      [120, 175],
    ],
    [
      [110, 180],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'alc',
    'Absolute Lymphocyte Count (ALC)',
    'cells/mcL',
    0,
    ['ALC'],
    [
      [0, 15000],
    ],
    [
      [1000, 4800],
    ],
    [
      [800, null],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'il6',
    'Interleukin-6 (IL-6)',
    'pg/mL',
    1,
    ['IL-6'],
    [
      [0, 100],
    ],
    [
      [0, 5.0],
    ],
    [
      [null, 15.0],
    ], // Зростання у 3 рази
    MetricGroup.blood,
  ),
  MetricDef(
    'tnf_alpha',
    'TNF-alpha',
    'pg/mL',
    1,
    ['TNF-a'],
    [
      [0, 100],
    ],
    [
      [0, 8.0],
    ],
    [
      [null, 24.0],
    ], // Зростання у 3 рази
    MetricGroup.blood,
  ),
  MetricDef(
    'hscrp',
    'High-Sensitivity CRP (hs-CRP)',
    'mg/L',
    2,
    ['hs-CRP'],
    [
      [0.0, 100.0],
    ],
    [
      [0.0, 1.0],
    ],
    [
      [null, 3.0],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'cortisol_am',
    'Morning Cortisol',
    'nmol/L',
    0,
    ['Cortisol AM'],
    [
      [0, 1500],
    ],
    [
      [140, 690],
    ],
    [
      [null, 800],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'alt_ast',
    'Liver Enzymes (ALT / AST)',
    'U/L',
    0,
    ['ALT', 'AST'],
    [
      [0, 1000],
      [0, 1000],
    ],
    [
      [7, 45],
      [10, 35],
    ],
    [
      [null, 90],
      [null, 70],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'creatinine',
    'Serum Creatinine',
    'umol/L',
    0,
    ['Creatinine'],
    [
      [10, 500],
    ],
    [
      [62, 115],
    ],
    [
      [null, 130],
    ],
    MetricGroup.blood,
  ),
  MetricDef(
    'urea',
    'Blood Urea',
    'mmol/L',
    1,
    ['Urea'],
    [
      [0, 50],
    ],
    [
      [2.5, 8.3],
    ],
    [
      [null, 10.0],
    ],
    MetricGroup.blood,
  ),

  // ==================== URINE ANALYSIS ====================
  MetricDef(
    'urine_calcium',
    '24h Urine Calcium',
    'mmol/day',
    1,
    ['Urine Ca'],
    [
      [0.0, 30.0],
    ],
    [
      [2.5, 7.5],
    ],
    [
      [null, 8.5],
    ],
    MetricGroup.urine,
  ),
  MetricDef(
    'ntx_ctx',
    'Collagen Breakdown Peptides (NTX / CTX)',
    'nmol BCE/mmol Cr',
    1,
    ['NTX/CTX'],
    [
      [0, 300],
    ],
    [
      [10, 60],
    ],
    [
      [null, 120],
    ], // +100% від норми
    MetricGroup.urine,
  ),

  // ==================== OCULAR DIAGNOSTICS ====================
  MetricDef(
    'onsd',
    'Optic Nerve Sheath Diameter (ONSD)',
    'mm',
    1,
    ['ONSD'],
    [
      [2.0, 10.0],
    ],
    [
      [4.5, 5.5],
    ],
    [
      [null, 6.0],
    ],
    MetricGroup.eyes,
  ),
  MetricDef(
    'iop',
    'Intraocular Pressure (IOP)',
    'mmHg',
    0,
    ['IOP'],
    [
      [0, 60],
    ],
    [
      [10, 21],
    ],
    [
      [null, 24],
    ],
    MetricGroup.eyes,
  ),
];

final metricsById = {for (final m in metrics) m.id: m};
