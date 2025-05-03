import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/screens/weather_screens.dart';
import 'package:weather_app/blocs/weather_bloc/weather_bloc.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';


void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  final WeatherRepository repository = WeatherRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => WeatherBloc(repository),
      child: WeatherScreen(),),
    );
  }
}

