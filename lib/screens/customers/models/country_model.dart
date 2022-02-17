

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
    this.status,
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
  bool? status;
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
    status:json['status'],
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
    "created_business": createdBusiness,
  };
}
