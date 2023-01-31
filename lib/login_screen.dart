import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:weather_forcast/api/auth_api_controller.dart';
import 'package:weather_forcast/drawer/drawer.dart';
import 'package:weather_forcast/home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  const LoginScreen({required this.authController, Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool userIsLoggedIn;
  late UserProfile? user;
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
              UserWidget(user: authController.user),
        ),
      );
    }
  }

  Future<void> _logout() async {
    await authController.logout();
    setState(() {
      userIsLoggedIn = authController.isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('userIsLoggedIn = $userIsLoggedIn');
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        leading: Icon(Icons.cloud),
        title: Text('Weather Forecast'),
        actions: [
          Visibility(
            visible: userIsLoggedIn,
            child: ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                landingPageMessage,
                softWrap: true,
                maxLines: 5,
                textAlign: TextAlign.left,
              )),
          // loginButton(),
          Visibility(
              visible: !userIsLoggedIn,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text("Log in"),
              ))
        ],
      ),
    );
  }
}
