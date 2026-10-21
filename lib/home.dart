import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/common/widgets/floating_bottom_nav_bar.dart';
import 'package:pulse/core/tts/tts_provider.dart';

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
            "History",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      icon: Icons.history,
      label: 'History',
    ),
    const NavItem(
      screen: Scaffold(
        body: Center(
          child: Text(
            "Analytics",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      icon: Icons.bar_chart_rounded,
      label: 'Analytics',
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
    ref.read(ttsServiceProvider).speak("Dashboard is ready");
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
