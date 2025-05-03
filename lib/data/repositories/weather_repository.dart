import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/data/models/weather_model.dart';

class WeatherRepository {
  final String apiKey = 'f5faa62483a4d74829b3f815380c8611';

  Future<Weather> fetchWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data for $cityName');
    }
  }
}