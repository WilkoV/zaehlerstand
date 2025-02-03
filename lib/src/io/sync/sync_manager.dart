import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/io/connectivity/connectivity_helper.dart';
import 'package:zaehlerstand/src/io/db/db_path.dart';
import 'package:zaehlerstand/src/io/http/http_helper.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class SyncManager {
  final DbHelper _dbHelper = DbHelper();

  final Logger _log = Logger('SyncManager');

  Future<void> initialize() async {
    String dbDirectory = await DbPath.get();
    await _dbHelper.initDb(dbDirectory: dbDirectory);
  }

  /// Read all data from server and store it in the local database.
  /// Useful if a new device needs to be initialized
  Future<bool> copyFromServer(String serverAddress, int serverPort) async {
    bool dataChanged = false;

    if (await ConnectivityHelper.isConnected() == false) {
      _log.warning('Device is not connected');
      return dataChanged;
    }

    if (await HttpHelper.isServerReachable(serverAddress, serverPort) == false) {
      _log.warning('Server is not reachable');
      return dataChanged;
    }

    // Import readings

    int numberOfReadings = 0;
    int maxReadingUpdatedAt = await _dbHelper.getMaxReadingsUpdatedAt();

    // If the database is empty, fetch data from Server
    HttpHelper httpHelper = HttpHelper(baseUrl: 'http://$serverAddress:$serverPort');

    _log.info('Fetching readings from server');
    List<Reading> readingsFromServer = await httpHelper.fetchReadingsAfter(maxReadingUpdatedAt);

    _log.fine('Fetched ${readingsFromServer.length} readings from server');
    if (readingsFromServer.isNotEmpty) {
      dataChanged = true;
      // Set isSynced to true
      readingsFromServer = readingsFromServer.map((reading) {
        return reading.copyWith(isSynced: true);
      }).toList();

      // Bulk import the fetched data into the database
      await _dbHelper.bulkInsertReadings(readingsFromServer);
      numberOfReadings = readingsFromServer.length;

      _log.info('Imported $numberOfReadings readings into the database');
    }

    // Import consumptions

    _log.info('Fetching consumptions from server');
    int maxConsumptionUpdatedAt = await _dbHelper.getMaxConsumptionsUpdatedAt();
    List<Consumption> consumptionsFromServer = await httpHelper.fetchConsumptionsAfter(maxConsumptionUpdatedAt);

    if (consumptionsFromServer.isNotEmpty) {
      dataChanged = true;

      await _dbHelper.bulkInsertConsumptions(consumptionsFromServer);

      _log.info('Import ${consumptionsFromServer.length}');
    }

    // Import weather infos

    int maxWeatherInfoUpdatedAt = await _dbHelper.getMaxWeatherInfoUpdatedAt();

    // If the database is empty, fetch data from Server
    _log.fine('Fetching weather info from server');
    List<WeatherInfo> weatherInfosFromServer = await httpHelper.fetchWeatherInfoAfter(maxWeatherInfoUpdatedAt);
    _log.fine('Fetched ${weatherInfosFromServer.length} weather infos from server');

    if (weatherInfosFromServer.isNotEmpty) {
      dataChanged = true;

      // Set isSynced to true
      weatherInfosFromServer = weatherInfosFromServer.map((weatherInfo) {
        return weatherInfo.copyWith(isSynced: true);
      }).toList();

      // Bulk import the fetched data into the database
      await _dbHelper.bulkInsertWeatherInfo(weatherInfosFromServer);
      numberOfReadings = weatherInfosFromServer.length;

      _log.fine('Imported readings into the database');
    }

    httpHelper.close();

    return dataChanged;
  }

  Future<bool> syncUnsyncedData(String serverAddress, int serverPort) async {
    bool dataChanged = false;

    if (await ConnectivityHelper.isConnected() == false) {
      _log.warning('Device is not connected');
      return dataChanged;
    }

    if (await HttpHelper.isServerReachable(serverAddress, serverPort) == false) {
      _log.warning('Server is not reachable');
      return dataChanged;
    }

    // If the database is empty, fetch data from Server
    HttpHelper httpHelper = HttpHelper(baseUrl: 'http://$serverAddress:$serverPort');

    _log.info('Checking for unsynced readings');
    List<Reading> readings = await _dbHelper.getUnsynchronizedReadings();

    if (readings.isNotEmpty) {
      dataChanged = true;

      _log.info('${readings.length} unsynced readings found');
      bool result = await httpHelper.bulkInsertReadings(readings);

      if (result) {
        readings = readings.map((reading) {
          return reading.copyWith(isSynced: true);
        }).toList();

        _dbHelper.bulkInsertReadings(readings);

        _log.info('Readings synced successfully');
      } else {
        _log.info('Sync of readings failed');
      }
    }

    _log.info('Checking for unsynced consumptions');
    List<Consumption> consumptions = await _dbHelper.getUnsynchronizedConsumptions();

    if (consumptions.isNotEmpty) {
      dataChanged = true;

      _log.info('${consumptions.length} unsynced consumptions found');
      bool result = await httpHelper.bulkInsertConsumptions(consumptions);

      if (result) {
        consumptions = consumptions.map((consumption) {
          return consumption.copyWith(isSynced: true);
        }).toList();

        _dbHelper.bulkInsertConsumptions(consumptions);

        _log.info('Consumptions synced successfully');
      } else {
        _log.info('Sync of consumptions failed');
      }
    }

    _log.info('Checking for unsynced weatherInfos');
    List<WeatherInfo> weatherInfos = await _dbHelper.getUnsynchronizedWeatherInfos();

    if (weatherInfos.isNotEmpty) {
      dataChanged = true;

      _log.info('${weatherInfos.length} unsynced weatherInfos found');
      bool result = await httpHelper.bulkInsertWeatherInfos(weatherInfos);

      if (result) {
        weatherInfos = weatherInfos.map((weatherInfo) {
          return weatherInfo.copyWith(isSynced: true);
        }).toList();

        _dbHelper.bulkInsertWeatherInfo(weatherInfos);

        _log.info('WeatherInfos synced successfully');
      } else {
        _log.info('Sync of weatherInfos failed');
      }
    }

    return dataChanged;
  }
}
