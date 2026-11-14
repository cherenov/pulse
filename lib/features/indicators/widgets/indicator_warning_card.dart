import 'package:flutter/material.dart';

import 'package:pulse/features/indicators/indicator_info.dart';
import 'package:pulse/theme/app_colors.dart';

class IndicatorWarningCard extends StatefulWidget {
  final IndicatorAssessment assessment;

  const IndicatorWarningCard({super.key, required this.assessment});

  @override
  State<IndicatorWarningCard> createState() => _IndicatorWarningCardState();
}

class _IndicatorWarningCardState extends State<IndicatorWarningCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final assessment = widget.assessment;

    if (!assessment.showWarning) {
      return const SizedBox.shrink();
    }

    final background = assessment.isCritical
        ? const Color(0xFF302021)
        : const Color(0xFF302A1D);

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: assessment.color.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: assessment.color,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment.label,
                        style: TextStyle(
                          color: assessment.color,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        assessment.message,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        expanded
                            ? 'Hide recommendations'
                            : 'View recommendations',
                        style: TextStyle(
                          color: assessment.color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: assessment.color,
                    ),
                  ],
                ),
              ),
            ),

            if (expanded) ...[
              const SizedBox(height: 12),
              Divider(color: assessment.color.withValues(alpha: 0.25)),
              const SizedBox(height: 10),

              const _AdviceText(
                'Check that the measurement was entered correctly.',
              ),
              const SizedBox(height: 10),

              const _AdviceText(
                'Verify the reading according to the measurement protocol.',
              ),
              const SizedBox(height: 10),

              _AdviceText(
                assessment.isCritical
                    ? 'Notify the responsible medical professional promptly.'
                    : 'Inform the medical team if the result remains outside the normal range.',
              ),

              const SizedBox(height: 14),

              const Text(
                'These steps are informational and do not replace medical assessment.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdviceText extends StatelessWidget {
  final String text;

  const _AdviceText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 17,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
