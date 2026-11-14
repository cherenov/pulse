import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/risk_detector/risk_detector.dart';
import 'package:pulse/core/risk_detector/risk_providers.dart';
import 'package:pulse/theme/app_colors.dart';

class DebugRisksList extends ConsumerWidget {
  const DebugRisksList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final risks = ref.watch(riskProvider);

    if (risks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.ok.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: AppColors.ok, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'No critical risks detected across active biomarker telemetry.',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final confirmedRisks = risks
        .where((r) => r.severity == RiskSeverity.confirmed)
        .toList();
    final suspiciousRisks = risks
        .where((r) => r.severity == RiskSeverity.suspicion)
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (confirmedRisks.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'CONFIRMED CLINICAL RISKS',
              AppColors.critical,
            ),
            ...confirmedRisks.map((risk) => _RiskCard(risk: risk)),
          ],
          if (suspiciousRisks.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'RISK SUSPICIONS (SINGLE OUTLIER)',
              AppColors.warning,
            ),
            ...suspiciousRisks.map((risk) => _RiskCard(risk: risk)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0, left: 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final HealthRisk risk;

  const _RiskCard({required this.risk});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = risk.severity == RiskSeverity.confirmed;
    final accentColor = isConfirmed ? AppColors.critical : AppColors.warning;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accentColor.withValues(alpha: 0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isConfirmed
                      ? Icons.warning_amber_rounded
                      : Icons.info_outline,
                  color: accentColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    risk.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    risk.severity.name.toUpperCase(),
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              risk.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: risk.triggeredMetrics.map((mId) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    mId,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
