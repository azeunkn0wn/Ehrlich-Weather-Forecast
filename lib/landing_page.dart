import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:weather_forcast/api/auth_api_controller.dart';
import 'package:weather_forcast/home_screen.dart';
import 'package:weather_forcast/login_screen.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AuthController authController = AuthController();

  late Future<bool> userLoginStatus;

  @override
  void initState() {
    super.initState();
    userLoginStatus = authController.isStored();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userLoginStatus,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        //TODO Issue: Future Builder not working as intended. This should load stored credentials and skip login page.
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var credentialsAreStored = snapshot.data!;
            if (credentialsAreStored) {
              return HomeScreen(user: authController.user);
            }
          }
          return LoginScreen(authController: authController);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
