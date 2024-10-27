import 'package:blossom_health_app/presentation/screen/onboarding_screen/login.dart';
import 'package:blossom_health_app/presentation/screen/onboarding_screen/sign_up_personal_details.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/utils/appcolor.dart';
import 'package:blossom_health_app/utils/enum.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_image.png'),
              // Your image asset path
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Image.asset(
                      "assets/images/logo.png",
                      height: 20,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Text(
                      'Blossom Health App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CommonButton(
                        text: "Doctor, Help To Our Girls",
                        clickCallback: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     const PersonalDetailsScreen(userType: UserType.DOCTOR,)),
                          );
                        }),
                    const SizedBox(height: 12),
                    CommonButton(
                      text: "Girls Join With Us",
                      clickCallback: () { Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const PersonalDetailsScreen(userType: UserType.USER,)),
                      );},
                      buttonColor: AppColors.secondaryColor,
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const LogInScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already Have An Account? ',
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
