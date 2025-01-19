import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:zaehlerstand/src/app/zaehlerstand_app.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

const String workManagerTaskName = 'zaehlerstandSyncTask';

Future<void> main() async {
  final Logger log = Logger('Main');
  final SettingsProvider settingsProvider = SettingsProvider();
  final Duration workmanagerFrequency;
  final Duration workmanagerDelay;

  if (kReleaseMode) {
    // In release mode, set log level to WARNING
    Logger.root.level = Level.WARNING;
    log.fine('Running in release mode. Log level set to WARNING.');

    workmanagerFrequency = const Duration(hours: 6);
    workmanagerDelay = const Duration(minutes: 15);
  } else {
    // In debug mode, set log level to ALL
    Logger.root.level = Level.ALL;
    log.fine('Running in debug mode. Log level set to ALL.');

    workmanagerFrequency = const Duration(minutes: 15);
    workmanagerDelay = const Duration(seconds: 1);
  }

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  // TODO: Implement splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await settingsProvider.loadSettings();
  log.fine('SettingsProvider initialized successfully.');

  // Initialize workmanager
  log.fine('Workmanager configuration ${workmanagerFrequency.inMinutes}m ${workmanagerDelay.inSeconds}s');
  // Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  Workmanager().registerPeriodicTask('de.wve.zaehlerstand.trigger.sync', workManagerTaskName, frequency: workmanagerFrequency, initialDelay: workmanagerDelay);

  log.info('Workmanager initialized');

  log.fine('Starting the ZaehlerstandApp.');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingsProvider),
        ChangeNotifierProvider<DataProvider>(
          create: (context) => DataProvider(settingsProvider)..initialize(),
          lazy: true,
        ),
      ],
      child: const ZaehlerstandApp(),
    ),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  Logger logger = Logger('callbackDispatcher');

  Workmanager().executeTask((task, inputData) async {
    logger.fine('Workmanager triggered for task $task');

    if (task == workManagerTaskName) {
      logger.info('Sending trigger via isolated name server');

      final SendPort? sendPort = IsolateNameServer.lookupPortByName(DataProvider.isolateNameServerPortName);
      sendPort?.send(DataProvider.isolateNameServerTriggerWord);

      logger.info('Trigger send');
    }
    return Future.value(true);
  });
}
