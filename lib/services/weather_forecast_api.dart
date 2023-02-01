import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:weather_forcast/model/weather_model.dart';
import 'package:weather_forcast/services/weather_forecast_constants.dart';

class WeatherForecastApiService {
  Future<WeatherModel?> getWeather(
    String query,
  ) async {
    WeatherModel? result;

    Map<String, String> queryParameters = {
      'q': query,
      'appid': WeatherForecastApiConstants.apiKey
    };
    try {
      var url = Uri.parse(WeatherForecastApiConstants.baseUrl +
              WeatherForecastApiConstants.weatherEndpoint)
          .replace(queryParameters: queryParameters);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = WeatherModel.fromJson(await jsonDecode(response.body));
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }
}

/*
Mobile:
Date (mm/dd/yyyy) 
Temperature (F)

Desktop:
Date(mm/dd/yyyy)
Temp(F)
Description 
Main 
Pressure 
Humidity
*/