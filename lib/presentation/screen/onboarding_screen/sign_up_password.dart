import 'package:blossom_health_app/controller/sign_up_controller.dart';
import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/screen/onboarding_screen/login.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:flutter/material.dart';

import '../../../utils/appcolor.dart';
import '../../widget/alert.dart';

class SetPasswordScreen extends StatefulWidget {
  final UserModel userModel;

  const SetPasswordScreen({super.key, required this.userModel});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  double columnSpace = 16;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? message = "";
  bool visibleWarning = false;

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
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24,
                ),
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
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "Confirm Password",
                        controller: confirmPassword,
                        obscureText: obscureConfirmPassword,
                        iconButton: GestureDetector(
                          onTap: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          child: Icon(
                            obscureConfirmPassword
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
              const SizedBox(height: 12),
              message != "" && visibleWarning == true
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Alerts().warningCardAlert(message, () {
                        setState(() {
                          visibleWarning = false;
                        });
                      }),
                    )
                  : const SizedBox.shrink(),
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

  Future<void> _register() async {
    setState(() {
      if (password.text.isEmpty) {
        message = "Please enter password";
        visibleWarning = true;
        return;
      } else if (confirmPassword.text.isEmpty) {
        message = "Please enter confirm password";
        visibleWarning = true;
        return;
      } else if (confirmPassword.text != password.text) {
        message = "The passwords are mismatch. Please try again";
        visibleWarning = true;
        return;
      }

      try {
        SignUpController().signUp(
            widget.userModel.uid,
            widget.userModel.fullName,
            widget.userModel.nickName,
            widget.userModel.email ?? "",
            widget.userModel.phoneNumber,
            widget.userModel.address,
            widget.userModel.city,
            widget.userModel.country,
            widget.userModel.birthday.toString(),
            widget.userModel.role,
            widget.userModel.specialization,
            password.text,
            context);

        Future.delayed(const Duration(seconds: 2))
            .then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInScreen()),
                  (Route<dynamic> route) => false,
                ));
      } catch (e) {
        message = "Sign up failed: ${e.toString()}";
        visibleWarning = true;
      }
    });
  }
}
