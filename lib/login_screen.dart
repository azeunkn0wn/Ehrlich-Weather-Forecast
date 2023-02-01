import 'package:flutter/material.dart';
import 'package:weather_forcast/api/auth_api_controller.dart';
import 'package:weather_forcast/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  const LoginScreen({required this.authController, Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool userIsLoggedIn;
  late AuthController authController;
  static const String landingPageMessage =
      'Welcome to the weather forecast web application. Please login with your Github user to use the application and view the  weather in your city';

  late Widget currentPage;
  @override
  void initState() {
    authController = widget.authController;
    userIsLoggedIn = authController.isLoggedIn;
    super.initState();
  }

  Future<void> _login() async {
    await authController.login();
    setState(() {
      userIsLoggedIn = authController.isLoggedIn;
    });
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              HomeScreen(authController: authController),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('userIsLoggedIn = $userIsLoggedIn');

    var margin = EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.15,
    );
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.cloud),
        title: const Text('Weather Forecast'),
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(bottom: 100)),
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: margin,
                child: const Text(
                  landingPageMessage,
                  softWrap: true,
                  maxLines: 5,
                  textAlign: TextAlign.left,
                )),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 30)),
          Container(
            margin: margin,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Log in"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
