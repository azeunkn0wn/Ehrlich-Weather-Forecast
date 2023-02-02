import 'package:flutter/material.dart';
import 'package:weather_forecast/services/auth_api.dart';
import 'package:weather_forecast/home_screen.dart';
import 'package:weather_forecast/landing_screen.dart';

class StartUpPage extends StatefulWidget {
  const StartUpPage({Key? key}) : super(key: key);

  @override
  State<StartUpPage> createState() => _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  AuthApiService authService = AuthApiService();

  late Future<bool> validUserCredentialExist;

  @override
  void initState() {
    super.initState();
    validUserCredentialExist = authService.loadStoredCredential();
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
                return HomeScreen(authService: authService);
              }
            }
            return LandingScreen(authService: authService);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
