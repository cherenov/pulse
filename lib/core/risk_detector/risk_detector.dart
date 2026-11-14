// lib/core/services/risk_detector.dart

enum RiskSeverity { none, suspicion, confirmed }

class HealthRisk {
  final String title;
  final RiskSeverity severity;
  final String description;
  final List<String> triggeredMetrics;

  HealthRisk({
    required this.title,
    required this.severity,
    required this.description,
    required this.triggeredMetrics,
  });
}

class RiskDetector {
  static List<HealthRisk> detect(Map<String, List<double?>> latestValues) {
    final List<HealthRisk> risks = [];

    // Допоміжні функції читання
    double? getVal(String id, [int index = 0]) {
      final vals = latestValues[id];
      if (vals == null || index >= vals.length) return null;
      return vals[index];
    }

    // 1. Аритмія (Arrhythmia)
    final hrv = getVal('hrv_sdnn');
    final k = getVal('potassium');
    final mg = getVal('magnesium');

    final hrvCrit = hrv != null && hrv < 20;
    final kCrit = k != null && (k < 3.2 || k > 5.3);
    final mgCrit = mg != null && mg < 0.7;

    if (hrvCrit && (kCrit || mgCrit)) {
      risks.add(
        HealthRisk(
          title: 'Cardiac Arrhythmia',
          severity: RiskSeverity.confirmed,
          description:
              'Critical SDNN drop combined with severe electrolyte imbalance.',
          triggeredMetrics: [
            'hrv_sdnn',
            if (kCrit) 'potassium',
            if (mgCrit) 'magnesium',
          ],
        ),
      );
    } else if (hrvCrit || kCrit || mgCrit) {
      risks.add(
        HealthRisk(
          title: 'Cardiac Arrhythmia Risk',
          severity: RiskSeverity.suspicion,
          description: 'Electrolyte deviation or reduced autonomic nerve regulation detected.',
          triggeredMetrics: [
            if (hrvCrit) 'hrv_sdnn',
            if (kCrit) 'potassium',
            if (mgCrit) 'magnesium',
          ],
        ),
      );
    }

    // 2. Втрата кісткової маси (Bone Loss)
    final uCa = getVal('urine_calcium');
    final ntx = getVal('ntx_ctx');
    final ost = getVal('osteocalcin');

    final ntxCrit = ntx != null && ntx > 120; // +100%
    final ostCrit = ost != null && ost < 7.7; // -30%
    final uCaCrit = uCa != null && uCa > 8.5;

    if (ntxCrit && ostCrit) {
      risks.add(
        HealthRisk(
          title: 'Accelerated Bone Resorption',
          severity: RiskSeverity.confirmed,
          description: 'High collagen breakdown combined with suppressed bone formation.',
          triggeredMetrics: ['ntx_ctx', 'osteocalcin'],
        ),
      );
    } else if (uCaCrit || ntxCrit) {
      risks.add(
        HealthRisk(
          title: 'Bone Loss Suspicion',
          severity: RiskSeverity.suspicion,
          description: 'Elevated calcium excretion or resorption markers.',
          triggeredMetrics: [
            if (uCaCrit) 'urine_calcium',
            if (ntxCrit) 'ntx_ctx',
          ],
        ),
      );
    }

    // 3. SANS (Spaceflight-Associated Neuro-ocular Syndrome)
    final onsd = getVal('onsd');
    final iop = getVal('iop');

    final onsdCrit = onsd != null && onsd > 6.0;
    final iopCrit = iop != null && iop > 24.0;

    if (onsdCrit && iopCrit) {
      risks.add(
        HealthRisk(
          title: 'SANS Confirmed',
          severity: RiskSeverity.confirmed,
          description: 'Optic nerve sheath swelling combined with elevated intraocular pressure.',
          triggeredMetrics: ['onsd', 'iop'],
        ),
      );
    } else if (onsdCrit || iopCrit) {
      risks.add(
        HealthRisk(
          title: 'SANS Risk',
          severity: RiskSeverity.suspicion,
          description:
              'Increased intracranial/ocular pressure indicators detected.',
          triggeredMetrics: [if (onsdCrit) 'onsd', if (iopCrit) 'iop'],
        ),
      );
    }

    // 4. М'язова атрофія (Muscle Atrophy)
    final cpk = getVal('cpk');
    final cort = getVal('cortisol_am');

    final cpkCrit = cpk != null && cpk > 300;
    final cortCrit = cort != null && cort > 800;

    if (cpkCrit && cortCrit) {
      risks.add(
        HealthRisk(
          title: 'Severe Muscle Degradation',
          severity: RiskSeverity.confirmed,
          description: 'High muscle tissue breakdown combined with chronic stress state.',
          triggeredMetrics: ['cpk', 'cortisol_am'],
        ),
      );
    } else if (cpkCrit) {
      risks.add(
        HealthRisk(
          title: 'Muscle Breakdown Suspicion',
          severity: RiskSeverity.suspicion,
          description: 'Elevated CPK levels in blood.',
          triggeredMetrics: ['cpk'],
        ),
      );
    }

    return risks;
  }
}
