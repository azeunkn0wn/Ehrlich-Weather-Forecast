import 'dart:convert';

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
  final storage = const FlutterSecureStorage();

  Future<void> login() async {
    credentials = await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .login();
    debugPrint('logged in successfully ${credentials!.user.email}');
    user = credentials!.user;
    isLoggedIn = true;
    //TODO properly store each object.
    await storage.write(
        key: 'credentials', value: jsonEncode(credentials!.toMap()));

    debugPrint('credentials stored');
  }

  Future<void> logout() async {
    await auth0
        .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
        .logout();

    credentials = null;

    user = null;
    isLoggedIn = false;
    await storage.deleteAll();
  }

//TODO Issue: stored credential doesn't work.
  Future<bool> isStored() async {
    bool result = false;
    debugPrint('reading stored credentials');
    String? storedCredentials = await storage.read(key: 'credentials');
    debugPrint('found stored credentials $storedCredentials');

    if (storedCredentials != null && storedCredentials.isNotEmpty) {
      debugPrint('decoding credentials');
      credentials = Credentials.fromMap(await jsonDecode(
          storedCredentials)); //TODO Issue: future builder is done before this line, and returns null
      debugPrint('loading user with credentials ${credentials!.idToken}');
      user = await auth0.api.userProfile(accessToken: credentials!.accessToken);
      debugPrint(user!.address.toString());
      isLoggedIn = true;
      result = true;
    }
    print('isStored $result');
    return result;
  }
}

// class MyCredentials extends Credentials {
//   MyCredentials(
//       {required super.idToken,
//       required super.accessToken,
//       required super.expiresAt,
//       required super.user,
//       required super.tokenType,
//       super.refreshToken,
//       super.scopes});

//   Map<String, dynamic> toSecureStorage() {
//     Map<String, dynamic> map = {
//       'idToken': idToken,
//       'accessToken': accessToken,
//       'refreshToken': refreshToken,
//       'expiresAt': expiresAt.toIso8601String(),
//       'scopes': jsonEncode(scopes),
//       'tokenType': tokenType,
//     };
//     return map;
//   }

//   factory MyCredentials.fromSecureStorage(final Map<dynamic, dynamic> result) =>
//       MyCredentials(
//         idToken: result['idToken'] as String,
//         accessToken: result['accessToken'] as String,
//         refreshToken: result['refreshToken'] as String?,
//         expiresAt: DateTime.parse(result['expiresAt'] as String),
//         scopes: Set<String>.from(result['scopes'] as List<Object?>),
//         user: UserProfile.fromMap(Map<String, dynamic>.from(
//             result['userProfile'] as Map<dynamic, dynamic>)),
//         tokenType: result['tokenType'] as String,
//       );
// }
