class WeatherForecastApiConstants {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String baseUrl = 'http://api.openweathermap.org';
  static String apiKey = '9868dbc5f1d48a2099e663ab701bc5cf';
  static String weatherEndpoint = '/data/2.5/weather';
}
