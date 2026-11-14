import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/common/widgets/floating_bottom_nav_bar.dart';
import 'package:pulse/features/dashboard/dashboard_screen.dart';
import 'package:pulse/theme/app_colors.dart';

class SelectedIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

final selectedIndexProvider = NotifierProvider<SelectedIndexNotifier, int>(
  SelectedIndexNotifier.new,
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final List<NavItem> _navItems = [
    const NavItem(
      screen: DashboardScreen(),
      icon: Icons.dashboard,
      label: 'Dashboard',
    ),
    const NavItem(
      screen: _StubScreen(title: 'Metrics'),
      icon: Icons.bar_chart_rounded,
      label: 'Metrics',
    ),
    const NavItem(
      screen: _StubScreen(title: 'Add record'),
      icon: Icons.add_circle_outline,
      label: 'Add record',
    ),
    const NavItem(
      screen: _StubScreen(title: 'Settings'),
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
    const NavItem(
      screen: _StubScreen(title: 'Debug'),
      icon: Icons.developer_mode_outlined,
      selectedIcon: Icons.developer_mode,
      label: 'Debug',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onDestinationSelected: (index) {
              ref.read(selectedIndexProvider.notifier).setIndex(index);
            },
          ),
        ],
      ),
    );
  }
}

class _StubScreen extends StatelessWidget {
  final String title;

  const _StubScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
