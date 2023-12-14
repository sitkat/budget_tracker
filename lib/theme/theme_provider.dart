import 'package:flutter/material.dart';

import 'app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
class CustomThemes{
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.primary,
    primaryColor: AppColors.dark_primary,
    iconTheme:  IconThemeData(color: AppColors.black),
    cardColor: AppColors.surface,
    canvasColor: AppColors.incomes,
    dividerColor: AppColors.primary,
    // colorScheme: ColorScheme.light(),
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.dark_primary,
    primaryColor: AppColors.primary,
    iconTheme:  IconThemeData(color: AppColors.primary),
    cardColor: AppColors.dark_surface,
    canvasColor: AppColors.dark_incomes,
    dividerColor: AppColors.inout,
    // colorScheme: ColorScheme.dark(),
  );
}