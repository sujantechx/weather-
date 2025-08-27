// lib/logic/weather_state.dart
import 'package:equatable/equatable.dart';

import '../data/remote_data/models/wwather_model.dart';


abstract class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weather; // Use WeatherData model
  WeatherLoaded(this.weather);
  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);
  @override
  List<Object> get props => [message];
}