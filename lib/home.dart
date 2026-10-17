import 'package:flutter/material.dart';
import 'package:pulse/theme/app_colors.dart';
import 'package:pulse/theme/sizes.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  int _selectedIndex = 0;

  static const _screens = [];

  void setSelectedIndex(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: NavigationBarTheme(
                    data: NavigationBarThemeData(
                      indicatorColor: Colors.transparent,
                      iconTheme: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return IconThemeData(
                            color: Colors.white,
                            size: AppSizes.xxl,
                          );
                        }
                        return IconThemeData(
                          color: Colors.grey,
                          size: AppSizes.xxl,
                        );
                      }),
                    ),
                    child: SizedBox(
                      width: 320, // Fixed width for 4 (Hug Content)
                      child: NavigationBar(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: setSelectedIndex,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        labelBehavior:
                            NavigationDestinationLabelBehavior.alwaysHide,
                        destinations: const [
                          NavigationDestination(
                            icon: Icon(Icons.wallet),
                            label: '',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.table_rows_rounded),
                            label: '',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.bar_chart_rounded),
                            label: '',
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.settings_outlined),
                            label: '',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
