import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/income/model/income_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class IncomeProvider with ChangeNotifier{
  List<IncomeModel> incomeList=[];
  String token="";
  bool loading=false;

  List<String> paymentMode=[
    "CASH",
    "BANK TRANSFER",
    "CHEQUE"
  ];
  String selectedPaymentMode="CASH";
  changePaymentMode(String mode){
    selectedPaymentMode=mode;
    notifyListeners();
  }
  Future<void> get() async {
    loading=true;
    notifyListeners();
    if(token==""){
      getToken();
    }
    print(token);
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.Request('GET', Uri.parse('https://$baseUrl/api/v1/incomes/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    
      Map<String,dynamic> data=jsonDecode(await response.stream.bytesToString());
      if(data.isNotEmpty){
        incomeList=List<IncomeModel>.from(data['incomes'].map((x)=>IncomeModel.fromJson(x)));
        notifyListeners();
      }
      loading=false;
      notifyListeners();
    }
    else {
      loading=false;
      notifyListeners();
    print(response.reasonPhrase);
    }

  }
  Future<void> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    token = _prefs.getString("token")!;
  }


  Future<void> add({required BuildContext context,required IncomeModel body}) async {
    loading=false;
    notifyListeners();
    if(token==""){
      getToken();
    }
    var headers = {
      'Authorization': 'Token $token'
    };
    var request = http.Request('POST', Uri.parse('https://$baseUrl/api/v1/incomes/'));
    request.body = jsonEncode(body.toJson());
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, incomeNav).then((value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added'))));
    }
    else {

    ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(response.reasonPhrase.toString())));
    }

  }

}