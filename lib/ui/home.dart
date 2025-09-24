
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../data/remote_data/models/wwather_model.dart';
import '../logic/weather_cubit.dart';
import '../logic/weather_state.dart';
import 'detelsh_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading || state is WeatherInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WeatherCubit>().refreshWeather();
                    },
                    child: const Text('Try Again'),
                  )
                ],
              ),
            );
          }
          if (state is WeatherLoaded) {
            final weather = state.weather;
            return buildWeatherUI(context, weather);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget buildWeatherUI(BuildContext context, WeatherData weather) {
    return RefreshIndicator(
      onRefresh: () => context.read<WeatherCubit>().refreshWeather(),
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Color(0xFF212832),
            pinned: true,
            title: Text(
              'Angul, Odisha',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SliverToBoxAdapter(child: CurrentWeatherSection(current: weather.current)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(child: HourlyForecastSection(hourly: weather.hourly)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          DailyForecastSection(weatherData: weather),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Current conditions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          CurrentConditionsGrid(current: weather.current),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          SliverToBoxAdapter(child: SunriseSunsetSection(current: weather.current)),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }}


// Helper function to map weather conditions to icons
IconData getWeatherIcon(String mainCondition) {
  switch (mainCondition) {
    case 'Thunderstorm':
      return Icons.thunderstorm;
    case 'Drizzle':
    case 'Rain':
      return Icons.umbrella;
    case 'Snow':
      return Icons.snowing;
    case 'Clear':
      return Icons.wb_sunny;
    case 'Clouds':
      return Icons.cloud;
    default:
      return Icons.cloud_outlined;
  }
}


// MARk Updated Widgets to accept real data

class CurrentWeatherSection extends StatelessWidget {
  final CurrentWeather current;
  const CurrentWeatherSection({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${current.temp.round()}°', style: const TextStyle(fontSize: 86, fontWeight: FontWeight.w200)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Icon(getWeatherIcon(current.main), color: Colors.yellow, size: 32),
                  const SizedBox(height: 5),
                  Text(current.description, style: TextStyle(color: Colors.grey[400])),
                  Text('Feels like ${current.feelsLike.round()}°', style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HourlyForecastSection extends StatelessWidget {
  final List<HourlyForecast> hourly;
  const HourlyForecastSection({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Hourly forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 24, // Show next 24 hours
            itemBuilder: (context, index) {
              final item = hourly[index];
              return Container(
                width: 70,
                margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == 23 ? 16 : 0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: const Color(0xFF2D3645), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(index == 0 ? 'Now' : DateFormat.j().format(DateTime.fromMillisecondsSinceEpoch(item.dt * 1000))),
                    Icon(getWeatherIcon(item.main), color: Colors.yellow),
                    Text('${item.temp.round()}°'),
                    Text('${item.pop}%', style: const TextStyle(color: Colors.lightBlueAccent)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class DailyForecastSection extends StatelessWidget {
  final WeatherData weatherData; // Add this to receive the full weather data
  const DailyForecastSection({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    // The list now uses the real data from weatherData.daily
    final daily = weatherData.daily;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final item = daily[index];
          final date = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
          String dayString = index == 0 ? 'Today' : DateFormat('EEEE').format(date);

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  // Pass the full weather data and the selected index
                  weatherData: weatherData,
                  initialIndex: index,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 150, child: Text(dayString, style: const TextStyle(fontSize: 16))),
                  Row(
                    children: [
                      Icon(getWeatherIcon(item.main), color: Colors.yellow),
                      const SizedBox(width: 8),
                      Text('${item.pop}%', style: const TextStyle(color: Colors.lightBlueAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      Text('${item.maxTemp.round()}°', style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text('${item.minTemp.round()}°', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        childCount: daily.length,
      ),
    );
  }
}

// DailyForecastSection(daily: weather.daily) DailyForecastSection(weatherData: weather)
class CurrentConditionsGrid extends StatelessWidget {
  final CurrentWeather current;
  const CurrentConditionsGrid({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.2),
        delegate: SliverChildListDelegate([
          // The data is passed to the build method below
          _buildConditionCard('Wind', '${current.windSpeed.toStringAsFixed(1)} mph', '', Icons.air),
          _buildConditionCard('Humidity', '${current.humidity}%', '', Icons.water_drop_outlined),
          _buildConditionCard('UV Index', '${current.uvi}', 'Moderate', Icons.wb_sunny_outlined),
          _buildConditionCard('Pressure', '${current.pressure.toStringAsFixed(2)} inHg', '', Icons.arrow_downward),
        ]),
      ),
    );
  }

  /// Builds a single styled card for the grid.
  Widget _buildConditionCard(String title, String value, String subtitle, IconData icon) {
    return Card(
      color: const Color(0xFF2D3645),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Arrange elements vertically
          children: [
            // Row for Icon and Title
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: Colors.grey[400])),
              ],
            ),
            const Spacer(), // Pushes the value and subtitle down

            // Main value text
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300)),
            const SizedBox(height: 4),

            // Subtitle text (only shows if subtitle is not empty)
            if (subtitle.isNotEmpty)
              Text(subtitle, style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }
}


class SunriseSunsetSection extends StatelessWidget {
  final CurrentWeather current;
  const SunriseSunsetSection({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    // These text formatters are correct
    final sunriseTime = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(current.sunrise * 1000));
    final sunsetTime = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(current.sunset * 1000));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: const Color(0xFF2D3645),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sunrise & sunset', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: CustomPaint(
                  // Pass the real sunrise and sunset data to the painter
                  painter: SunriseSunsetPainter(
                    sunrise: current.sunrise,
                    sunset: current.sunset,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sunrise: $sunriseTime'),
                  Text('Sunset: $sunsetTime'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


// MARK: - Updated Custom Painter for Sunrise Arc
class SunriseSunsetPainter extends CustomPainter {
  final int sunrise; // Sunrise time in UNIX seconds
  final int sunset;  // Sunset time in UNIX seconds

  SunriseSunsetPainter({required this.sunrise, required this.sunset});

  @override
  void paint(Canvas canvas, Size size) {
    final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final totalDaylight = sunset - sunrise;
    final elapsedTime = now - sunrise;

    // Calculate progress as a value between 0.0 (sunrise) and 1.0 (sunset)
    // .clamp() ensures the value stays within this range, even before sunrise or after sunset.
    final double progress = (elapsedTime / totalDaylight).clamp(0.0, 1.0);

    final paint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -size.height * 0.8, size.width, size.height);
    canvas.drawPath(path, paint);

    // --- Draw the Highlighted Arc based on progress ---
    final ui.PathMetric pathMetric = path.computeMetrics().first;
    final Path extractedPath = pathMetric.extractPath(0.0, pathMetric.length * progress);

    final highlightedPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(extractedPath, highlightedPaint);

    // --- Draw the Sun at the correct position ---
    final sunPosition = pathMetric.getTangentForOffset(pathMetric.length * progress);

    if (sunPosition != null) {
      final sunPaint = Paint()..color = Colors.yellow;
      canvas.drawCircle(sunPosition.position, 8, sunPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SunriseSunsetPainter oldDelegate) {
    // Repaint if the sunrise or sunset times change (e.g., data refresh for a new day)
    return oldDelegate.sunrise != sunrise || oldDelegate.sunset != sunset;
  }
}


