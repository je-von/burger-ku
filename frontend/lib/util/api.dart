import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const String backendUrl = 'http://10.0.2.2:3000/';

  static _getHeader() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('auth_token');
    // print('token: $token');
    return {
      'auth_token': token ?? '',
    };
  }

  static request(String httpMethod, String uri,
      {Map<String, String> body = const {}}) async {
    final request = http.Request(httpMethod, Uri.parse(backendUrl + uri));
    request.bodyFields = body;
    request.headers.addAll(await _getHeader());
    final response = await request.send();
    final responsed = await http.Response.fromStream(response);
    return responsed;

    // final response = await http.post(Uri.parse(backendUrl + uri),
    //     body: body, headers: await _getHeader());
    // return jsonDecode(response.body);
  }

  static getCurrentUser() async {
    final response = await request('get', 'users/current');

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      return null;
    }
  }
}
