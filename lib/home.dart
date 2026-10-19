import 'package:flutter/material.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/common/widgets/floating_bottom_nav_bar.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  int _selectedIndex = 0;

  static final List<NavItem> _navItems = [
    const NavItem(screen: Scaffold(), icon: Icons.dashboard, label: 'Wallet'),
    const NavItem(screen: Scaffold(), icon: Icons.history, label: 'Table'),
    const NavItem(
      screen: Scaffold(),
      icon: Icons.bar_chart_rounded,
      label: 'Analytics',
    ),
    const NavItem(
      screen: Scaffold(),
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _navItems.map((item) => item.screen).toList(),
          ),
          FloatingBottomNavBar(
            items: _navItems,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
