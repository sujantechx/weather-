import '../models/wwather_model.dart';
import '../services/api_service.dart';
import '../services/app_urls.dart';

class WeatherRepository {
  final ApiHelper apiHelper;
  // It's good practice to keep the API key here
  final String _apiKey = "80f839c75c3e82d61cb841401ad6b76b";

  WeatherRepository({required this.apiHelper});
  Future<WeatherData> fetchWeather({required double lat, required double lon}) async {
    // Construct URLs for both API calls
    final currentWeatherUrl = "${AppUrls.CURRENT_WEATHER}?lat=$lat&lon=$lon&units=metric&appid=$_apiKey";
    final forecastUrl = "${AppUrls.FIVE_DAY_FORECAST}?lat=$lat&lon=$lon&units=metric&appid=$_apiKey";

    try {
      // Make the two API calls in parallel
      final List<dynamic> responses = await Future.wait([
        apiHelper.getAPI(url: currentWeatherUrl),
        apiHelper.getAPI(url: forecastUrl),
      ]);

      final currentWeatherData = responses[0];
      final forecastData = responses[1];


      // Use the factory constructor from your model to parse and combine the two responses.
      return WeatherData.fromCombinedJson(currentWeatherData, forecastData);

    } catch (e) {
        rethrow;
    }
  }
}