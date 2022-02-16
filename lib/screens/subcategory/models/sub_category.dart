import 'package:seed_sales/screens/categories/models/categories_model.dart';

class SubCategoryModel {
  SubCategoryModel({
    this.id,
    this.createdUser,
   required this.name,
    this.createdDate,
   required this.category,
  });

  int? id;
  int? createdUser;
  String name;
  String? createdDate;
  CategoriesModel category;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    id: json["id"],
    createdUser: json["created_user"],
    name: json["name"],
    createdDate: json["created_date"],
    category: CategoriesModel.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_user": createdUser,
    "name": name,
    "created_date": createdDate,
    "category": category.id,
  };
}
