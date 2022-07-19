import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/util/api.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  bool isLoggedIn = false;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  checkIsLoggedIn() async {
    var user = await Api.getCurrentUser();
    setState(() {
      isLoggedIn = user != null;
    });
  }

  @override
  void initState() {
    super.initState();

    checkIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.orange,
      ),
      home: isLoggedIn ? const HomePage() : const LoginPage(),
    );
  }
}
