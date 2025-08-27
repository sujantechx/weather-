// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://api.openweathermap.org/data/3.0/onecall";
  final String apiKey = "80f839c75c3e82d61cb841401ad6b76b"; // Your API Key

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final url = Uri.parse("$baseUrl?lat=$lat&lon=$lon&units=metric&exclude=minutely&appid=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch weather data");
    }
  }
}