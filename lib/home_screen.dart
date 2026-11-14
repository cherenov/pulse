import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/common/widgets/floating_bottom_nav_bar.dart';
import 'package:pulse/core/database/metrics_registory.dart';
import 'package:pulse/core/tts/tts_provider.dart';
import 'package:pulse/features/add_metrics/add_record_screen.dart';
import 'package:pulse/features/dashboard/dashboard_screen.dart';
import 'package:pulse/features/debug/debug_screen.dart';
import 'package:pulse/features/indicators/indicator_detail_screen.dart';
import 'package:pulse/features/indicators/indicator_group_screen.dart';
import 'package:pulse/features/settings/settings_screen.dart';

class SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final selectedIndexProvider = NotifierProvider<SelectedIndexNotifier, int>(
  SelectedIndexNotifier.new,
);

class SelectedMetricGroupNotifier extends Notifier<MetricGroup> {
  @override
  MetricGroup build() => MetricGroup.blood;

  void setGroup(MetricGroup group) => state = group;
}

final selectedMetricGroupProvider =
    NotifierProvider<SelectedMetricGroupNotifier, MetricGroup>(
      SelectedMetricGroupNotifier.new,
    );

final _welcomeTtsProvider = Provider<void>((ref) {
  ref
      .read(ttsServiceProvider)
      .speak(
        "Welcome to PULSE. WARNING: critical problem detected",
        speechRate: 0.5,
      );
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final List<NavItem> _navItems = [
    const NavItem(
      screen: DashboardScreen(),
      icon: Icons.dashboard,
      label: 'Dashboard',
    ),
    const NavItem(
      screen: IndicatorsGroupScreen(),
      icon: Icons.bar_chart_rounded,
      label: 'Metrics',
    ),
    const NavItem(
      screen: AddRecordScreen(),
      icon: Icons.add_circle_outline,
      label: 'Add record',
    ),
    const NavItem(
      screen: SettingsScreen(),
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
    const NavItem(
      screen: DebugScreen(),
      icon: Icons.developer_mode_outlined,
      selectedIcon: Icons.developer_mode,
      label: 'Debug',
    ),
  ];

  void _onDestinationSelected(WidgetRef ref, int index) {
    ref.read(selectedIndexProvider.notifier).setIndex(index);
    final label = _navItems[index].label;
    ref.read(ttsServiceProvider).speak(label);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(_welcomeTtsProvider);

    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: _navItems.map((item) => item.screen).toList(),
          ),
          FloatingBottomNavBar(
            items: _navItems,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) =>
                _onDestinationSelected(ref, index),
          ),
        ],
      ),
    );
  }
}
