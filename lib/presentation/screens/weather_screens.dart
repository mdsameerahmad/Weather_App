import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/weather_bloc/weather_bloc.dart';
import '../../blocs/weather_bloc/weather_event.dart';
import '../../blocs/weather_bloc/weather_state.dart';
import '../Widgets/weather_info.dart';

class WeatherScreen extends StatelessWidget {
  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Weather'), backgroundColor: Colors.blue),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C2526), Color(0xFF2E3B3E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        color: Colors.white.withOpacity(0.05),
                        child: TextField(
                          controller: cityController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search city...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {
                                final city = cityController.text;
                                context.read<WeatherBloc>().add(
                                  FetchWeather(city),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      if (state is WeatherInitial) {
                        return Center(
                          child: Text(
                            "Search for a city",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      } else if (state is WeatherLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        );
                      } else if (state is WeatherLoaded) {
                        return WeatherInfo(weather: state.weather);
                      } else if (state is WeatherError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white54,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
