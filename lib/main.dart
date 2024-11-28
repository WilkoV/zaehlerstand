import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/app/zaehlerstand_app.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/theme_provider.dart';

Future<void> main() async {
  final Logger log = Logger('Main');
  final ThemeProvider themeProvider = ThemeProvider();

  if (kReleaseMode) {
    // In release mode, set log level to WARNING
    Logger.root.level = Level.WARNING;
    log.fine('Running in release mode. Log level set to WARNING.');
  } else {
    // In debug mode, set log level to ALL
    Logger.root.level = Level.ALL;
    log.fine('Running in debug mode. Log level set to ALL.');
  }

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  log.fine('Preserving native splash screen.');
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await themeProvider.loadTheme();
  log.fine('ThemeProvider initialized successfully.');

  log.fine('Starting the ZaehlerstandApp.');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: const ZaehlerstandApp(),
    ),
  );
}
