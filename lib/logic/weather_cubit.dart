// lib/logic/weather_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositores/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;
  WeatherCubit({required this.repository}) : super(WeatherInitial());

  Future<void> fetchWeather(double lat, double lon) async {
    try {
      emit(WeatherLoading());
      final weather = await repository.fetchWeather(lat, lon);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}