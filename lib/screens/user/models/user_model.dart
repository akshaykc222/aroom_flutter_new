import 'package:seed_sales/screens/Desingation/models/designation_model.dart';
import 'package:seed_sales/screens/roles/models/role_model.dart';
import 'package:seed_sales/screens/roles/models/user_role_model.dart';
import 'package:seed_sales/screens/user/models/role_models.dart';

import '../../login/model/login_model.dart';

class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  DesingationModel designation;
  List<UserRolesFromLogin>? roleList;
  UserModel(
      {this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.designation,
      this.roleList
     });

  factory UserModel.fromJson(Map<String, dynamic> json) {

  
    return UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        designation: DesingationModel.fromJson(json["designation"]),
        roleList:List<UserRolesFromLogin>.from(json["permissions"].map((x) => UserRolesFromLogin.fromJson(x)))
       );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['designation'] = designation.id;
    data['password1'] = password;
    data['password2'] = password;
    data['permissions']= List<dynamic>.from(roleList!.map((x) => x.toJson()));

    return data;
  }
}
