import 'package:blossom_health_app/presentation/welcome_page.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:blossom_health_app/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../utils/appcolor.dart';
import '../dashboard.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  double columnSpace = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTextColor,
      body: Column(
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
                            controller: password,
                          ),
                          SizedBox(height: columnSpace),
                          CommonTextField(
                            labelText: "Password",
                            controller: confirmPassword,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CommonButton(
                    text: "Log In",
                    clickCallback: _register,
                  ),
                  //  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity(vertical: 0),
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
                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _register() {
    ///ToDo: change the name
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Dashboard(
                userType: UserType.USER,
                name: "Himasha",
              )),
    );
  }
}
