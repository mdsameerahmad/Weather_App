import 'package:flutter/material.dart';

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final List<HourlyForecast> hourlyForecast;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.hourlyForecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    var hourlyList = json['list'] as List<dynamic>?;
    List<HourlyForecast> hourlyForecasts = hourlyList != null
        ? hourlyList
        .asMap()
        .entries
        .where((entry) => entry.key < 4)
        .map((entry) => HourlyForecast.fromJson(entry.value))
        .toList()
        : [];

    return Weather(
      cityName: json['city']['name'],
      temperature: json['list'][0]['main']['temp'].toDouble(),
      description: json['list'][0]['weather'][0]['description'],
      hourlyForecast: hourlyForecasts,
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String description;
  final IconData icon;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    String dtTxt = json['dt_txt'];
    DateTime dateTime = DateTime.parse(dtTxt);
    String time = dateTime.hour == 0
        ? "Now"
        : "${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}${dateTime.hour >= 12 ? 'pm' : 'am'}";

    String weatherDesc = json['weather'][0]['description'].toLowerCase().trim();
    double temp = json['main']['temp'].toDouble();

    IconData icon = _getWeatherIcon(temp, weatherDesc);

    return HourlyForecast(
      time: time,
      temperature: temp,
      description: weatherDesc,
      icon: icon,
    );
  }

  static IconData _getWeatherIcon(double temperature, String description) {
    if (description.contains('rain')) {
      return Icons.cloudy_snowing;
    } else if (description.contains('night')) {
      return Icons.nights_stay;
    } else if (description.contains('cloud')) {
      if (description.contains('broken') || description.contains('scattered') || description.contains('few')) {
        return temperature > 25 ? Icons.wb_sunny : Icons.cloud;
      } else {
        return Icons.cloud;
      }
    } else if (description.contains('clear') || description.contains('sun')) {
      return Icons.wb_sunny;
    } else if (temperature > 25) {
      return Icons.wb_sunny;
    } else if (temperature >= 15 && temperature <= 25) {
      return Icons.cloud;
    } else {
      return Icons.nights_stay;
    }
  }
}