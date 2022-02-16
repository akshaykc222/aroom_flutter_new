import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seed_sales/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  bool loading = false;
  Future<bool> loign(
      String username, String password, BuildContext context) async {
    loading = true;
    notifyListeners();
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final body = json.encode({'email': username, 'password': password});
    print({'email': username, 'password': password});
    try {
      final uri = Uri.https(baseUrl, '/api/v1/login/');
      final headers = {
        HttpHeaders.contentTypeHeader: 'application/json',

      };
      final response = await http.post(uri, headers: headers, body: body);
      print(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey("token")) {
        _prefs.setString("email", username);
        log(data['token']);
        _prefs.setString('token', data['token']);
        _prefs.setString('user', jsonEncode(data['user']));
        Navigator.pushReplacementNamed(context, adminPanel);
        loading = false;
        return true;
      } else {
        loading = false;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("invalid username or password")));
        return false;
      }
    } catch (e) {
      print(e);
      loading = false;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return false;
    }
  }
}
