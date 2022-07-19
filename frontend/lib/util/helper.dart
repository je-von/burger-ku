import 'package:flutter/material.dart';

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
