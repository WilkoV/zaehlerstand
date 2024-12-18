import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zaehlerstand/src/models/base/weather_info.dart';
import 'package:zaehlerstand/src/constants/open_weather_map_credentials.dart' as owm;

class OpenWeatherMapHelper {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String lat = '53.2327625';
  final String lon = '7.4577265';
  final String units = 'metric';
  final String lang = 'de';

  /// Fetches weather data and stores the icon's cached path in the `icon` field.
  Future<WeatherInfo?> fetchWeather() async {
    try {
      var parsedUrl = Uri.parse('$baseUrl?lat=$lat&lon=$lon&units=$units&lang=$lang&appid=${owm.openWeatherMapApiKey}');

      final response = await http.get(parsedUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return WeatherInfo(
          date: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
          temperature: (data['main']['temp'] as num).toDouble(),
          isGenerated: false,
        );
      }
    } catch (_) {
      // Gracefully handle errors by returning null
    }
    return null;
  }
}
