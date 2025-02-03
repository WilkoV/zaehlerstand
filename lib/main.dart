import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaehlerstand/src/app/zaehlerstand_app.dart';
import 'package:zaehlerstand/src/io/sync/sync_manager.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

const int alarmManagerTaskId = 13297;

Future<void> main() async {
  final Logger log = Logger('Main');
  final SettingsProvider settingsProvider = SettingsProvider();
  final Duration alarmFrequency;

  if (kReleaseMode) {
    // In release mode, set log level to WARNING
    Logger.root.level = Level.WARNING;
    log.fine('Running in release mode. Log level set to WARNING.');

    alarmFrequency = const Duration(hours: 8);
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

  WidgetsFlutterBinding.ensureInitialized();

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

  // Avoid duplicate registrations
  await AndroidAlarmManager.cancel(alarmManagerTaskId);

  // Initialize background task
  await AndroidAlarmManager.periodic(alarmFrequency, alarmManagerTaskId, rescheduleOnReboot: true, zaehlerstandCallbackDispatcher);

  log.info('AlarmManager periodic task registered with taskId = $alarmManagerTaskId.');
}

@pragma('vm:entry-point')
void zaehlerstandCallbackDispatcher() async {
  final int isolateId = Isolate.current.hashCode;

  printLogRecord(isolateId, 'AlarmManager triggered for task $alarmManagerTaskId');

  final SendPort? sendPort = IsolateNameServer.lookupPortByName(DataProvider.isolateNameServerPortName);

  if (sendPort != null) {
    sendPort.send(DataProvider.isolateNameServerTriggerWord);
    printLogRecord(isolateId, 'Trigger sent to DataProvider via IsolateNameServer.');
  } else {
    try {
      printLogRecord(isolateId, 'No SendPort found. Initializing a temporary SyncManager instance for background sync.');

      final preferences = await SharedPreferences.getInstance();
      await preferences.reload();

      printLogRecord(isolateId, 'preferences: ${preferences.getKeys()}');

      String? serverAddress = preferences.getString(SettingsProvider.serverAdressKey);
      String? serverPort = preferences.getString(SettingsProvider.serverPortKey) ?? '8080';

      if (serverAddress == null || serverAddress == '') {
        printLogRecord(isolateId, 'Server address or port not set. Skipping background sync.');
        return;
      }

      printLogRecord(isolateId, "Server address: $serverAddress, Server port: $serverPort");

      SyncManager syncManager = SyncManager();
      await syncManager.initialize();

      printLogRecord(isolateId, 'Starting background sync.');

      bool fromServer = await syncManager.copyFromServer(serverAddress, int.parse(serverPort));
      printLogRecord(isolateId, 'SyncManager copyFromServer returned $fromServer');

      bool toServer = await syncManager.syncUnsyncedData(serverAddress, int.parse(serverPort));
      printLogRecord(isolateId, 'SyncManager syncUnsyncedData returned $toServer');

      printLogRecord(isolateId, 'SyncManager actions completed.');
    } catch (e) {
      printLogRecord(isolateId, 'Error during temporary sync manager activity: $e');
    }
  }
}

void printLogRecord(int isolateId, String message) {
  // ignore: avoid_print
  print('[zaehlerstandCallbackDispatcher] INFO: ${DateTime.now().toIso8601String()}: $isolateId: $message');
}
