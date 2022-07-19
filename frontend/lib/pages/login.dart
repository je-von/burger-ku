import 'package:flutter/material.dart';

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

  var _ctrlEmail = TextEditingController();
  var _ctrlPassword = TextEditingController();

  dynamic auth(String email, String password) {}

  void _validateLogin(BuildContext context) {
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
    } else if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(password)) {
      _errorField = "PASS";
      _errorMessage = "Password must be alphanumeric!";
    } else {
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
    }
    // print(_errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: ListView(
          children: [
            Container(
              height: 200,
              width: 200,
              child: Center(
                child: Image.asset('assets/logo.png'),
              ),
            ),
            Text(
              'Email',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email address',
                  errorText: _errorField == 'EMAIL' ? _errorMessage : null,
                ),
                controller: _ctrlEmail,
              ),
            ),
            Text(
              'Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  errorText: _errorField == 'PASS' ? _errorMessage : null,
                ),
                controller: _ctrlPassword,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 100,
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _validateLogin(context);
                  });
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.orange;
                    }
                    return Colors.orange.shade200;
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
