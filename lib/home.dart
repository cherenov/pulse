import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/common/widgets/floating_bottom_nav_bar.dart';
import 'package:pulse/core/tts/tts_provider.dart';
import 'package:pulse/features/debug/debug_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static final List<NavItem> _navItems = [
    const NavItem(
      screen: Scaffold(
        body: Center(
          child: Text(
            "Dashboard",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      icon: Icons.dashboard,
      label: 'Dashboard',
    ),
    const NavItem(
      screen: Scaffold(
        body: Center(
          child: Text(
            "Metrics",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      icon: Icons.bar_chart_rounded,
      label: 'Metrics',
    ),
    const NavItem(
      screen: Scaffold(
        body: Center(
          child: Text(
            "Add data",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      icon: Icons.add_circle_outline,
      label: 'Add data',
    ),
    const NavItem(
      screen: Scaffold(
        body: Center(
          child: Text(
            "Settings",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
    const NavItem(
      screen: DebugScreen(),
      icon: Icons.settings_outlined,
      selectedIcon: Icons.developer_mode,
      label: 'Debug',
    ),
  ];

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Викликаємо TTS через ref.read з підтягуванням назви вкладки
    final label = _navItems[index].label;
    ref.read(ttsServiceProvider).speak(label);
  }

  @override
  void initState() {
    super.initState();
    ref
        .read(ttsServiceProvider)
        .speak(
          "Welcome to PULSE, dear Astronaut, Badyori systems is happy to see you. We wish you won't die in the space. Have a nice day",
          speechRate: 0.5,
        );
  }

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
            onDestinationSelected: onDestinationSelected,
          ),
        ],
      ),
    );
  }
}
