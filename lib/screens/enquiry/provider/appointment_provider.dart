import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seed_sales/constants.dart';
import 'package:seed_sales/screens/categories/models/categories_model.dart';
import 'package:seed_sales/screens/enquiry/model/appointmentsmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentProvider with ChangeNotifier {
  bool loading = false;
  bool update = false;

  DateTime? selectedBookDate;
  List<EnquiryModel> enquiryList = [];
  List<EnquiryModel> tempList = [];

  String token = "";
  AppointmentProvider() {
    if (token == "") {
      getToken();
    }
  }
  stopLoading() {
    loading = false;
    notifyListeners();
  }

  // void searchBusiness(String s) {
  //   initTemp();
  //   List<AppointMentModel> searchList = [];
  //   for (int i = 0; i < tempList.length; i++) {
  //     AppointMentModel m = tempList[i];
  //     if (m.customer.contains(s)) {
  //       searchList.add(m);
  //     }
  //   }
  //   categoryList.clear();
  //   categoryList = searchList;
  //   notifyListeners();
  // }

  void clearTempList() {
    tempList.clear();
    notifyListeners();
  }

  Future<int> getEnquiry(BuildContext context) async {
    if (enquiryList.isEmpty) {
      loading = true;
      notifyListeners();
      if (token == "") {
        await getToken();
      }
      enquiryList.clear();
      debugPrint("======================================================");
      var header = {
        "Authorization": "Token $token",
        HttpHeaders.contentTypeHeader: 'application/json'
      };

      final uri = Uri.parse('https://$baseUrl/api/v1/enquiry/');
      debugPrint(token);
      final response = await http.get(uri, headers: header);
      debugPrint(response.body);
      if (response.statusCode == HttpStatus.ok) {
        Map<String, dynamic> data = json.decode(response.body);
        enquiryList = List<EnquiryModel>.from(
            data["enquiries"].map((x) => EnquiryModel.fromJson(x)));

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
                  content: Text(data.toString()),
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
    }
    return 1;
    //notifyListeners();
  }

  Future<void> getToken() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();

    token = _prefs.getString("token")!;
  }

  void addEnquiry(EnquiryModel model, BuildContext context) async {
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
    debugPrint(body.toString());
    final uri = Uri.parse('https://$baseUrl/api/v1/enquiry/');
    debugPrint(uri.toString());
    final response =
        await http.post(uri, headers: header, body: jsonEncode(body));
    debugPrint(response.body);
    if (response.statusCode == HttpStatus.created) {
      loading = false;
      notifyListeners();
      Navigator.pop(context);
      getEnquiry(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Added'),
              content: const Text('Enquiry added successfully'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    enquiryList.clear();
                    getEnquiry(context);
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
                content: Text(data.toString()),
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
  }

  CategoriesModel? selectedCategory;
  emptyDropdown() {
    selectedCategory = null;
  }

  bool setDropDownValue(CategoriesModel value) {
    selectedCategory = value;
    notifyListeners();

    return true;
  }

  // List<BusinessModel> selectedBussinessList = [];

  // void setSelectedBussiness() {
  //   if (selectedBussinessList.contains(selectedBusiness)) {
  //     selectedBussinessList.remove(selectedBusiness);
  //   }
  //   selectedBussinessList.add(selectedBusiness!);
  //   notifyListeners();
  // }

  CategoriesModel? updateModel;
  void updateNavigate(BuildContext context, CategoriesModel model) {
    update = true;
    updateModel = model;
    debugPrint(updateModel!.toJson().toString());
    notifyListeners();
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (_) => const Bussiness()));
  }

  void updateCategoryOneField(
      BuildContext context, Map<String, dynamic> model, int id) async {
    loading = true;
    notifyListeners();
    if (token == "") {
      await getToken();
    }
    var header = {
      "Authorization": "Token $token",
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    final uri = Uri.parse('https://$baseUrl/api/v1/enquiry/$id/');
    debugPrint(uri.toString());
    final response =
        await http.put(uri, headers: header, body: jsonEncode(model));

    if (response.statusCode == HttpStatus.ok) {
      loading = false;
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Updated'),
              content: const Text(' updated successfully'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    loading = false;
                    notifyListeners();
                    enquiryList.clear();
                    getEnquiry(context);
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

  void updateEnquiry(BuildContext context, EnquiryModel model) async {
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
    debugPrint(body.toString());
    final uri = Uri.parse('https://$baseUrl/api/v1/enquiry/${model.id}/');
    debugPrint(uri.toString());
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
              content: const Text(' updated successfully'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);

                    loading = false;
                    notifyListeners();
                    enquiryList.clear();
                    getEnquiry(context);
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

  void deleteEnquiry(BuildContext context, EnquiryModel model) async {
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
    debugPrint(body.toString());
    final uri = Uri.parse('https://$baseUrl/api/v1/enquiry/${model.id}/');
    debugPrint(uri.toString());
    final response = await http.delete(uri, headers: header);

    if (response.statusCode == HttpStatus.noContent) {
      loading = false;
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text('Deleted'),
              content: const Text(' Deleted successfully'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);

                    loading = false;
                    notifyListeners();
                    enquiryList.clear();
                    getEnquiry(context);
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
//time slot

  // void getTimeSlots(BuildContext context,String date) async {
  //   loading = true;
  //   notifyListeners();
  //   if (token == "") {
  //     await getToken();
  //   }
  //   // slots.clear();
  //   debugPrint("======================================================");
  //   var header = {
  //     "Authorization": "Token $token",
  //     HttpHeaders.contentTypeHeader: 'application/json'
  //   };
  //   var body={
  //     "date":date
  //   };
  //   final uri = Uri.parse('https://perfect-new.herokuapp.com/api/v1/timeslots/');
  //   debugPrint(token);
  //
  //   // final newURI = uri.replace(queryParameters: params);
  //   final response = await http.post(uri, headers: header,body: jsonEncode(body));
  //   debugPrint(response.body);
  //   if (response.statusCode == HttpStatus.ok) {
  //     loading = false;
  //     notifyListeners();
  //     Map<String, dynamic> data = json.decode(response.body);
  //     slots = List<Timeslots>.from(
  //         data["timeslots"].map((x) => Timeslots.fromJson(x)));
  //     print(slots.length);
  //     notifyListeners();
  //   } else if (response.statusCode == HttpStatus.badRequest) {
  //     loading = false;
  //     notifyListeners();
  //     Map<String, dynamic> data = json.decode(response.body);
  //     try {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return CupertinoAlertDialog(
  //               title: const Text('Failed'),
  //               content: Text(data['error']),
  //               actions: <Widget>[
  //                 CupertinoDialogAction(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('Ok'),
  //                 ),
  //               ],
  //             );
  //           });
  //     } catch (e) {
  //       loading = false;
  //       notifyListeners();
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return CupertinoAlertDialog(
  //               title: const Text('Failed'),
  //               content: const Text('some thing went wrong'),
  //               actions: <Widget>[
  //                 CupertinoDialogAction(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text('Ok'),
  //                 ),
  //               ],
  //             );
  //           });
  //     }
  //   }
  //   //notifyListeners();
  // }

  //=
}
