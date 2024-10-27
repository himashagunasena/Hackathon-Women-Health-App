import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/screen/welcome_page.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:blossom_health_app/utils/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/appcolor.dart';
import '../dashboard.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  double columnSpace = 16;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightTextColor,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(
                      "assets/images/login_image.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Image.asset(
                                    "assets/images/text_logo.png",
                                    height: 18,
                                  ),
                                  SizedBox(height: columnSpace),
                                  const Text(
                                    'Log In ',
                                    style: TextStyle(
                                        color: AppColors.textColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: columnSpace),
                                  CommonTextField(
                                    labelText: "Email",
                                    controller: emailController,
                                  ),
                                  SizedBox(height: columnSpace),
                                  CommonTextField(
                                    labelText: "Password",
                                    controller: passwordController,
                                    obscureText: obscurePassword,
                                    iconButton: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          obscurePassword = !obscurePassword;
                                        });
                                      },
                                      child: Icon(
                                        obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.primaryCardColor,
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CommonButton(
                      text: "Log In",
                      clickCallback: _login,
                    ),
                  ),
                  //  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(vertical: 0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomePage()),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: 'I Don\'t Have An Account ',
                          style: TextStyle(color: AppColors.textColor),
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16)])));
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {

          UserModel userModel = UserModel(
              uid: user.uid,
              address: userData['address'],
              birthday: DateTime.parse(userData['birthday']),
              city: userData['city'],
              country: userData['country'],
              email: userData['email'],
              fullName: userData['fullName'],
            nickName: userData['nickName'],
            phoneNumber: userData['phoneNumber'],
            role: userData['role'],
            specialization: userData['specialization']
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Dashboard(
                    userModel: userModel,
                  ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      }
    } catch (e) {
      print('Login Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

// Convert role string to UserType enum
  UserType _getUserType(String? role) {
    switch (role) {
      case 'DOCTOR':
        return UserType.DOCTOR;
      default:
        return UserType.USER;
    }
  }
}
