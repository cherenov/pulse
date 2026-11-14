import 'package:flutter/material.dart';
import 'package:pulse/theme/app_colors.dart';
import 'package:pulse/theme/sizes.dart';

final theme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.accent,
  cardColor: AppColors.surface,
  dividerColor: AppColors.border,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    onPrimary: AppColors.onAccent,
    secondary: AppColors.sleep,
    error: AppColors.critical,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.surfaceHigh,
  ),
  appBarTheme: AppBarTheme(
    toolbarHeight: 60,
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    scrolledUnderElevation: 0,
    actionsIconTheme: IconThemeData(size: AppSizes.xxl),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surfaceHigh,
    selectedColor: AppColors.accent,
    side: BorderSide.none,
    shape: const StadiumBorder(),
    labelStyle: const TextStyle(color: AppColors.textPrimary),
    secondaryLabelStyle: const TextStyle(color: AppColors.onAccent),
    checkmarkColor: AppColors.onAccent,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceHigh,
    hintStyle: const TextStyle(color: AppColors.textSecondary),
    prefixIconColor: AppColors.textSecondary,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppSizes.lg,
      vertical: AppSizes.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      borderSide: BorderSide.none,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.transparent,
    indicatorColor: Colors.transparent,
    elevation: 0,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return IconThemeData(
        size: AppSizes.xxl,
        color: selected ? AppColors.accent : AppColors.textPrimary,
      );
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final selected = states.contains(WidgetState.selected);
      return TextStyle(
        fontSize: 12,
        color: selected ? AppColors.accent : AppColors.textPrimary,
      );
    }),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 1,
    space: 1,
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.accentDim
          : AppColors.border,
    ),
    thumbColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected)
          ? AppColors.accent
          : AppColors.textSecondary,
    ),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: AppColors.textPrimary,
    displayColor: AppColors.textPrimary,
  ),
);
