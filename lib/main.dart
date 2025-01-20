import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/app/zaehlerstand_app.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

const String alarmManagerTaskName = 'zaehlerstandAlarmManagerSyncTask';
const int alarmManagerTaskId = 0;

Future<void> main() async {
  final Logger log = Logger('Main');
  final SettingsProvider settingsProvider = SettingsProvider();
  final Duration alarmFrequency;

  if (kReleaseMode) {
    // In release mode, set log level to WARNING
    Logger.root.level = Level.WARNING;
    log.fine('Running in release mode. Log level set to WARNING.');

    alarmFrequency = const Duration(minutes: 15);
  } else {
    // In debug mode, set log level to ALL
    Logger.root.level = Level.ALL;
    log.fine('Running in debug mode. Log level set to ALL.');

    alarmFrequency = const Duration(minutes: 15);
  }

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  // TODO: Implement splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  log.info('AlarmManager initialized');

  await settingsProvider.loadSettings();
  log.fine('SettingsProvider initialized successfully.');

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

  await AndroidAlarmManager.cancel(alarmManagerTaskId);

  final DateTime startTime = kReleaseMode ? getAlarmStartTime() : DateTime.now();

  await AndroidAlarmManager.periodic(
    alarmFrequency,
    alarmManagerTaskId,
    startAt: startTime,
    wakeup: true,
    exact: false,
    rescheduleOnReboot: true,
    callbackDispatcher,
  );

  log.info('AlarmManager periodic task registered with startAt = ${startTime.toIso8601String()}.');
}

DateTime getAlarmStartTime() {
  DateTime now = DateTime.now();
  final int hour = now.hour;

  if (hour >= 23) {
    now = now.add(const Duration(days: 1));
    return DateTime(now.year, now.month, now.day, 5, 15);
  } else if (hour >= 17) {
    return DateTime(now.year, now.month, now.day, 23, 15);
  } else if (hour >= 11) {
    return DateTime(now.year, now.month, now.day, 17, 15);
  }

  return DateTime(now.year, now.month, now.day, 11, 15);
}

@pragma('vm:entry-point')
void callbackDispatcher() async {
  Logger.root.onRecord.listen((record) {
    print('[${record.loggerName}] ${record.level.name}: ${record.time}: ${record.message}');
  });

  final Logger logger = Logger('callbackDispatcher');
  logger.info('AlarmManager triggered for task $alarmManagerTaskName');

  final SendPort? sendPort = IsolateNameServer.lookupPortByName(DataProvider.isolateNameServerPortName);

  if (sendPort != null) {
    sendPort.send(DataProvider.isolateNameServerTriggerWord);
    logger.info('Trigger sent to DataProvider via IsolateNameServer.');
  } else {
    logger.warning('No SendPort found. Initializing a temporary DataProvider instance for background sync.');

    // Create temporary SettingsProvider and DataProvider
    final SettingsProvider tempSettingsProvider = SettingsProvider();
    await tempSettingsProvider.loadSettings();

    final DataProvider tempDataProvider = DataProvider(tempSettingsProvider);
    await tempDataProvider.initialize();

    try {
      // Perform the background sync
      await tempDataProvider.syncAndRefreshDisplay();
      logger.info('Temporary DataProvider sync completed.');
    } catch (e, stackTrace) {
      logger.severe('Error during temporary DataProvider sync: $e', e, stackTrace);
    } finally {
      // Cleanup
      tempDataProvider.dispose();
      logger.info('Temporary DataProvider disposed.');
    }
  }
}
