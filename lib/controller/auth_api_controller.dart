import 'dart:convert';
import 'dart:developer';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController {
  AuthController({
    Key? key,
  });

  static Auth0 auth0 =
      Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  bool isLoggedIn = false;

  late Credentials? credentials;
  late UserProfile? user;
  final _storage = const FlutterSecureStorage();

  Future<void> login() async {
    credentials = await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .login();

    user = credentials!.user;
    isLoggedIn = true;

    await _storage.write(
        key: 'credentials', value: jsonEncode(credentials!.toMap()));
  }

  Future<void> logout() async {
    await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .logout();

    credentials = null;

    user = null;
    isLoggedIn = false;
    await _storage.deleteAll();
  }

  Future<bool> loadStoredCredential() async {
    bool result = false;
    String? storedCredentials = await _storage.read(key: 'credentials');

    if (storedCredentials != null && storedCredentials.isNotEmpty) {
      try {
        Map credentialsMap = await jsonDecode(storedCredentials);
        user = await auth0.api
            .userProfile(accessToken: credentialsMap['accessToken'] as String);

        credentials = Credentials(
          idToken: credentialsMap['idToken'] as String,
          accessToken: credentialsMap['accessToken'] as String,
          refreshToken: credentialsMap['refreshToken'] as String?,
          expiresAt: DateTime.parse(credentialsMap['expiresAt'] as String),
          scopes: Set<String>.from(credentialsMap['scopes'] as List<Object?>),
          user: user!,
          tokenType: credentialsMap['tokenType'] as String,
        );

        isLoggedIn = true;
        result = true;
      } catch (e) {
        log(e.toString());
      }
    }
    return result;
  }
}
