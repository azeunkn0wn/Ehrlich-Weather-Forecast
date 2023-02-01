import 'package:flutter/material.dart';
import 'package:weather_forcast/controller/auth_api_controller.dart';
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
    return Scaffold(
      body: FutureBuilder(
        future: userLoginStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var credentialsAreStored = snapshot.data!;
              if (credentialsAreStored) {
                return HomeScreen(authController: authController);
              }
            }
            return LoginScreen(authController: authController);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
