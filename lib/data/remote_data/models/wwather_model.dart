import 'package:equatable/equatable.dart';

class WeatherData extends Equatable {
  final CurrentWeather current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const WeatherData({required this.current, required this.hourly, required this.daily});

  factory WeatherData.fromCombinedJson(Map<String, dynamic> currentJson, Map<String, dynamic> forecastJson) {
    List<HourlyForecast> hourlyList = (forecastJson['list'] as List)
        .map((item) => HourlyForecast.fromJson(item))
        .toList();

    List<DailyForecast> dailyList = _deriveDailyFromHourly(hourlyList);

    return WeatherData(
      current: CurrentWeather.fromJson(currentJson),
      hourly: hourlyList,
      daily: dailyList,
    );
  }

  @override
  List<Object?> get props => [current, hourly, daily];
}

List<DailyForecast> _deriveDailyFromHourly(List<HourlyForecast> hourly) {
  Map<int, DailyForecast> dailyMap = {};
  for (var h in hourly) {
    final day = DateTime.fromMillisecondsSinceEpoch(h.dt * 1000).day;
    if (!dailyMap.containsKey(day)) {
      dailyMap[day] = DailyForecast(
        dt: h.dt,
        maxTemp: h.temp,
        minTemp: h.temp,
        main: h.main,
        pop: h.pop,
      );
    } else {
      if (h.temp > dailyMap[day]!.maxTemp) {
        dailyMap[day]!.maxTemp = h.temp;
      }
      if (h.temp < dailyMap[day]!.minTemp) {
        dailyMap[day]!.minTemp = h.temp;
      }
    }
  }
  return dailyMap.values.toList().take(5).toList();
}

class CurrentWeather extends Equatable {
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

  const CurrentWeather({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.main,
    required this.sunrise,
    required this.sunset,
    required this.uvi,
    required this.pressure,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
      main: json['weather'][0]['main'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      uvi: 0, // Not available in free tier
      pressure: json['main']['pressure'] / 33.864, // hPa to inHg
    );
  }

  @override
  List<Object?> get props => [temp, feelsLike, humidity, windSpeed, description, main, sunrise, sunset, uvi, pressure];
}

class HourlyForecast extends Equatable {
  final int dt;
  final double temp;
  final String main;
  final int pop;
  final double windSpeed; // Added for details chart
  final int humidity;     // Added for details chart

  const HourlyForecast({
    required this.dt,
    required this.temp,
    required this.main,
    required this.pop,
    required this.windSpeed,
    required this.humidity,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      dt: json['dt'] ?? 0,
      temp: (json['main']?['temp'] ?? 0.0).toDouble(),
      main: (json['weather'] as List).isNotEmpty ? json['weather'][0]['main'] ?? '' : '',
      pop: (((json['pop'] ?? 0) as num) * 100).round(),
      windSpeed: (json['wind']?['speed'] ?? 0.0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
    );
  }
  @override
  List<Object?> get props => [dt, temp, main, pop, windSpeed, humidity];
}

class DailyForecast extends Equatable {
  final int dt;
  double maxTemp;
  double minTemp;
  final String main;
  final int pop;

  DailyForecast({
    required this.dt,
    required this.maxTemp,
    required this.minTemp,
    required this.main,
    required this.pop,
  });

  @override
  List<Object?> get props => [dt, maxTemp, minTemp, main, pop];
}