import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherForecastApiConstants {
  static String baseUrl = 'http://api.openweathermap.org';
  static String apiKey = dotenv.env['WEATHER_API_KEY']!;
  static String weatherEndpoint = '/data/2.5/weather';
}
