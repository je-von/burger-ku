import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/util/api.dart';
import 'package:frontend/util/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  String _errorField = "";
  String _errorMessage = "";

  final _ctrlName = TextEditingController();
  final _ctrlEmail = TextEditingController();
  final _ctrlPassword = TextEditingController();
  final _ctrlConfirmPassword = TextEditingController();

  void _validateLogin(BuildContext context) async {
    _errorField = "";
    _errorMessage = "";
    String name = _ctrlName.text;
    String email = _ctrlEmail.text;
    String password = _ctrlPassword.text;
    String confirmPassword = _ctrlConfirmPassword.text;
    if (name.isEmpty) {
      _errorField = "NAME";
      _errorMessage = "Name must be filled!";
    } else if (email.isEmpty) {
      _errorField = "EMAIL";
      _errorMessage = "Email must be filled!";
    } else if (!email.contains('@') || !email.endsWith('.com')) {
      _errorField = "EMAIL";
      _errorMessage = "Email must be in a valid format!";
    } else if (password.isEmpty) {
      _errorField = "PASS";
      _errorMessage = "Password must be filled!";
    } else if (password.length < 8) {
      _errorField = "PASS";
      _errorMessage = "Password must be at least 8 characters!";
    } else if (!RegExp(r".*[A-Z].*").hasMatch(password) ||
        !RegExp(r".*[a-z].*").hasMatch(password) ||
        !RegExp(r".*[0-9].*").hasMatch(password) ||
        !RegExp(r"[A-Za-z0-9]*").hasMatch(password)) {
      _errorField = "PASS";
      _errorMessage = "Password must be alphanumeric!";
    } else if (confirmPassword != password) {
      _errorField = "CONFIRM_PASS";
      _errorMessage = "Confirm password doesn't match password!";
    } else {
      // _errorField = "PASS";
      // _errorMessage = "dah!";
      // User? user = null;
      // globals.users.forEach((u) {
      //   if (u.email == email && u.password == password) {
      //     user = u;
      //     return;
      //   }
      // });
      // if (user == null) {
      //   _errorField = "PASS";
      //   _errorMessage = "Email or Password are incorrect!";
      // } else {
      //   //Login success
      //   _errorField = _errorMessage = "";
      //   globals.currentUser = user;
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (builder) {
      //       return HomePage();
      //     }),
      //   );
      //   return;
      // }

      final response = await Api.request('post', 'register',
          body: {'name': name, 'email': email, 'password': password});
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        Helper.showSnackBar(context, 'Register Success!');
      } else {
        Helper.showSnackBar(context, body['message']);
      }
      // print(response);
    }
    // print(_errorMessage);
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
                    'Name',
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
                    hintText: 'John Doe',
                    errorText: _errorField == 'NAME' ? _errorMessage : null,
                  ),
                  controller: _ctrlName,
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
              Row(
                children: const [
                  Text(
                    'Confirm Password',
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
                    errorText:
                        _errorField == 'CONFIRM_PASS' ? _errorMessage : null,
                  ),
                  controller: _ctrlConfirmPassword,
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
                    'REGISTER',
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
                      return const LoginPage();
                    }),
                  );
                },
                child: const Text("Already have an account? Login Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
