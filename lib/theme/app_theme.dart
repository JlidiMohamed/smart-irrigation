import 'package:flutter/material.dart';

class AppTheme {
  // light getter (new name used by main.dart)
  static ThemeData get light => ThemeData(
    colorSchemeSeed: const Color(0xFF2D6A4F),
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0FDF4),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Color(0x332D6A4F),
    ),
  );

  // dark getter (new name used by main.dart)
  static ThemeData get dark => ThemeData(
    colorSchemeSeed: const Color(0xFF2D6A4F),
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1A0D),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1A2E1A),
      indicatorColor: const Color(0xFF22C55E).withOpacity(0.25),
    ),
    cardColor: const Color(0xFF1A2E1A),
  );

  // Legacy aliases for backward compatibility
  static ThemeData get lightTheme => light;
  static ThemeData get darkTheme => dark;
}

extension AppColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get cardBg => isDark ? const Color(0xFF1A2E1A) : Colors.white;
  Color get scaffoldBg => isDark ? const Color(0xFF0D1A0D) : const Color(0xFFF0FDF4);
  Color get textPrimary => isDark ? Colors.white : const Color(0xFF052E16);
  Color get textSecondary => isDark ? Colors.white54 : Colors.grey.shade600;
  Color get borderColor => isDark ? Colors.white12 : Colors.grey.shade200;
  Color get inputFill => isDark ? const Color(0xFF162616) : const Color(0xFFF9FAFB);
  Color get navBg => isDark ? const Color(0xFF1A2E1A) : Colors.white;
  Color get subtleBg => isDark ? const Color(0xFF122012) : const Color(0xFFDCFCE7);

  // Legacy alias
  Color get navBarBg => navBg;
}
