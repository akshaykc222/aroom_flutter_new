import 'package:seed_sales/screens/bussiness/models/bussinessmode.dart';
import 'package:seed_sales/screens/roles/models/page_model.dart';

class UserRoleModel {
  UserRoleModel({
    this.id,
    required this.roleName,
    required this.rolePermissions,
    this.createdDate,

    this.createdUser,
  });

  int? id;
  String roleName;
  List<RolePermission> rolePermissions;

  DateTime? createdDate;
  int? createdUser;

  factory UserRoleModel.fromJson(Map<String, dynamic> json) => UserRoleModel(
    id: json["id"],
    roleName: json["role_name"]==null?"":json['role_name'],
    rolePermissions: List<RolePermission>.from(json["role_permissions"].map((x) => RolePermission.fromJson(x))),
    createdDate: DateTime.parse(json["created_date"]),
    createdUser: json["created_user"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_name": roleName,
    "role_permissions": List<dynamic>.from(rolePermissions.map((x) => x.toJson())),

  };
}

class RolePermission {
  RolePermission({
    this.id,
    required this.pageName,
    required this.read,
    required this.create,
    required this.delete,
    required this.update,
  });

  int? id;
  PageModel pageName;
  bool read;
  bool create;
  bool delete;
  bool update;

  factory RolePermission.fromJson(Map<String, dynamic> json) => RolePermission(
    id: json["id"],
    pageName: PageModel.fromJson(json["page_name"]),
    read: json["read"],
    create: json["create"],
    delete: json["delete"],
    update: json["update"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "page_name": pageName.id,
    "read": read,
    "create": create,
    "delete": delete,
    "update": update,
  };
}


