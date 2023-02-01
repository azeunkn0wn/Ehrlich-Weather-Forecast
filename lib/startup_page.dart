import 'package:flutter/material.dart';
import 'package:weather_forcast/controller/auth_api_controller.dart';
import 'package:weather_forcast/home_screen.dart';
import 'package:weather_forcast/landing_screen.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({Key? key}) : super(key: key);

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  AuthController authController = AuthController();

  late Future<bool> validUserCredentialExist;

  @override
  void initState() {
    super.initState();
    validUserCredentialExist = authController.loadStoredCredential();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: validUserCredentialExist,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var credentialsAreStored = snapshot.data!;
              if (credentialsAreStored) {
                return HomeScreen(authController: authController);
              }
            }
            return LandingScreen(authController: authController);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
