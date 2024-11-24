import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AppTheme {
  // Mobile-specific light theme
  static ThemeData mobileLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 20, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.orange,
    ),
    indicatorColor: Colors.blue,
  );

  // Tablet-specific light theme
  static ThemeData tabletLightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black87),
      bodyLarge: TextStyle(fontSize: 28, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 24, color: Colors.black87),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.orange,
    ),
    indicatorColor: Colors.blue,
  );

  // Mobile-specific dark theme
  static ThemeData mobileDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.teal,
    ),
    indicatorColor: Colors.blue[300],
  );

  // Tablet-specific dark theme
  static ThemeData tabletDarkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white70),
      bodyLarge: TextStyle(fontSize: 28, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 24, color: Colors.white70),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blueGrey,
      secondary: Colors.teal,
    ),
    indicatorColor: Colors.blue[300],
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
}
