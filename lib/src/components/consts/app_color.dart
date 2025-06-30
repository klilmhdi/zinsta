import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBasicsColors {
  const AppBasicsColors._();

  static const Color primaryColor = Color(0xFFB124F7);
  static const Color secondaryColor = Color(0xFFF859D0);
  static const Color primaryBlue = Color(0xFF5E8DFB);
  static const Color softViolet = Color(0xFF9B5EF8);
  static const Color lightBackground = Color(0xFFFFF1FE);
  static const Color darkBackground = Color(0xFF10122b);
  static const Color lightCardColor = CupertinoColors.white;
  static const Color darkCardColor = Color(0xFF121212);
}

class AppColor {
  final ColorScheme colorScheme;

  AppColor({required this.colorScheme});

  factory AppColor.lightTheme() => AppColor(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppBasicsColors.primaryColor,
      onPrimary: Colors.white,
      primaryContainer: AppBasicsColors.primaryColor,
      onPrimaryContainer: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.black,
      secondaryContainer: Colors.green[100],
      onSecondaryContainer: Colors.white,
      tertiary: Colors.yellow,
      onTertiary: Colors.black,
      tertiaryContainer: Colors.yellow[100],
      onTertiaryContainer: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      errorContainer: Colors.red[100],
      onErrorContainer: Colors.white,
      // surface: AppBasicsColors.lightBackground,
      surface: AppBasicsColors.lightBackground,
      onSurface: Colors.black,
      surfaceContainerHighest: CupertinoColors.white,
      onSurfaceVariant: Colors.black,
      outline: Colors.grey,
      outlineVariant: Colors.black,
      shadow: Colors.grey[700],
      scrim: const Color(0xFF040D12).withValues(alpha: 0.5),
      inverseSurface: Colors.black,
      onInverseSurface: Colors.white,
      inversePrimary: AppBasicsColors.primaryColor,
      surfaceTint: AppBasicsColors.primaryColor,
    ),
  );

  factory AppColor.darkTheme() => AppColor(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppBasicsColors.primaryColor,
      onPrimary: Colors.white,
      primaryContainer: AppBasicsColors.primaryColor,
      onPrimaryContainer: Colors.white,
      secondary: Colors.teal,
      onSecondary: Colors.white,
      secondaryContainer: Colors.teal[700],
      onSecondaryContainer: Colors.white,
      tertiary: Colors.amber,
      onTertiary: const Color(0xFF040D12),
      tertiaryContainer: Colors.amber[700],
      onTertiaryContainer: const Color(0xFF040D12),
      error: Colors.red,
      onError: Colors.white,
      errorContainer: Colors.red[700],
      onErrorContainer: Colors.white,
      surface: AppBasicsColors.darkBackground,
      onSurface: Colors.white,
      surfaceContainerHighest: CupertinoColors.darkBackgroundGray.withValues(alpha: 1.5),
      onSurfaceVariant: Colors.white,
      outline: Colors.grey,
      outlineVariant: Colors.white,
      shadow: const Color(0xFF040D12),
      scrim: const Color(0xFF040D12).withValues(alpha: 0.5),
      inverseSurface: Colors.white,
      onInverseSurface: const Color(0xFF040D12),
      inversePrimary: AppBasicsColors.primaryColor,
      surfaceTint: Colors.deepOrange[700],
    ),
  );

  static List<ColorScheme> availableColorSchemes = [
    AppColor.lightTheme().colorScheme,
    AppColor.darkTheme().colorScheme,
  ];

  // Color names
  static const String lightThemeColor = 'lightTheme';
  static const String darkThemeColor = 'darkTheme';

  static ColorScheme getColorSchemeByIndex(int index) {
    if (index >= 0 && index < availableColorSchemes.length) {
      return availableColorSchemes[index];
    }
    return availableColorSchemes[0];
  }

  static int getThemeIndex(ColorScheme colorScheme) {
    return availableColorSchemes.indexOf(colorScheme);
  }

  static List<String> themeNames = ['Light Theme', 'Dark Theme'];

  static String getThemeName(int index) {
    switch (index) {
      case 0:
        return 'Light Theme';
      case 1:
        return 'Dark Theme';
      default:
        return 'Unknown Theme';
    }
  }
}
