import 'package:seed_sales/screens/bussiness/models/bussinessmode.dart';

import '../../roles/models/user_role_model.dart';

class RoleModel {
  RoleModel(
      {required this.role,
      required this.business,
      this.user,
      required this.name});

  UserRoleModel role;
  BusinessModel business;
  int? user;
  String? name;

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
      role: UserRoleModel.fromJson(json['role']),
      business: BusinessModel.fromJson(json['business']),
      user: json["user"],
      name: null
  );

  Map<String, dynamic> toJson() => {
        "role": role,
        "business": business.id,
        "user": user,
      };
}
