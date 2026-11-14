import 'package:flutter/material.dart';
import 'package:pulse/theme/app_colors.dart';

class HealthCategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int stable;
  final int review;
  final int critical;
  final VoidCallback? onTap;

  const HealthCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.stable,
    required this.review,
    required this.critical,
    this.onTap,
  });

  int get total => stable + review + critical;

  Color get statusColor {
    if (critical > 0) return AppColors.critical;
    if (review > 0) return AppColors.caution;
    return AppColors.ok;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 240;
        final padding = compact ? 14.0 : 20.0;
        final titleSize = compact ? 18.0 : 23.0;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surface,
                    Color.lerp(AppColors.surface, statusColor, 0.23)!,
                  ],
                ),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(icon, color: statusColor, size: compact ? 36 : 44),
                        const Icon(
                          Icons.arrow_outward,
                          color: AppColors.textPrimary,
                          size: 25,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$total indicators',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: compact ? 13 : 16,
                      ),
                    ),
                    const Spacer(),
                    _StatusBar(
                      stable: stable,
                      review: review,
                      critical: critical,
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _StatusLabel(
                          count: stable,
                          label: 'stable',
                          color: AppColors.ok,
                        ),
                        _StatusLabel(
                          count: review,
                          label: 'review',
                          color: AppColors.caution,
                        ),
                        _StatusLabel(
                          count: critical,
                          label: 'critical',
                          color: AppColors.critical,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusBar extends StatelessWidget {
  final int stable;
  final int review;
  final int critical;

  const _StatusBar({
    required this.stable,
    required this.review,
    required this.critical,
  });

  @override
  Widget build(BuildContext context) {
    final total = stable + review + critical;

    if (total == 0) {
      return Container(
        height: 12,
        decoration: BoxDecoration(
          color: AppColors.textDisabled,
          borderRadius: BorderRadius.circular(20),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          if (stable > 0)
            Expanded(
              flex: stable,
              child: Container(height: 12, color: AppColors.ok),
            ),
          if (review > 0)
            Expanded(
              flex: review,
              child: Container(height: 12, color: AppColors.caution),
            ),
          if (critical > 0)
            Expanded(
              flex: critical,
              child: Container(height: 12, color: AppColors.critical),
            ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _StatusLabel({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$count $label',
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
        ),
      ],
    );
  }
}
