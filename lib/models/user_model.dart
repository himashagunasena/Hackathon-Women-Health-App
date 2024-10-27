class UserModel {
  String? uid;
  String? fullName;
  String? nickName;
  String? email;
  String? phoneNumber;
  String? address;
  String? city;
  String? country;
  DateTime? birthday;
  String? role;
  String? specialization;

  UserModel({
    this.uid,
    this.fullName,
    this.nickName,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.country,
    this.birthday,
    this.role,
    this.specialization
  });

  UserModel.fromMap(Map<String, dynamic> data) {
    uid = data['uid'];
    fullName = data['fullName'];
    nickName = data['nickName'];
    email = data['email'];
    phoneNumber = data['phoneNumber'];
    address = data['address'];
    city = data['city'];
    country = data['country'];
    birthday = (data['birthday'] != null) ? DateTime.parse(data['birthday']) : null;
    role = data['role'];
    specialization = data['specialization'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'nickName': nickName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'country': country,
      'birthday': birthday?.toIso8601String(),
      'role': role,
      'specialization':specialization,
    };
  }}