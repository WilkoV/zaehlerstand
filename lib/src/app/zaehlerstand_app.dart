import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/app/app_theme.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/screens/zaehlerstand_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ZaehlerstandApp extends StatelessWidget {
  const ZaehlerstandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return SafeArea(
          child: ResponsiveApp(
            builder: (context) => MaterialApp(
              title: 'Zählerstand',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.getResponsiveTheme(context),
              darkTheme: AppTheme.getResponsiveTheme(context, isDarkMode: true),
              themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('de'),
              ],
              home: const ZaehlerstandScreen(),
            ),
          ),
        );
      },
    );
  }
}
