import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart' as pp;

class DbPath {
  static final Logger _log = Logger('DbHelper');

  static Future<String> get() async {
    _log.fine('Determining database path.');

    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile platforms: Store in application documents directory.
      final directory = await pp.getApplicationDocumentsDirectory();
      _log.fine('Database path for mobile: ${directory.path}');
      return directory.path;
    } else if (Platform.isWindows) {
      // Windows: Store in a temporary system directory.
      final dir = await Directory.systemTemp.createTemp();
      _log.fine('Database path for Windows: ${dir.path}');
      return dir.path;
    } else {
      // Unsupported platform: Log and throw an error.
      _log.severe('Unsupported platform encountered.');
      throw UnsupportedError("This platform is not supported");
    }
  }
}
