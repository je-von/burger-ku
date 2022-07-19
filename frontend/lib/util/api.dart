import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String _backendUrl = 'http://10.0.2.2:3000/';

  static _getHeader() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('auth_token');
    return {
      'auth_token': token ?? '',
    };
  }

  static request(String httpMethod, String uri, Object body) async {
    // final request = http.Request(httpMethod, Uri.parse(_backendUrl + uri));
    // request.bodyFields = body;
    // request.headers.addAll(_getHeader());
    // final response = await request.send();
    // final responsed = await http.Response.fromStream(response);
    // return json.decode(responsed.body);

    final response = await http.post(Uri.parse(_backendUrl + uri),
        body: body, headers: await _getHeader());
    return jsonDecode(response.body);
  }
}
