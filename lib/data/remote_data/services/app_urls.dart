class AppUrls {
  // Base URL for the free tier API
  static const String BASE_URL = "https://api.openweathermap.org/data/2.5/";

  // Endpoint for current weather data
  static const String CURRENT_WEATHER = "${BASE_URL}weather";

  // Endpoint for 5-day / 3-hour forecast data
  static const String FIVE_DAY_FORECAST = "${BASE_URL}forecast";
}