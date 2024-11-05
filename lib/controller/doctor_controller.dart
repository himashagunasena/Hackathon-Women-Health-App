import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doctor_model.dart';

Future<List<Doctor>> fetchDoctors(
    String? name, String? city, String? country, String? specialization) async {
  Query<Map<String, dynamic>> query = FirebaseFirestore.instance
      .collection('users') // Replace 'users' with your collection
      .where('role', isEqualTo: 'Doctor');

  if (name != null && name.isNotEmpty) {
    query = query
        .where('name', isGreaterThanOrEqualTo: name)
        .where('name', isLessThanOrEqualTo: name + '\uf8ff');
  }
  if (city != null && city.isNotEmpty) {
    query = query.where('city', isEqualTo: city);
  }
  if (country != null && country.isNotEmpty) {
    query = query.where('country', isEqualTo: country);
  }
  if (specialization != null && specialization.isNotEmpty) {
    query = query.where('specialization', isEqualTo: specialization);
  }

  final snapshot = await query.get();
  return snapshot.docs.map((doc) => Doctor.fromJson(doc.data())).toList();
}