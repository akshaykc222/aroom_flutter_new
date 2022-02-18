import 'package:seed_sales/screens/customers/models/country_model.dart';

class EnquiryModel {
  EnquiryModel({
    this.id,
    this.createdUser,
    required this.leadSoruce,
    required this.projectType,
    required this.leadStatus,
    required this.leadType,
    required this.expenseSource,
    this.createdDate,
    required this.customer,
  });

  int? id;
  int? createdUser;
  String leadSoruce;
  String projectType;
  String leadStatus;
  String leadType;
  String expenseSource;
  DateTime? createdDate;
  CustomerModel customer;

  factory EnquiryModel.fromJson(Map<String, dynamic> json) => EnquiryModel(
    id: json["id"],
    createdUser: json["created_user"],
    leadSoruce: json["lead_soruce"],
    projectType: json["project_type"],
    leadStatus: json["lead_status"],
    leadType: json["lead_type"],
    expenseSource: json["expense_source"],
    createdDate: DateTime.parse(json["created_date"]),
    customer: CustomerModel.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_user": createdUser,
    "lead_soruce": leadSoruce,
    "project_type": projectType,
    "lead_status": leadStatus,
    "lead_type": leadType,
    "expense_source": expenseSource,

    "customer": customer.id,
  };
}


