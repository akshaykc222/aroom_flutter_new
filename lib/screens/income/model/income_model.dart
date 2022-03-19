import 'package:seed_sales/screens/customers/models/country_model.dart';
import 'package:seed_sales/screens/products/model/project_model.dart';

class IncomeModel {
  IncomeModel({
    this.id,
    this.createdUser,
    this.createdDate,
    required this.paymentHistory,
    required this.client,
    required this.project,
  });

  int? id;
  int? createdUser;
  List<PaymentHistory> paymentHistory;
  DateTime? createdDate;
  CustomerModel client;
  ProjectModel project;

  factory IncomeModel.fromJson(Map<String, dynamic> json) => IncomeModel(
        id: json["id"],
        createdUser: json["created_user"],
        createdDate: DateTime.parse(json["created_date"]),
        client: CustomerModel.fromJson(json["client"]),
        project: ProjectModel.fromJson(json["project"]),
        paymentHistory: List<PaymentHistory>.from(
            json["payment_history"].map((x) => PaymentHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client": client.id,
        "project": project.id,
        "payment_history":
            List<dynamic>.from(paymentHistory.map((x) => x.toJson())),
      };
}

class PaymentHistory {
  PaymentHistory({
    this.id,
    this.createdDate,
    required this.amount,
    this.narration,
    required this.paymentMode,
  });

  int? id;
  DateTime? createdDate;
  double amount;
  String? narration;
  String paymentMode;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        id: json["id"],
        createdDate: DateTime.parse(json["created_date"]),
        amount: json["amount"].toDouble(),
        narration: json["narration"],
        paymentMode: json["payment_mode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "created_date": createdDate.toIso8601String(),
        "amount": amount,
        "narration": narration,
        "payment_mode": paymentMode,
      };
}
