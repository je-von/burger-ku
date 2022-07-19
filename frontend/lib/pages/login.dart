import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/register.dart';
import 'package:frontend/util/api.dart';
import 'package:frontend/util/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  String _errorField = "";
  String _errorMessage = "";

  final _ctrlEmail = TextEditingController();
  final _ctrlPassword = TextEditingController();

  void _validateLogin(BuildContext context) async {
    _errorField = "";
    _errorMessage = "";
    String email = _ctrlEmail.text;
    String password = _ctrlPassword.text;
    if (email.isEmpty) {
      _errorField = "EMAIL";
      _errorMessage = "Email must be filled!";
    } else if (password.isEmpty) {
      _errorField = "PASS";
      _errorMessage = "Password must be filled!";
    } else {
      final response = await Api.request('post', 'auth',
          body: {'email': email, 'password': password});
      final body = json.decode(response.body);
      print(body);
      if (response.statusCode == 200) {
        // print(body['data']['token']);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('auth_token', body['data']['token']);
        Helper.showSnackBar(context, 'Login Success!');
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Helper.showSnackBar(context, body['message']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(10),
                    border: const OutlineInputBorder(),
                    hintText: 'example@mail.com',
                    errorText: _errorField == 'EMAIL' ? _errorMessage : null,
                  ),
                  controller: _ctrlEmail,
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(10),
                    border: const OutlineInputBorder(),
                    hintText: '********',
                    errorText: _errorField == 'PASS' ? _errorMessage : null,
                  ),
                  controller: _ctrlPassword,
                ),
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _validateLogin(context);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.orange;
                      }
                      return Colors.orange.shade200;
                    }),
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _validateLogin(context);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey;
                      }
                      return Colors.grey.shade200;
                    }),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'CONTINUE WITH ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Image.asset(
                        'assets/google.png',
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) {
                      return const RegisterPage();
                    }),
                  );
                },
                child: const Text("Don't have an account? Register Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
