import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/app/app_colors.dart' as app_colors;

class AppTheme {
  // Mobile-specific light theme
  static ThemeData mobileLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: app_colors.lightPrimaryColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: app_colors.lightTextLargeColor),
      headlineMedium: TextStyle(fontSize: 21, color: app_colors.lightTextMediumColor),
      bodyLarge: TextStyle(fontSize: 19, color: app_colors.lightTextLargeColor),
      bodyMedium: TextStyle(fontSize: 17, color: app_colors.lightTextMediumColor),
      bodySmall: TextStyle(fontSize: 15, color: app_colors.lightTextMediumColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: app_colors.lightPrimaryColor)),
    ),
    colorScheme: ColorScheme.light(
      primary: app_colors.lightPrimaryColor,
      secondary: Colors.orange,
    ),
    indicatorColor: app_colors.lightPrimaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: app_colors.lightSelectedItemColor,
      unselectedItemColor: app_colors.lightUnselectedItemColor,
    ),
    dividerColor: app_colors.lightPrimaryColor,
  );

  // Tablet-specific light theme
  static ThemeData tabletLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: app_colors.lightPrimaryColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: app_colors.lightTextLargeColor),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: app_colors.lightTextMediumColor),
      bodyLarge: TextStyle(fontSize: 22, color: app_colors.lightTextLargeColor),
      bodyMedium: TextStyle(fontSize: 18, color: app_colors.lightTextMediumColor),
      bodySmall: TextStyle(fontSize: 14, color: app_colors.lightTextMediumColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: app_colors.lightPrimaryColor)),
    ),
    colorScheme: ColorScheme.light(
      primary: app_colors.lightPrimaryColor,
      secondary: Colors.orange,
    ),
    indicatorColor: app_colors.lightPrimaryColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: app_colors.lightSelectedItemColor,
      unselectedItemColor: app_colors.lightUnselectedItemColor,
    ),
    dividerColor: app_colors.lightPrimaryColor,
  );

  // Mobile-specific dark theme
  static ThemeData mobileDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: app_colors.darkPrimaryColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: app_colors.darkTextLargeColor),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: app_colors.darkTextMediumColor),
      bodyLarge: TextStyle(fontSize: 20, color: app_colors.darkTextLargeColor),
      bodyMedium: TextStyle(fontSize: 18, color: app_colors.darkTextMediumColor),
      bodySmall: TextStyle(fontSize: 16, color: app_colors.darkTextMediumColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: app_colors.darkPrimaryColor)),
    ),
    colorScheme: ColorScheme.dark(
      primary: app_colors.darkPrimaryColor,
      secondary: Colors.teal,
    ),
    indicatorColor: app_colors.darkIndicatorColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: app_colors.darkSelectedItemColor,
      unselectedItemColor: app_colors.darkUnselectedItemColor,
    ),
    dividerColor: app_colors.darkPrimaryColor,
  );

  // Tablet-specific dark theme
  static ThemeData tabletDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: app_colors.darkPrimaryColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: app_colors.darkTextLargeColor),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: app_colors.darkTextMediumColor),
      bodyLarge: TextStyle(fontSize: 22, color: app_colors.darkTextLargeColor),
      bodyMedium: TextStyle(fontSize: 18, color: app_colors.darkTextMediumColor),
      bodySmall: TextStyle(fontSize: 14, color: app_colors.darkTextMediumColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: app_colors.darkPrimaryColor)),
    ),
    colorScheme: ColorScheme.dark(
      primary: app_colors.darkPrimaryColor,
      secondary: Colors.teal,
    ),
    indicatorColor: app_colors.darkIndicatorColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: app_colors.darkSelectedItemColor,
      unselectedItemColor: app_colors.darkUnselectedItemColor,
    ),
    dividerColor: app_colors.darkPrimaryColor,
  );

  // Function to get the appropriate theme based on screen size
  static ThemeData getResponsiveTheme(BuildContext context, {bool isDarkMode = false}) {
    DeviceScreenType deviceType = getDeviceType(MediaQuery.of(context).size);

    if (isDarkMode) {
      return deviceType == DeviceScreenType.tablet ? tabletDarkTheme : mobileDarkTheme;
    } else {
      return deviceType == DeviceScreenType.tablet ? tabletLightTheme : mobileLightTheme;
    }
  }

  static List<Color> getChartColors({bool isDarkMode = false}) {
    if (isDarkMode) {
      return app_colors.darkBarChartColors;
    } else {
      return app_colors.lightBarChartColors;
    }
  }

  static Color getCharTooltipColor({bool isDarkMode = false}) {
    if (isDarkMode) {
      return app_colors.darkBarChartTooltipColor;
    } else {
      return app_colors.lightBarChartTooltipColor;
    }
  }
}
