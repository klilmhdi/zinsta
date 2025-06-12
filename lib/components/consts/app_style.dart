import 'package:flutter/material.dart';
import 'package:zinsta/components/consts/strings.dart';

import 'app_color.dart';

class AppStyle {
  final int themeIndex;

  AppStyle({this.themeIndex = 0});

  ThemeData get currentTheme {
    if (themeIndex >= 0 && themeIndex < AppColor.availableColorSchemes.length) {
      return ThemeData(
        useMaterial3: true,
        fontFamily: AppStrings.basicFont,
        colorScheme: AppColor.availableColorSchemes[themeIndex],
        scaffoldBackgroundColor: AppColor.availableColorSchemes[themeIndex].surface,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.availableColorSchemes[themeIndex].surface,
          foregroundColor: AppColor.availableColorSchemes[themeIndex].onSurface,
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          tileColor: themeIndex == 0 ? AppBasicsColors.lightCardColor : AppBasicsColors.darkCardColor,
        ),
        cardColor: themeIndex == 0 ? AppBasicsColors.lightCardColor : AppBasicsColors.darkCardColor,
        dividerColor: themeIndex == 0 ? AppBasicsColors.lightBackground : AppBasicsColors.darkBackground,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColor.availableColorSchemes[themeIndex].surface,
          selectedItemColor: AppColor.availableColorSchemes[themeIndex].primary,
          unselectedItemColor: AppColor.availableColorSchemes[themeIndex].onSurface.withValues(alpha: 0.5),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: themeIndex == 0 ? AppBasicsColors.lightCardColor : AppBasicsColors.darkCardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        ),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        fontFamily: AppStrings.basicFont,
        colorScheme: AppColor.availableColorSchemes[0],
      );
    }
  }
}
