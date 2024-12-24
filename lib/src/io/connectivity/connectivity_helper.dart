import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/helper/measure_duration.dart';

class ConnectivityHelper {
  static Logger log = Logger('ConnectivityHelper');

  static Future<bool> isConnected() async {
    DateTime start = DateTime.now();
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
      int dailyDuration = MeasureDuration.calculateDuration(start, DateTime.now());
      log.fine('Connectivity check took $dailyDuration ms');

      return true;
    }

    int dailyDuration = MeasureDuration.calculateDuration(start, DateTime.now());
    log.fine('Connectivity check took $dailyDuration ms');

    return false;
  }

  // Stream that shows the current connection status
  static Stream<bool> get connectionStatus {
    return Connectivity().onConnectivityChanged.map((event) {
      if (event.contains(ConnectivityResult.mobile) || event.contains(ConnectivityResult.wifi)) {
        return true;
      }
      return false;
    });
  }
}
