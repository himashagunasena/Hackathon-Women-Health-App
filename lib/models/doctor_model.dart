class Doctor {
  String? name;
  String? city;
  String? country;
  String? specialization;
  String? address;
  String? phoneNumber;

  Doctor({
    this.name,
    this.city,
    this.country,
    this.specialization,
    this.address,
    this.phoneNumber,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['fullName'],
      city: json['city'],
      country: json['country'],
      specialization: json['specialization'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
}