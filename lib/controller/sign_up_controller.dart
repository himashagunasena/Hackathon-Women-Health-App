import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class SignUpController {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool signUpSuccess = false;

  bool success() {
    return signUpSuccess;
  }

  Future<void> signUp(
    String? uid,
    String? fullName,
    String? nickName,
    String email,
    String? phoneNumber,
    String? address,
    String? city,
    String? country,
    String? birthday,
    String? role,
    String? specialization,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential? userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          fullName: fullName?.trim(),
          nickName: nickName?.trim(),
          email: email.trim(),
          phoneNumber: phoneNumber?.trim() ?? "",
          address: address?.trim(),
          city: city?.trim(),
          country: country?.trim(),
          birthday: birthday != null && birthday.trim().isNotEmpty
              ? DateTime.parse(birthday.trim())
              : null,
          role: role,
          specialization: specialization ?? "",
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toMap());
        signUpSuccess = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully sign Up")),
        );
      } else {}
    } catch (e) {
      signUpSuccess = false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during sign up ${e.toString()}')),
      );
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print('Error during login: ${e.message}');
      return null;
    }
  }
}
