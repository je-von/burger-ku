import 'package:flutter/material.dart';
import 'package:frontend/util/api.dart';

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

  dynamic auth(String email, String password) {}

  void _validateLogin(BuildContext context) async {
    String email = _ctrlEmail.text;
    String password = _ctrlPassword.text;
    if (email.isEmpty) {
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
      // } else if (!RegExp(r".*[A-Z].*").hasMatch(password) ||
      //     !RegExp(r".*[a-z].*").hasMatch(password) ||
      //     !RegExp(r".*[0-9].*").hasMatch(password) ||
      //     !RegExp(r"[A-Za-z0-9]*").hasMatch(password)) {
      //   _errorField = "PASS";
      //   _errorMessage = "Password must be alphanumeric!";
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

      final response = await Api.request(
          'post', 'auth', {'email': email, 'password': password});
      print(response);
    }
    // print(_errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Email address',
                  errorText: _errorField == 'EMAIL' ? _errorMessage : null,
                ),
                controller: _ctrlEmail,
              ),
            ),
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Password',
                  errorText: _errorField == 'PASS' ? _errorMessage : null,
                ),
                controller: _ctrlPassword,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 100,
              ),
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
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
