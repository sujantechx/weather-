import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/remote_data/models/wwather_model.dart';
import '../ui/home.dart'; // For the getWeatherIcon function

// Enum to manage the state of the details chart
enum DetailChartType { precipitation, wind, humidity }

class DetailsPage extends StatefulWidget {
  // Accept the full weather data and the initially selected index
  final WeatherData weatherData;
  final int initialIndex;

  const DetailsPage({
    super.key,
    required this.weatherData,
    required this.initialIndex,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late int _selectedDayIndex;
  DetailChartType _selectedDetail = DetailChartType.precipitation;

  @override
  void initState() {
    super.initState();
    // Initialize the selected day with the index passed from the home page
    _selectedDayIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // Get the data for the currently selected day
    final selectedDay = widget.weatherData.daily[_selectedDayIndex];

    // Filter the hourly forecast to only show hours for the selected day
    final hourlyForSelectedDay = widget.weatherData.hourly.where((h) {
      final hDate = DateTime.fromMillisecondsSinceEpoch(h.dt * 1000);
      final sDate = DateTime.fromMillisecondsSinceEpoch(selectedDay.dt * 1000);
      return hDate.day == sDate.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast Details'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySelector(),
            const SizedBox(height: 24),
            _buildTodaySummary(selectedDay),
            const SizedBox(height: 24),
            _buildSectionHeader('Hourly forecast'),
            const SizedBox(height: 12),
            _buildHourlyForecast(hourlyForSelectedDay),
            const SizedBox(height: 24),
            _buildSectionHeader('Daily conditions'),
            const SizedBox(height: 12),
            _buildDailyConditionsGrid(selectedDay),
            const SizedBox(height: 24),
            _buildSectionHeader('Hourly details'),
            const SizedBox(height: 12),
            _buildHourlyDetailsChart(hourlyForSelectedDay),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDaySelector() {
    final daily = widget.weatherData.daily;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daily.length,
        itemBuilder: (context, index) {
          final dayData = daily[index];
          final date = DateTime.fromMillisecondsSinceEpoch(dayData.dt * 1000);
          final dayString = index == 0 ? 'Today' : DateFormat('EEE').format(date);
          bool isSelected = _selectedDayIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 80,
              margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == daily.length - 1 ? 16 : 0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.3) : const Color(0xFF2D3645),
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? Border.all(color: Colors.blue) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dayString),
                  const SizedBox(height: 8),
                  Icon(getWeatherIcon(dayData.main), color: Colors.white),
                  const SizedBox(height: 8),
                  Text('${dayData.maxTemp.round()}°/${dayData.minTemp.round()}°', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodaySummary(DailyForecast selectedDay) {
    final date = DateTime.fromMillisecondsSinceEpoch(selectedDay.dt * 1000);
    final dayString = _selectedDayIndex == 0 ? 'Today' : DateFormat('EEEE').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dayString, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${selectedDay.maxTemp.round()}°/${selectedDay.minTemp.round()}°', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300)),
              const SizedBox(width: 16),
              Icon(getWeatherIcon(selectedDay.main), size: 48, color: Colors.yellow),
            ],
          ),
          const SizedBox(height: 4),
          Text(selectedDay.main, style: const TextStyle(fontSize: 18, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast(List<HourlyForecast> hourly) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        itemBuilder: (context, index) {
          final item = hourly[index];
          return Container(
            width: 70,
            margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == hourly.length - 1 ? 16 : 0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3645),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(DateFormat.j().format(DateTime.fromMillisecondsSinceEpoch(item.dt * 1000))),
                Icon(getWeatherIcon(item.main), color: Colors.yellow),
                Text('${item.temp.round()}°'),
                Text('${item.pop}%', style: const TextStyle(color: Colors.lightBlueAccent)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyConditionsGrid(DailyForecast selectedDay) {
    final isToday = _selectedDayIndex == 0;
    final current = widget.weatherData.current;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.5,
        children: [
          _buildConditionCard('Max wind', isToday ? '${current.windSpeed.toStringAsFixed(1)} mph' : 'N/A', '', Icons.air),
          _buildConditionCard('Humidity', isToday ? '${current.humidity}%' : 'N/A', '', Icons.water_drop_outlined),
          _buildConditionCard('UV Index', isToday ? '${current.uvi}' : 'N/A', isToday ? 'Moderate' : '', Icons.wb_sunny_outlined),
          _buildConditionCard('Sunrise', DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(current.sunrise * 1000)), 'Sunset: ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(current.sunset * 1000))}', Icons.wb_twilight),
        ],
      ),
    );
  }

  Widget _buildConditionCard(String title, String value, String subtitle, IconData icon) {
    return Card(
      color: const Color(0xFF2D3645),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // Wrap the Column with SingleChildScrollView
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[400])),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(subtitle, style: TextStyle(color: Colors.grey[400])),
              ],
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHourlyDetailsChart(List<HourlyForecast> hourly) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: const Text('Precipitation'),
                    selected: _selectedDetail == DetailChartType.precipitation,
                    onSelected: (val) => setState(() => _selectedDetail = DetailChartType.precipitation),
                    selectedColor: Colors.blue.withOpacity(0.4),
                  ),
                  ChoiceChip(
                    label: const Text('Wind'),
                    selected: _selectedDetail == DetailChartType.wind,
                    onSelected: (val) => setState(() => _selectedDetail = DetailChartType.wind),
                    selectedColor: Colors.blue.withOpacity(0.4),
                  ),
                  ChoiceChip(
                    label: const Text('Humidity'),
                    selected: _selectedDetail == DetailChartType.humidity,
                    onSelected: (val) => setState(() => _selectedDetail = DetailChartType.humidity),
                    selectedColor: Colors.blue.withOpacity(0.4),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 150,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourly.length,
                    itemBuilder: (context, index) {
                      final item = hourly[index];
                      double value;
                      double maxValue;
                      String valueText;

                      switch(_selectedDetail) {
                        case DetailChartType.precipitation:
                          value = item.pop.toDouble();
                          maxValue = 100;
                          valueText = '${item.pop}%';
                          break;
                        case DetailChartType.wind:
                          value = item.windSpeed;
                          maxValue = 25; // Assume max for UI scaling
                          valueText = item.windSpeed.toStringAsFixed(1);
                          break;
                        case DetailChartType.humidity:
                          value = item.humidity.toDouble();
                          maxValue = 100;
                          valueText = '${item.humidity}%';
                          break;
                      }

                      final barHeight = (value / maxValue) * 80; // Increased max bar height

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(valueText),
                            const SizedBox(height: 4),
                            Container(
                              width: 12,
                              height: barHeight.clamp(0, 80),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(DateFormat.j().format(DateTime.fromMillisecondsSinceEpoch(item.dt * 1000)), style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}