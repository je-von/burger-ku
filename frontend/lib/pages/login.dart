import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';
import 'package:frontend/pages/container.dart';
import 'package:frontend/pages/register.dart';
import 'package:frontend/util/api.dart';
import 'package:frontend/util/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      final response = await Api.request(
        'post',
        'auth',
        body: {'email': email, 'password': password},
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('auth_token', body['data']['token']);

        // to prevent error (use_build_context_synchronously)
        if (!mounted) return;

        Helper.showSnackBar(context, 'Login Success!');
        Helper.redirect(context, const HomeContainer(), removeHistory: true);
      } else {
        if (!mounted) return;
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
              const LogoWidget(),
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
                    Helper.redirect(context, const GoogleWebView());
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
                  Helper.redirect(context, const RegisterPage());
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

class GoogleWebView extends StatefulWidget {
  const GoogleWebView({Key? key}) : super(key: key);

  @override
  State<GoogleWebView> createState() => _GoogleWebViewState();
}

class _GoogleWebViewState extends State<GoogleWebView> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign in with Google'),
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            userAgent: 'random',
            initialUrl: '${Api.backendUrl}auth/google',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              // _controller.complete(webViewController);
              _controller = controller;
            },
            // navigationDelegate: (NavigationRequest request) {
            //   if (request.url.contains('auth/google/success') ||
            //       request.url.contains('auth/google/failure')) {
            //     print('blocking navigation to $request}');
            //     return NavigationDecision.prevent;
            //   }
            //   print('allowing navigation to $request');
            //   return NavigationDecision.navigate;
            // },
            // onPageStarted: (String url) {
            //   print('Page started loading: $url');
            // },
            onPageFinished: (String url) async {
              print('Page finished loading: $url');
              if (url.contains('auth/google/success') ||
                  url.contains('auth/google/failure')) {
                final response = await _controller.runJavascriptReturningResult(
                    "document.documentElement.innerText");
                print(json.decode(response));
              }
            },
            gestureNavigationEnabled: true,
          );
        }));
  }
}
