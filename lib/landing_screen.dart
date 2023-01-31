import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LandingScreen extends StatefulWidget {
  final Auth0? auth0;
  LandingScreen({this.auth0, Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Credentials? _credentials;
  UserProfile? _user;
  late Auth0 auth0;

  static const String landingPageMessage =
      'Welcome to the weather forecast web application. Please login with your Github user to use the application and view the  weather in your city';

  @override
  void initState() {
    super.initState();
    auth0 = widget.auth0 ??
        Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
  }

  Future<void> login() async {
    var credentials = await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .login();

    print(credentials.user.email.toString());

    setState(() {
      _credentials = credentials;
      _user = credentials.user;
    });
  }

  Future<void> logout() async {
    await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .logout();

    setState(() {
      _credentials = null;
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.cloud),
        title: Text('Weather Forecast'),
        actions: [
          Visibility(
            visible: _credentials == null ? false : true,
            child: ElevatedButton(
              onPressed: logout,
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
              visible: _credentials == null ? true : false,
              child: ElevatedButton(
                onPressed: login,
                child: const Text("Log in"),
              ))
        ],
      ),
    );
  }
}
