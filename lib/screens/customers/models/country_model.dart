

class CustomerModel {
  CustomerModel({
    this.id,
    this.createdUser,
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.pincode,
    required this.city,
    required this.country,
    required this.state,
    this.address,
    required this.leadSoruce,
    required this.projectType,
    required this.leadStatus,
    required this.leadType,
    required this.expenseSource,
    this.createdDate,
    this.createdBusiness,
  });

  int? id;
  int? createdUser;
  String name;
  int age;
  String phone;
  String email;
  String pincode;
  String city;
  String country;
  String state;
  String? address;
  String leadSoruce;
  String projectType;
  String leadStatus;
  String leadType;
  String expenseSource;
  DateTime? createdDate;
  int? createdBusiness;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json["id"],
    createdUser: json["created_user"],
    name: json["name"],
    age: json["age"],
    phone: json["phone"],
    email: json["email"],
    pincode: json["pincode"],
    address: json['address'],
    city: json["city"],
    country: json["country"],
    state: json["state"],
    leadSoruce: json["lead_soruce"],
    projectType: json["project_type"],
    leadStatus: json["lead_status"],
    leadType: json["lead_type"],
    expenseSource: json["expense_source"],
    createdDate: DateTime.parse(json["created_date"]),
    createdBusiness: json["created_business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_user": createdUser,
    "name": name,
    "age": age,
    "phone": phone,
    "address":address,
    "email": email,
    "pincode": pincode,
    "city": city,
    "country": country,
    "state": state,
    "lead_soruce": leadSoruce,
    "project_type": projectType,
    "lead_status": leadStatus,
    "lead_type": leadType,
    "expense_source": expenseSource,

    "created_business": createdBusiness,
  };
}
