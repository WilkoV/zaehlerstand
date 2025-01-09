import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/app/app_theme.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_yearly_view.dart';

void main() {
  runApp(const ZaehlerstandApp());
}

class ZaehlerstandApp extends StatelessWidget {
  const ZaehlerstandApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveApp(
        builder: (context) => MaterialApp(
          title: 'Zählerstand',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getResponsiveTheme(context),
          darkTheme: AppTheme.getResponsiveTheme(context, isDarkMode: true),
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
  }
}

class ZaehlerstandScreen extends StatelessWidget {
  const ZaehlerstandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DaddysYearlyView(),
    );
  }
}
