import 'package:flutter/material.dart';
import 'package:weather_forcast/controller/auth_api_controller.dart';
import 'package:weather_forcast/home_screen.dart';
import 'package:weather_forcast/login_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
