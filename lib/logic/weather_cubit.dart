import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/remote_data/repositores/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;

  // Add properties to store the last fetched coordinates
  double? _lastLat;
  double? _lastLon;

  WeatherCubit({required this.repository}) : super(WeatherInitial());

  Future<void> fetchWeather(double lat, double lon) async {
    // Store the coordinates for future refreshes
    _lastLat = lat;
    _lastLon = lon;

    try {
      emit(WeatherLoading());
      final weather = await repository.fetchWeather(lat: lat, lon: lon);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  // New method for the refresh action
  Future<void> refreshWeather() async {
    if (_lastLat != null && _lastLon != null) {
      // No need to emit WeatherLoading, as the UI is already there.
      // The RefreshIndicator shows its own loading spinner.
      try {
        final weather = await repository.fetchWeather(lat: _lastLat!, lon: _lastLon!);
        emit(WeatherLoaded(weather));
      } catch (e) {
        // You could emit a specific error state for refreshes if you want
        emit(WeatherError(e.toString()));
      }
    }
  }
}