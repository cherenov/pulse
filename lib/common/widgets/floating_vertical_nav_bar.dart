import 'package:flutter/material.dart';
import 'package:pulse/common/models/nav_item.dart';
import 'package:pulse/theme/app_colors.dart';
import 'package:pulse/theme/sizes.dart';

class FloatingVerticalNavBar extends StatelessWidget {
  const FloatingVerticalNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.selectedIconColor = Colors.white,
    this.unselectedIconColor = Colors.grey,
    this.height = 320,
    this.width = 64,
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
        alignment: Alignment.centerLeft,
        child: Container(
          width: width,
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
              height: height,
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                backgroundColor: Colors.transparent,
                groupAlignment: 0.0,
                labelType: NavigationRailLabelType.none,
                destinations: items
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: item.selectedIcon != null
                            ? Icon(item.selectedIcon)
                            : null,
                        label: Text(item.label),
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
