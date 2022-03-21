import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/income/model/income_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeProvider with ChangeNotifier {
  List<IncomeModel> incomeList = [];
  String token = "";
  bool loading = false;

  List<String> paymentMode = ["CASH", "BANK TRANSFER", "CHEQUE"];
  String selectedPaymentMode = "CASH";
  changePaymentMode(String mode) {
    selectedPaymentMode = mode;
    notifyListeners();
  }

  Future<void> get() async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    print(token);
    var headers = {'Authorization': 'Token $token'};
    var request =
        http.Request('GET', Uri.parse('https://$baseUrl/api/v1/incomes/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(await response.stream.bytesToString());
      if (data.isNotEmpty) {
        incomeList = List<IncomeModel>.from(
            data['incomes'].map((x) => IncomeModel.fromJson(x)));
        notifyListeners();
      }
      loading = false;
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
      print(response.reasonPhrase);
    }
  }

  Future<void> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    token = _prefs.getString("token")!;
  }

  Future<void> add(
      {required BuildContext context, required IncomeModel body}) async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://$baseUrl/api/v1/incomes/'));
    request.body = jsonEncode(body.toJson());
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      loading = false;
      incomeList.clear();
      get();
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added')));
      Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, incomeNav).then((value) =>
      //     ScaffoldMessenger.of(context)
      //         .showSnackBar(const SnackBar(content: Text('Added'))));
    } else {
      loading = false;
      notifyListeners();
      debugPrint(await response.stream.bytesToString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.reasonPhrase.toString())));
    }
  }

  Future<void> put(
      {required BuildContext context, required IncomeModel body}) async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var request = http.Request(
        'PUT', Uri.parse('https://$baseUrl/api/v1/incomes/${body.id}/'));
    request.body = jsonEncode(body.toJson());
    print(body.toJson());
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading = false;
      notifyListeners();
      incomeList.clear();
      get();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Updated')));
      Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, incomeNav).then((value) =>
      //     ScaffoldMessenger.of(context)
      //         .showSnackBar(const SnackBar(content: Text('Added'))));
    } else {
      loading = false;
      notifyListeners();
      Map<String, dynamic> data =
          jsonDecode(await response.stream.bytesToString());
      if (data.containsKey('project')) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project Already exists')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.reasonPhrase.toString())));
      }
    }
  }
}
