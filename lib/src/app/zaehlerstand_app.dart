import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/app/app_theme.dart';
import 'package:zaehlerstand/src/provider/theme_provider.dart';
import 'package:zaehlerstand/src/screens/zaehlerstand_screen.dart';

class ZaehlerstandApp extends StatelessWidget {
  const ZaehlerstandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          
          title: 'Zählerstand',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const ZaehlerstandScreen(),
        );
      },
    );
  }
}
