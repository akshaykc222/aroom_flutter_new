class CustomerModel {
  CustomerModel({
    this.id,
    this.createdUser,
    required this.name,
    this.age,
    required this.phone,
    required this.email,
    required this.address,
    required this.pincode,
    required this.city,
    required this.country,
    required this.state,
    required this.status,
    this.createdDate,
    this.createdBusiness,
  });

  int? id;
  int? createdUser;
  String name;
  int? age;
  String phone;
  String email;
  String address;
  String pincode;
  String city;
  String country;
  String state;
  bool status;
  DateTime? createdDate;
  int? createdBusiness;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json["id"],
    createdUser: json["created_user"],
    name: json["name"],
    age: json["age"],
    phone: json["phone"],
    email: json["email"],
    address: json["address"],
    pincode: json["pincode"],
    city: json["city"],
    country: json["country"],
    state: json["state"],
    status: json["status"],
    createdDate: DateTime.parse(json["created_date"]),
    createdBusiness: json["created_business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_user": createdUser,
    "name": name,
    "age": age,
    "phone": phone,
    "email": email,
    "address": address,
    "pincode": pincode,
    "city": city,
    "country": country,
    "state": state,
    "status": status,
    "created_business": createdBusiness,
  };
}
