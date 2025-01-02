import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class HttpHelper {
  final String baseUrl;
  final http.Client client;
  final Duration timeout;

  final Logger _log = Logger('HttpHelper');

  // Constructor with base URL and reusable HTTP client
  HttpHelper({
    required this.baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : client = client ?? http.Client();

  // Helper method to handle requests with timeout
  Future<http.Response> _getWithTimeout(Uri url) async {
    return await client.get(url).timeout(timeout, onTimeout: () => throw TimeoutException('Request timed out for $url'));
  }

  // Method to fetch all readings and return a list of Reading objects
  Future<List<Reading>> fetchReadings() async {
    final url = Uri.parse('$baseUrl/readings');

    try {
      final response = await _getWithTimeout(url);

      if (response.statusCode == 200) {
        // Parse the response body as JSON and map each item to a Reading object
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Reading> readings = jsonResponse.map((item) => Reading.fromJson(item as Map<String, dynamic>)).toList();
        return readings;
      } else {
        _log.warning('Failed to load readings: ${response.statusCode}');
        return <Reading>[];
      }
    } catch (e) {
      _log.severe('Error fetching readings: $e');
      return <Reading>[];
    }
  }

  // Method to fetch readings after a specific update time and return a list of Reading objects
  Future<List<Reading>> fetchReadingsAfter(int updatedAt) async {
    final url = Uri.parse('$baseUrl/readings/after/$updatedAt');

    try {
      final response = await _getWithTimeout(url);

      if (response.statusCode == 200) {
        // Parse the response body as JSON and map each item to a Reading object
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Reading> readings = jsonResponse.map((item) => Reading.fromJson(item as Map<String, dynamic>)).toList();
        return readings;
      } else {
        _log.warning('Failed to load readings after $updatedAt: ${response.statusCode}');
        return <Reading>[];
      }
    } catch (e) {
      _log.severe('Error fetching readings after $updatedAt: $e');
      return <Reading>[];
    }
  }

  // Method to bulk import readings
  Future<bool> bulkInsertReadings(List<Reading> readings) async {
    final url = Uri.parse('$baseUrl/readings/bulk');

    try {
      final payload = jsonEncode(readings.map((reading) => reading.toJson()).toList());
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(timeout, onTimeout: () => throw TimeoutException('Request timed out for $url'));

      if (response.statusCode == 200) {
        _log.info('Bulk import completed successfully');
        return true;
      } else {
        _log.warning('Failed to bulk import readings: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _log.severe('Error during bulk import: $e');
      return false;
    }
  }

  // Method to fetch readings after a specific update time and return a list of WeatherInfo objects
  Future<List<WeatherInfo>> fetchWeatherInfoAfter(int updatedAt) async {
    final url = Uri.parse('$baseUrl/weather-info/after/$updatedAt');

    try {
      final response = await _getWithTimeout(url);

      if (response.statusCode == 200) {
        // Parse the response body as JSON and map each item to a WeatherInfo object
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<WeatherInfo> weatherInfos = jsonResponse.map((item) => WeatherInfo.fromJson(item as Map<String, dynamic>)).toList();
        return weatherInfos;
      } else {
        _log.warning('Failed to load weather info after $updatedAt: ${response.statusCode}');
        return <WeatherInfo>[];
      }
    } catch (e) {
      _log.severe('Error fetching weather info after $updatedAt: $e');
      return <WeatherInfo>[];
    }
  }

  // Close the HTTP client when done (to release resources)
  void close() {
    client.close();
  }
}
