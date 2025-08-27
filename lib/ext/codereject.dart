/*
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'detelsh_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using CustomScrollView to combine different types of scrollable elements
      body: CustomScrollView(
        slivers: [
          // SliverAppBar gives us the floating app bar effect
          const SliverAppBar(
            backgroundColor: Color(0xFF212832),
            pinned: true,
            title: Text(
              'Antarbatia, Odisha 760..',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              )
            ],
          ),
          // A Sliver that contains a single non-scrollable widget
          const SliverToBoxAdapter(child: CurrentWeatherSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(child: HourlyForecastSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          // Using SliverList for the 10-day forecast
           DailyForecastSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Current conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          // Using SliverGrid for the conditions grid
          const CurrentConditionsGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(child: SunriseSunsetSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}*/
/*
// MARK: - Current Weather Section
class CurrentWeatherSection extends StatelessWidget {
  const CurrentWeatherSection({super.key});

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
              const Text(
                '81°',
                style: TextStyle(fontSize: 86, fontWeight: FontWeight.w200),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Icon(Icons.thunderstorm, color: Colors.yellow, size: 32),
                  const SizedBox(height: 5),
                  Text(
                    'Light thunderstorms and rain',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  Text(
                    'Feels like 90°',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Placeholder for the frog illustration
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '🐸 Illustration Placeholder',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Hourly Forecast Section
class HourlyForecastSection extends StatelessWidget {
  const HourlyForecastSection({super.key});

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
            itemCount: 8, // Example count
            itemBuilder: (context, index) {
              return Container(
                width: 70,
                margin: EdgeInsets.only(left: index == 0 ? 16 : 8, right: index == 7 ? 16: 0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3645),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(index == 0 ? 'Now' : '${12 + index} PM'),
                    const Icon(Icons.thunderstorm_outlined, color: Colors.yellow),
                    const Text('82°'),
                    const Text('50%', style: TextStyle(color: Colors.lightBlueAccent)),
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
// MARK: - Daily Forecast Section (IN main.dart)
class DailyForecastSection extends StatelessWidget {
   DailyForecastSection({super.key});

  // Mock data
  final List<Map<String, dynamic>> dailyData = const [
    {'day': 'Today', 'chance': '70%', 'high': 84, 'low': 78, 'icon': Icons.thunderstorm},
    {'day': 'Thursday, Aug 28', 'chance': '30%', 'high': 86, 'low': 80, 'icon': Icons.cloud},
    {'day': 'Friday, Aug 29', 'chance': '50%', 'high': 85, 'low': 80, 'icon': Icons.thunderstorm},
    {'day': 'Saturday, Aug 30', 'chance': '40%', 'high': 87, 'low': 80, 'icon': Icons.thunderstorm_outlined},
    {'day': 'Sunday, Aug 31', 'chance': '80%', 'high': 87, 'low': 80, 'icon': Icons.thunderstorm},
  ];

   @override
   Widget build(BuildContext context) {
     return SliverList(
       delegate: SliverChildBuilderDelegate(
             (context, index) {
           final data = dailyData[index];
           // Wrap the row in a GestureDetector to handle taps
           return GestureDetector(
             onTap: () {
               // Navigate to the DetailsPage
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const DetailsPage()),
               );
             },
             child: Padding( // This Padding widget was already here
               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   SizedBox(
                       width: 150,
                       child: Text(data['day'], style: const TextStyle(fontSize: 16))),
                   Row(
                     children: [
                       Icon(data['icon'], color: Colors.yellow),
                       const SizedBox(width: 8),
                       Text(data['chance'], style: const TextStyle(color: Colors.lightBlueAccent)),
                     ],
                   ),
                   Row(
                     children: [
                       Text('${data['high']}°', style: const TextStyle(fontSize: 16)),
                       const SizedBox(width: 8),
                       Text('${data['low']}°', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                     ],
                   )
                 ],
               ),
             ),
           );
         },
         childCount: dailyData.length,
       ),
     );
   }

}


// MARK: - Current Conditions Grid
class CurrentConditionsGrid extends StatelessWidget {
  const CurrentConditionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.2, // Adjust aspect ratio for card height
        ),
        delegate: SliverChildListDelegate([
          _buildConditionCard('Wind', '4 mph', 'Light · From north', Icons.air),
          _buildConditionCard('Humidity', '89%', 'Dew point 78°', Icons.water_drop_outlined),
          _buildConditionCard('UV Index', '3', 'Moderate', Icons.wb_sunny_outlined),
          _buildConditionCard('Pressure', '29.59 inHg', 'Low  High', Icons.arrow_downward),
        ]),
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
          children: [
            Text(title, style: TextStyle(color: Colors.grey[400])),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.grey[400])),
            // In a real app, you would have custom painter widgets for the gauges here.
          ],
        ),
      ),
    );
  }
}

// MARK: - Sunrise & Sunset Section
class SunriseSunsetSection extends StatelessWidget {
  const SunriseSunsetSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Using a CustomPaint widget to draw the arc
                child: CustomPaint(
                  painter: SunriseSunsetPainter(),
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sunrise: 5:34 AM'),
                  Text('Sunset: 6:10 PM'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// MARK: - Custom Painter for Sunrise Arc
class SunriseSunsetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Define the path for the semi-circle arc
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -size.height * 0.8, size.width, size.height);

    // Draw the background arc
    canvas.drawPath(path, paint);

    // This is where you would calculate the sun's current position on the arc.
    // For this example, let's hardcode a position around 70% of the way.
    final metrics = path.computeMetrics().first;
    final sunPosition = metrics.getTangentForOffset(metrics.length * 0.7); // 70% progress
    final sunOffset = sunPosition!.position;

    // Draw the highlighted part of the arc
    final highlightedPath = Path();
    highlightedPath.moveTo(0, size.height);
    final Rect arcRect = Rect.fromLTRB(0, -size.height * 0.8 + size.height, size.width, size.height*2 -size.height * 0.8);
    highlightedPath.addArc(arcRect, 3.14, -3.14*0.7);

    final highlightedPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Extract a sub-path for the highlighted section
    final ui.PathMetric pathMetric = path.computeMetrics().first;
    final Path extracted = pathMetric.extractPath(0.0, pathMetric.length * 0.7);
    canvas.drawPath(extracted, highlightedPaint);


    // Draw the sun circle
    final sunPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(sunOffset, 8, sunPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Set to true if it needs to animate
  }
}
*/