import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class FetchWeather extends WeatherEvent {
  final String cityName;
  const FetchWeather(this.cityName);
  @override
  List<Object> get props => [cityName];
}
