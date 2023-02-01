import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:weather_forcast/api/auth_api_controller.dart';
import 'package:weather_forcast/login_screen.dart';
import 'package:weather_forcast/model/weather_model.dart';
import 'package:weather_forcast/services/weather_forecast_api.dart';
import 'package:weather_forcast/weather_screen.dart';

class HomeScreen extends StatefulWidget {
  final AuthController authController;

  const HomeScreen({final Key? key, required this.authController})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final UserProfile user;
  final TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    user = widget.authController.user!;
    _searchBarController.text = '';
    super.initState();
  }

  Future<void> _logout() async {
    await widget.authController.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => LoginScreen(
            authController: widget.authController,
          ),
        ),
      );
    }
  }

  void getWeather(String query) async {
    WeatherForecastApiService api = WeatherForecastApiService();
    WeatherModel? weather = await api.getWeather(query);
    if (weather != null) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                WeatherScreen(weather, authController: widget.authController),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var margin = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.15,
    );

    return Scaffold(
        appBar: AppBar(
            leading: const Icon(Icons.cloud),
            title: const Text('Weather Forecast'),
            actions: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      elevation: 10),
                  onPressed: _logout,
                  child: const Text('Logout'),
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 10))
            ]),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  user.name.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('https://github.com/${user.nickname.toString()}'),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30)),
              Container(
                margin: margin,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'City',
                    border: OutlineInputBorder(
                        gapPadding: 0, borderRadius: BorderRadius.circular(20)),
                  ),
                  controller: _searchBarController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                    onPressed: () =>
                        getWeather(_searchBarController.value.text),
                    child: const Text('Display Weather')),
              )
            ],
          ),
        ));
  }
}
