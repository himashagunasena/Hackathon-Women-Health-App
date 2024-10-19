import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:flutter/material.dart';

import '../../../utils/appcolor.dart';



class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  double columnSpace = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTextColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child:  const Icon(Icons.arrow_back_ios_new_rounded,size: 24,),
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi Girl,',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          text: 'Sign Up To ',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: 'Blossom',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/indicator_2.png",
                            height: 10,
                          ),
                          const Text(
                            "Set Password",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CommonTextField(
                        labelText: "Password",
                        controller: password,
                      ),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "Confirm Password",
                        controller: confirmPassword,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CommonButton(
                text: "Register",
                clickCallback: _register,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetPasswordScreen()),
    );
  }
}
