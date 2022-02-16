import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seed_sales/screens/bussiness/models/bussinessmode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../login/model/login_model.dart';


class AssignedBussinessProvider with ChangeNotifier{
  List<BusinessModel> businessList=[];
  bool loading = false;
  String token="";
  AssignedBussinessProvider(){
    getToken();
  }
  getBussienss() async {
    loading=true;
    notifyListeners();
    SharedPreferences _pref=await SharedPreferences.getInstance();
    print(_pref.getString('user'));
    User user= User.fromJson(jsonDecode(_pref.getString('user')!));
    debugPrint(user.toString());
     businessList = user.permissions.map((e) => e.business).toList();
    loading=false;
     notifyListeners();
  }
   setDefaultBusiness(int id) async {
    loading=true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    businessList.clear();
    debugPrint("======================================================");
    var header = {
      "Authorization": "Token $token",
      HttpHeaders.contentTypeHeader: 'application/json'
    };
   final body={
     'defualt_business':id
    };
    final uri = Uri.parse('https://$baseUrl/api/v1/userDefaultBusiness/');
    debugPrint(token);
    final response = await http.post(uri, headers: header,body:jsonEncode(body));
    debugPrint(response.body);
    if (response.statusCode==HttpStatus.ok) {

      
      loading = false;
      notifyListeners();
    }
  }
  Future<void> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    token = _prefs.getString("token")!;
  }
}