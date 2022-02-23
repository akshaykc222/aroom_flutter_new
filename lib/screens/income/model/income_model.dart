import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/products/model/project_model.dart';

class IncomeModel {
  IncomeModel({
    this.id,
    this.createdUser,
    required this.amount,
    required this.narration,
    this.createdDate,
    required this.client,
    required this.project,
  });

  int? id;
  int? createdUser;
  double amount;
  String narration;
  DateTime? createdDate;
  CustomerModel client;
  ProjectModel project;

  factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
    id: json["id"],
    createdUser: json["created_user"],
    amount: json["amount"].toDouble(),
    narration: json["narration"],
    createdDate: DateTime.parse(json["created_date"]),
    client: CustomerModel.fromJson(json["client"]),
    project: ProjectModel.fromJson(json["project"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_user": createdUser,
    "amount": amount,
    "narration": narration,

    "client": client,
    "project": project,
  };
}
