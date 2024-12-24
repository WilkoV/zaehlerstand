import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
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
