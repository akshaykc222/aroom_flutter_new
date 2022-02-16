import 'package:seed_sales/screens/Desingation/models/designation_model.dart';
import 'package:seed_sales/screens/bussiness/models/bussinessmode.dart';
import 'package:seed_sales/screens/roles/models/user_role_model.dart';

class LoginModel {
  LoginModel({
    required this.token,
    required this.user,
  });

  String token;
  User user;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );


}

class User {
  User({
    required this.email,
    required this.designation,
    required this.permissions,
  });

  String email;
  DesingationModel designation;
  List<UserRolesFromLogin> permissions;

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json["email"],
    designation: DesingationModel.fromJson(json["designation"]),
    permissions: List<UserRolesFromLogin>.from(json["permissions"].map((x) => UserRolesFromLogin.fromJson(x))),
  );


}
class UserRolesFromLogin{
  int? id;
  UserRoleModel role;
  BusinessModel business;
  UserRolesFromLogin({ this.id, required this.role,required this.business});

  factory UserRolesFromLogin.fromJson(Map<String, dynamic> json) => UserRolesFromLogin(
    id: json["id"],
    role: UserRoleModel.fromJson(json["role"]), 
    business: BusinessModel.fromJson(json['business']),

  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role.id,
    "business": business.id,
  };

}



