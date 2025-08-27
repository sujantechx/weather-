// lib/repositories/weather_repository.dart
import '../models/wwather_model.dart';
import '../services/api_service.dart';

class WeatherRepository {
  final ApiService apiService;
  WeatherRepository({required this.apiService});

  Future<WeatherData> fetchWeather(double lat, double lon) async {
    final data = await apiService.fetchWeather(lat, lon);
    return WeatherData.fromJson(data);
  }
}