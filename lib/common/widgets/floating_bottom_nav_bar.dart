import 'package:flutter/material.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/theme/app_colors.dart';
import 'package:pulse/theme/sizes.dart';

class FloatingBottomNavBar extends StatelessWidget {
  const FloatingBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = Colors.grey,
    this.width = 320,
    this.height = 64,
  });

  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Color? backgroundColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.grey,
            borderRadius: BorderRadius.circular(50),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: Colors.transparent,
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(
                    color: selectedIconColor,
                    size: AppSizes.xxl,
                  );
                }
                return IconThemeData(
                  color: unselectedIconColor,
                  size: AppSizes.xxl,
                );
              }),
            ),
            child: SizedBox(
              width: width,
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                backgroundColor: Colors.transparent,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: items
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(item.icon),
                        selectedIcon: item.selectedIcon != null
                            ? Icon(item.selectedIcon)
                            : null,
                        label: item.label,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
