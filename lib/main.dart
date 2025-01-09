import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/app/zaehlerstand_app.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

Future<void> main() async {
  final Logger log = Logger('Main');
  final SettingsProvider settingsProvider = SettingsProvider();

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

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // TODO: Implement splash screen
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await settingsProvider.loadSettings();
  log.fine('SettingsProvider initialized successfully.');

  log.fine('Starting the ZaehlerstandApp.');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider<DataProvider>(
          create: (context) => DataProvider(context)
            ..initialize(), 
          lazy: true,
        ),
      ],
      child: const ZaehlerstandApp(),
    ),
  );
}
