import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/container.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/util/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static redirect(BuildContext context, Widget page,
      {bool removeHistory = false}) {
    if (removeHistory) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => page,
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    }
  }
}

class AuthHelper {
  static final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  static logout(BuildContext context) async {
    if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (await preferences.remove('auth_token')) {
      Helper.redirect(context, const LoginPage(), removeHistory: true);
    }
  }

  static Future<void> loginAndRedirect(body, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('auth_token', body['data']['token']);

    Helper.showSnackBar(context, 'Login Success!');
    Helper.redirect(context, const HomeContainer(), removeHistory: true);
  }

  static authWithGoogle(BuildContext context) async {
    try {
      final account = await googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await account.authentication;
        final response = await Api.request(
          'post',
          'auth/google',
          body: {
            'name': '${account.displayName}',
            'email': account.email,
            'access_token': '${googleSignInAuthentication.accessToken}'
          },
        );
        final body = json.decode(response.body);

        if (response.statusCode == 200) {
          await loginAndRedirect(body, context);
        } else {
          Helper.showSnackBar(context, body['message']);
        }
      }
    } catch (e) {
      Helper.showSnackBar(context, 'Error!');
    }
  }
}
