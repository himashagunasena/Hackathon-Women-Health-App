import 'package:blossom_health_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<UserModel>> fetchFilteredUsers(String specialization, String role, String city, String country) async {
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  try {
    QuerySnapshot querySnapshot = await usersCollection
        .where('specialization', isEqualTo: specialization)
        .where('role', isEqualTo: role)
        .where('city', isEqualTo: city)
         .where('country', isEqualTo: country)
        .get();

    final List<UserModel> filteredUsers = querySnapshot.docs.map((doc) {

      final data = doc.data() as Map<String, dynamic>;

      return UserModel.fromMap(data..['id'] = doc.id);
    }).toList();

    return filteredUsers;
  } catch (e) {
    print("Error fetching filtered users: $e");
    return [];
  }
}

