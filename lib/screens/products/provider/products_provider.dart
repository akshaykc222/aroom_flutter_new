import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seed_sales/screens/income/model/income_model.dart';
import 'package:seed_sales/screens/products/model/project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';

class ProjectProvider with ChangeNotifier {
  bool loading = false;
  bool update = false;
  List<ProjectModel> productList = [];
  List<ProjectModel> tempList = [];
  List<ProjectModel> selectedListForAppoint = [];
  List<ProjectModel> selectedListForAppointGet = [];
  String token = "";
  double totalPrice = 0.0;
  ProjectModel? selectedModel;
  changeSelectedModel(ProjectModel? model) {
    selectedModel = model;
    notifyListeners();
  }

  ProjectProvider() {
    if (token == "") {
      getToken();
    }
  }
  emptyAppointmentList() {
    totalPrice = 0.0;
    selectedListForAppoint.clear();
    notifyListeners();
  }

  void initTemp() {
    if (tempList.isEmpty) {
      tempList = productList;
      debugPrint(productList.length.toString());
      notifyListeners();
    }
  }

  void retainList() {
    productList.clear();
    productList = tempList;
    debugPrint(productList.length.toString());
    notifyListeners();
  }

  void search(String s) {
    initTemp();
    List<ProjectModel> searchList = [];
    for (int i = 0; i < tempList.length; i++) {
      ProjectModel m = tempList[i];
      if (m.name.contains(s)) {
        searchList.add(m);
      }
    }
    productList.clear();
    productList = searchList;
    notifyListeners();
  }

  void gettemsWithList(
      {required BuildContext context, required List<int> id}) async {
    if (selectedListForAppointGet.isEmpty) {
      print('getting');
      loading = true;
      notifyListeners();
      if (token == "") {
        await getToken();
      }
      selectedListForAppointGet.clear();
      debugPrint(
          "=============================sdfsdfsdfsdfsdfsdfsdfsdfsdfsdfds=========================");
      var header = {
        "Authorization": "Token $token",
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      for (var element in id) {
        final uri;

        uri = Uri.parse('https://$baseUrl/api/v1/projects/$element/$element/');

        debugPrint(token);
        final response = await http.get(uri, headers: header);
        debugPrint(response.body);
        if (response.statusCode == HttpStatus.ok) {
          Map<String, dynamic> data = json.decode(response.body);
          selectedListForAppointGet = List<ProjectModel>.from(
              data["projects"].map((x) => ProjectModel.fromJson(x)));
          notifyListeners();
        }
      }
      loading = false;
    }

    // notifyListeners();
    //notifyListeners();
  }

  void get({required BuildContext context, int? id}) async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    productList.clear();
    debugPrint("======================================================");
    var header = {
      "Authorization": "Token $token",
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    final uri;

    id != null
        ? uri = Uri.parse('https://$baseUrl/api/v1/projects/$id/')
        : uri = Uri.parse('https://$baseUrl/api/v1/projects/');
    debugPrint(token);
    final response = await http.get(uri, headers: header);
    debugPrint(response.body);
    if (response.statusCode == HttpStatus.ok) {
      Map<String, dynamic> data = json.decode(response.body);
      productList = List<ProjectModel>.from(
          data["projects"].map((x) => ProjectModel.fromJson(x)));
      loading = false;

      notifyListeners();
    } else if (response.statusCode == HttpStatus.badRequest) {
      loading = false;
      notifyListeners();
      Map<String, dynamic> data = json.decode(response.body);
      try {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Failed'),
                content: Text(data['error']),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      } catch (e) {
        loading = false;
        notifyListeners();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Failed'),
                content: const Text(something),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }
    }
    //notifyListeners();
  }

  Future<void> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    token = _prefs.getString("token")!;
  }

  void add(ProjectModel model, BuildContext context) async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    var header = {
      "Authorization": "Token $token",
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var body = model.toJson();
    print(body);
    final uri = Uri.parse('https://$baseUrl/api/v1/projects/');
    print(uri);
    final response =
        await http.post(uri, headers: header, body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == HttpStatus.created) {
      get(context: context);
      loading = false;
      notifyListeners();
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Added'),
              content: const Text('Project added successfully'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    get(context: context);
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    } else if (response.statusCode == HttpStatus.badRequest) {
      loading = false;
      notifyListeners();
      Map<String, dynamic> data = json.decode(response.body);
      try {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Failed'),
                content: Text(jsonEncode(data)),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      } catch (e) {
        loading = false;
        notifyListeners();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Faild'),
                content: const Text(something),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }
    }
  }

  void delete(ProjectModel model, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Delete'),
            content: const Text('This will delete this Project'),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () async {
                  //action for delete
                  var headers = {
                    'Authorization': 'Token $token',
                    'Content-Type': 'application/json'
                  };
                  var request = http.Request(
                      'DELETE',
                      Uri.parse(
                          'https://$baseUrl/api/v1/projects/${model.id}/'));
                  print(Uri.parse(
                      'https://$baseUrl/api/v1/projects/${model.id}'));
                  request.headers.addAll(headers);

                  http.StreamedResponse response = await request.send();

                  if (response.statusCode == 200) {
                    print(await response.stream.bytesToString());
                  } else {
                    print(response.reasonPhrase);
                  }

                  productList.remove(model);
                  notifyListeners();
                  Navigator.pop(context);
                },
                child: const Text('delete'),
              ),
            ],
          );
        });
  }

  // CategoriesModel? selectedCategory;
  //
  // void setDropDownValue(CategoriesModel value) {
  //   selectedCategory = value;
  //   notifyListeners();
  // }

  // List<BusinessModel> selectedBussinessList = [];

  // void setSelectedBussiness() {
  //   if (selectedBussinessList.contains(selectedBusiness)) {
  //     selectedBussinessList.remove(selectedBusiness);
  //   }
  //   selectedBussinessList.add(selectedBusiness!);
  //   notifyListeners();
  // }

  ProjectModel? updateModel;
  void updateNavigate(BuildContext context, ProjectModel model) {
    update = true;
    updateModel = model;
    debugPrint(updateModel!.toJson().toString());
    notifyListeners();
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => const Bussiness()));
  }

  void updateFun(BuildContext context, ProjectModel model) async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    var header = {
      "Authorization": "Token $token",
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    var body = model.toJson();
    print(body);
    final uri = Uri.parse('https://$baseUrl/api/v1/projects/${model.id}/');
    print(uri);
    final response =
        await http.put(uri, headers: header, body: jsonEncode(body));

    if (response.statusCode == HttpStatus.ok) {
      loading = false;
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Updated'),
              content: const Text('Project updated successfully'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    loading = false;
                    notifyListeners();
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          });
    } else if (response.statusCode == HttpStatus.badRequest) {
      loading = false;
      notifyListeners();
      Map<String, dynamic> data = json.decode(response.body);
      try {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Failed'),
                content: Text(data['error']),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacementNamed(context, business);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      } catch (e) {
        loading = false;
        notifyListeners();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Failed'),
                content: const Text(something),
                actions: <Widget>[
                  CupertinoDialogAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      }
    }
  }

  List<String> statusList = ['COMPLETED', 'PENDING', 'ON GOING', 'NOT STARTED'];
  String selectedStatus = "PENDING";
  changeStatus(String sts) {
    selectedStatus = sts;
    notifyListeners();
  }

  double getTotal(IncomeModel model) {
    double total = 0.0;
    for (var element in model.paymentHistory) {
      total = element.amount + total;
    }

    return total;
  }
}
