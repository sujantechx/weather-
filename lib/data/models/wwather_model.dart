// lib/models/weather_model.dart
class WeatherData {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  WeatherData({required this.current, required this.hourly, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current']),
      hourly: (json['hourly'] as List).map((item) => HourlyForecast.fromJson(item)).toList(),
      daily: (json['daily'] as List).map((item) => DailyForecast.fromJson(item)).toList(),
    );
  }
}

class CurrentWeather {
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String main;
  final int sunrise;
  final int sunset;
  final int uvi;
  final double pressure;

  CurrentWeather.fromJson(Map<String, dynamic> json)
      : temp = json['temp'].toDouble(),
        feelsLike = json['feels_like'].toDouble(),
        humidity = json['humidity'],
        windSpeed = json['wind_speed'].toDouble(),
        description = json['weather'][0]['description'],
        main = json['weather'][0]['main'],
        sunrise = json['sunrise'],
        sunset = json['sunset'],
        uvi = (json['uvi'] as num).round(),
        pressure = json['pressure'] / 33.864; // hPa to inHg
}

class HourlyForecast {
  final int dt;
  final double temp;
  final String main;
  final int pop;

  HourlyForecast.fromJson(Map<String, dynamic> json)
      : dt = json['dt'],
        temp = json['temp'].toDouble(),
        main = json['weather'][0]['main'],
        pop = ((json['pop'] as num) * 100).round();
}

class DailyForecast {
  final int dt;
  final double maxTemp;
  final double minTemp;
  final String main;
  final int pop;

  DailyForecast.fromJson(Map<String, dynamic> json)
      : dt = json['dt'],
        maxTemp = json['temp']['max'].toDouble(),
        minTemp = json['temp']['min'].toDouble(),
        main = json['weather'][0]['main'],
        pop = ((json['pop'] as num) * 100).round();
}