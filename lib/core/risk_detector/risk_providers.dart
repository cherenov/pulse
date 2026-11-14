import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/database/db.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/core/risk_detector/risk_detector.dart';

final riskProvider = Provider<List<HealthRisk>>((ref) {
  final latestItems = ref.watch(latestAllProvider).value ?? [];
  if (latestItems.isEmpty) return [];

  final latestMap = {for (final m in latestItems) m.metricId: m.values};

  return RiskDetector.detect(latestMap);
});
