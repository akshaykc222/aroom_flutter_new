import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/subcategory/models/sub_category.dart';

class ProjectModel {
  ProjectModel({
    this.id,
    this.createdUser,
    required this.name,
    required this.type,
    required this.startDate,
    required this.deadLine,
    required this.estProjectValue,
    required this.remarks,
    this.createdDate,
    required this.status,
    required this.category,
    required this.client,
  });

  int? id;
  int? createdUser;
  String name;
  String type;
  DateTime startDate;
  DateTime deadLine;
  double estProjectValue;
  String remarks;
  String status="PENDING";
  DateTime? createdDate;
  SubCategoryModel category;
  CustomerModel client;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json["id"],
    createdUser: json["created_user"],
    name: json["name"],
    type: json["type"],
    status: json['status']??"PENDING",
    startDate: DateTime.parse(json["start_date"]),
    deadLine: DateTime.parse(json["dead_line"]),
    estProjectValue: json["est_project_value"].toDouble(),
    remarks: json["remarks"],
    createdDate: DateTime.parse(json["created_date"]),
    category: SubCategoryModel.fromJson(json["category"]),
    client: CustomerModel.fromJson(json['client']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_user": createdUser,
    "name": name,
    "type": type,
    "status":status,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "dead_line": "${deadLine.year.toString().padLeft(4, '0')}-${deadLine.month.toString().padLeft(2, '0')}-${deadLine.day.toString().padLeft(2, '0')}",
    "est_project_value": estProjectValue,
    "remarks": remarks,
    
    "category": category.id,
    "client": client.id,
  };
}
