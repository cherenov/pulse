import 'package:flutter/material.dart';
import 'package:pulse/theme/app_colors.dart';
import 'package:pulse/theme/sizes.dart';

final theme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0B0E14), // Глибокий космічний темний
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
  primaryColor: const Color(0xFF00E5FF), // Неоновий ціановий акцент
  cardColor: const Color(0xFF161B26),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF00E5FF),
    secondary: Color(0xFF7C4DFF),
    error: Color(0xFFFF3D00),
  ),
);
