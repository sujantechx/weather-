import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int _selectedDayIndex = 0; // 'Today' is selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('10-day forecast'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDaySelector(),
            const SizedBox(height: 24),
            _buildTodaySummary(),
            const SizedBox(height: 24),
            _buildSectionHeader('Hourly forecast'),
            const SizedBox(height: 12),
            _buildHourlyForecast(),
            const SizedBox(height: 24),
            _buildSectionHeader('Daily conditions'),
            const SizedBox(height: 12),
            _buildDailyConditionsGrid(),
            const SizedBox(height: 24),
            _buildSectionHeader('Hourly details'),
            const SizedBox(height: 12),
            _buildHourlyDetailsChart(),
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
    // Mock data for day chips
    final List<Map<String, dynamic>> days = [
      {'day': 'Today', 'temp': '84°/78°', 'icon': Icons.thunderstorm},
      {'day': 'Thu', 'temp': '86°/80°', 'icon': Icons.cloud},
      {'day': 'Fri', 'temp': '85°/80°', 'icon': Icons.thunderstorm_outlined},
      {'day': 'Sat', 'temp': '87°/80°', 'icon': Icons.wb_sunny},
      {'day': 'Sun', 'temp': '87°/80°', 'icon': Icons.wb_sunny_outlined},
      {'day': 'Mon', 'temp': '86°/79°', 'icon': Icons.cloud},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 80,
              margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == days.length - 1 ? 16 : 0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.3) : const Color(0xFF2D3645),
                borderRadius: BorderRadius.circular(20),
                border: isSelected ? Border.all(color: Colors.blue) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(days[index]['day']),
                  const SizedBox(height: 8),
                  Icon(days[index]['icon'], color: Colors.white),
                  const SizedBox(height: 8),
                  Text(days[index]['temp'], style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodaySummary() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Text('84°/78°', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300)),
              SizedBox(width: 16),
              Icon(Icons.thunderstorm, size: 48, color: Colors.yellow),
            ],
          ),
          SizedBox(height: 4),
          Text('Heavy thunderstorm', style: TextStyle(fontSize: 18, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    // This is similar to the home page's hourly forecast
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            width: 70,
            margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == 7 ? 16 : 0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3645),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(index == 0 ? 'Now' : '${10 + index} AM'),
                const Icon(Icons.thunderstorm_outlined, color: Colors.yellow),
                const Text('81°'),
                const Text('50%', style: TextStyle(color: Colors.lightBlueAccent)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyConditionsGrid() {
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
          _buildConditionCard('Max wind', '7 mph', 'Light · From southwest', Icons.air),
          _buildConditionCard('Average humidity', '90%', '', Icons.water_drop_outlined),
          _buildConditionCard('Max UV Index', '3', 'Moderate', Icons.wb_sunny_outlined),
          _buildConditionCard('Sunrise & sunset', '5:34 AM', 'Sunset: 6:10 PM', Icons.wb_twilight),
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
    );
  }

  Widget _buildHourlyDetailsChart() {
    // Mock data for the precipitation chart
    final List<Map<String, dynamic>> precipData = [
      {'time': 'Now', 'chance': 50, 'amount': 0.03},
      {'time': '10 AM', 'chance': 50, 'amount': 0.03},
      {'time': '11 AM', 'chance': 50, 'amount': 0.03},
      {'time': '12 PM', 'chance': 50, 'amount': 0.04},
      {'time': '1 PM', 'chance': 50, 'amount': 0.05},
      {'time': '2 PM', 'chance': 50, 'amount': 0.06},
      {'time': '3 PM', 'chance': 50, 'amount': 0.06},
      {'time': '4 PM', 'chance': 70, 'amount': 0.07},
    ];

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
                  // Using ChoiceChip for the toggle buttons
                  ChoiceChip(label: const Text('Precipitation'), selected: true, onSelected: (val){}, selectedColor: Colors.blue.withOpacity(0.4)),
                  ChoiceChip(label: const Text('Wind'), selected: false, onSelected: (val){}),
                  ChoiceChip(label: const Text('Humidity'), selected: false, onSelected: (val){}),
                ],
              ),
              const SizedBox(height: 16),
              const Text("Today's amount", style: TextStyle(color: Colors.white70)),
              const Text("0.58 in", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: precipData.length,
                    itemBuilder: (context, index) {
                      final item = precipData[index];
                      // Calculate bar height relative to max value (e.g., max is 0.07)
                      final barHeight = (item['amount'] / 0.08) * 60; // Max bar height of 60
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(item['amount'].toStringAsFixed(2)),
                            const SizedBox(height: 4),
                            Container(
                              width: 12,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('${item['chance']}%', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(item['time'], style: const TextStyle(fontSize: 12)),
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