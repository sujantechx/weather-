// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/data/remote_data/repositores/weather_repository.dart';
import 'package:weather/data/remote_data/services/api_service.dart';
import 'package:weather/ui/home.dart';

import 'data/remote_data/services/location_service.dart';
import 'logic/weather_cubit.dart';

// Make the main function async to await for location
void main() async {
  // Required for using platform channels before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  final locationService = LocationService();
  final weatherRepository = WeatherRepository(apiHelper: ApiHelper());
  final weatherCubit = WeatherCubit(repository: weatherRepository);

  try {
    // Get the current location
    final position = await locationService.getCurrentLocation();
    // Fetch weather for the obtained coordinates
    weatherCubit.fetchWeather(position.latitude, position.longitude);
  } catch (e) {
    // If location fails, you can fetch a default location or show an error
    // For now, the cubit will just emit an error state which the UI will handle
    print("Error getting location: $e");
  }

  runApp(WeatherApp(weatherCubit: weatherCubit));
}

class WeatherApp extends StatelessWidget {
  final WeatherCubit weatherCubit;

  // Accept the already created cubit
  const WeatherApp({super.key, required this.weatherCubit});

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider.value to provide an EXISTING cubit.
    // This is important because we created it before runApp().
    return BlocProvider.value(
      value: weatherCubit,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}