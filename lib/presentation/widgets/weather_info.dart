import 'dart:ui';
import 'package:flutter/material.dart';
import '../../data/models/weather_model.dart';

class WeatherInfo extends StatelessWidget {
  final Weather weather;

  const WeatherInfo({required this.weather});

  // Function to determine the icon and its color based on temperature and description
  Map<String, dynamic> _getWeatherIcon(double temperature, String description) {
    description = description.toLowerCase().trim();

    print("Temperature: $temperature°C, Description: $description");

    if (description.contains('rain')) {
      print("Condition matched: Rainy");
      return {
        'icon': Icons.cloudy_snowing,
        'color': Colors.blue, // Blue for rainy
      };
    } else if (description.contains('night')) {
      print("Condition matched: Night");
      return {
        'icon': Icons.nights_stay,
        'color': Colors.white, // White for night
      };
    } else if (description.contains('cloud')) {
      print("Description contains 'cloud'");
      if (description.contains('broken') || description.contains('scattered') || description.contains('few')) {
        print("Cloud type: broken/scattered/few clouds");
        if (temperature > 25) {
          print("Temperature > 25°C, showing sunny icon for partly cloudy weather");
          return {
            'icon': Icons.wb_sunny,
            'color': Colors.yellow, // Yellow for sunny
          };
        } else {
          print("Temperature <= 25°C, showing cloud icon");
          return {
            'icon': Icons.cloud,
            'color': Colors.white, // White for cloudy
          };
        }
      } else {
        print("Other cloud type, showing cloud icon");
        return {
          'icon': Icons.cloud,
          'color': Colors.white, // White for other clouds
        };
      }
    } else if (description.contains('clear') || description.contains('sun')) {
      print("Condition matched: Clear/Sunny");
      return {
        'icon': Icons.wb_sunny,
        'color': Colors.yellow, // Yellow for sunny
      };
    }

    if (temperature > 25) {
      print("Temperature > 25°C, no description match, defaulting to sunny");
      return {
        'icon': Icons.wb_sunny,
        'color': Colors.yellow, // Yellow for sunny
      };
    } else if (temperature >= 15 && temperature <= 25) {
      print("Temperature between 15°C and 25°C, defaulting to cloudy");
      return {
        'icon': Icons.cloud,
        'color': Colors.white, // White for cloudy
      };
    } else if (temperature < 15) {
      print("Temperature < 15°C, defaulting to cold/night");
      return {
        'icon': Icons.nights_stay,
        'color': Colors.white, // White for cold/night
      };
    }

    print("No conditions matched, defaulting to cloud");
    return {
      'icon': Icons.cloud,
      'color': Colors.white, // White for default
    };
  }

  @override
  Widget build(BuildContext context) {
    // Get the main weather icon and its color
    Map<String, dynamic> mainWeatherIconData = _getWeatherIcon(weather.temperature, weather.description);
    IconData mainWeatherIcon = mainWeatherIconData['icon'];
    Color mainWeatherIconColor = mainWeatherIconData['color'];

    return SingleChildScrollView(
      child: Column(
        children: [

          Text(
            weather.cityName,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              mainWeatherIcon,
              size: 100,
              color: mainWeatherIconColor, // Use dynamic color
            ),
          ),
          SizedBox(height: 20),
          Text(
            "${weather.temperature}°C",
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            weather.description,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 30),
                Icon(Icons.access_time, color: Colors.white54),
              ],
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: weather.hourlyForecast.map((forecast) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: _buildForecastCard(
                    forecast.time,
                    forecast.temperature.toInt(),
                    forecast.icon,
                    forecast.description,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(String time, int temp, IconData icon, String description) {
    // Get the icon color for the forecast card based on the forecast's temperature and description
    Map<String, dynamic> forecastIconData = _getWeatherIcon(temp.toDouble(), description);
    Color forecastIconColor = forecastIconData['color'];

    return Container(
      width: 80,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 5),
          Icon(
            icon,
            color: forecastIconColor, // Use dynamic color
            size: 30,
          ),
          SizedBox(height: 5),
          Text(
            "$temp°",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}