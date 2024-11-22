import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/screens/zaehlerstand_screen.dart';

void main() {
  final Logger log = Logger('Main');

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

  log.fine('Ensuring widgets are initialized.');
  WidgetsFlutterBinding.ensureInitialized();

  log.fine('Preserving native splash screen.');
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  log.fine('Initializing DataProvider.');
  DataProvider dataProvider = DataProvider();
  log.fine('DataProvider initialized successfully.');

  log.fine('Starting the ZaehlerstandApp.');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          log.fine('Providing DataProvider to the app.');
          return dataProvider;
        }),
      ],
      child: const ZaehlerstandApp(),
    ),
  );
}

class ZaehlerstandApp extends StatelessWidget {
  const ZaehlerstandApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Logger log = Logger('ZaehlerstandApp');
    log.fine('Building ZaehlerstandApp.');

    return const MaterialApp(
      title: 'Zählerstand',
      debugShowCheckedModeBanner: false,
      home: ZaehlerstandScreen(),
    );
  }
}
