import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/core/database/db_providers.dart';
import 'package:pulse/features/debug/widgets/debug_metrics_list.dart';
import 'package:pulse/features/debug/widgets/debug_risks_list.dart';
import 'package:pulse/theme/app_colors.dart';

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  Future<void> _clearDatabase(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear database'),
        content: const Text(
          'Delete all measurements for the active profile? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.critical),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final profileId = ref.read(activeProfileIdProvider);
    await ref.read(dbProvider).deleteAllData(profileId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () => _clearDatabase(context, ref),
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('Clear database'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.critical,
                    side: const BorderSide(color: AppColors.critical),
                  ),
                ),
              ),
            ),
            const DebugRisksList(),
            const Expanded(child: DebugMetricsList()),
          ],
        ),
      ),
    );
  }
}
