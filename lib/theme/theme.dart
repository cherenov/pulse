import 'package:flutter/material.dart';
import 'package:pulse/theme/app_colors.dart';
import 'package:pulse/theme/sizes.dart';

final theme = ThemeData(
  scaffoldBackgroundColor: AppColors.black,
  appBarTheme: AppBarTheme(
    toolbarHeight: 60,
    backgroundColor: AppColors.black,
    foregroundColor: AppColors.white,
    actionsIconTheme: IconThemeData(size: AppSizes.xxl),
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStatePropertyAll(AppColors.white),
    thumbColor: WidgetStatePropertyAll(AppColors.black),
  ),
);
