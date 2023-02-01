import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unities_helper/unities_helper.dart';
import 'package:weather_forcast/api/auth_api_controller.dart';
import 'package:weather_forcast/login_screen.dart';
import 'package:weather_forcast/model/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen(this.weather, {Key? key, required this.authController})
      : super(key: key);

  final WeatherModel weather;
  final AuthController authController;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
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

  //TODO weather grid display
  @override
  Widget build(BuildContext context) {
    double temperatureF = convert<Temperature>(
      Temperature.kelvin, // from
      Temperature.fahrenheit, // to
      widget.weather.main!.temp, // value
    );

    var date = DateFormat('mm/dd/yyyy').format(DateTime.now());
    return Scaffold(
      // drawer: const MainDrawer(), //TODO drawer for easy navigation
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
            const Padding(padding: EdgeInsets.only(top: 20)),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Date (mm/dd/yyyy)',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Temperature (F)',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(date)),
                    DataCell(Text(temperatureF.toStringAsFixed(2))),
                  ],
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15),
                  child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Back')),
                ),
                Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
