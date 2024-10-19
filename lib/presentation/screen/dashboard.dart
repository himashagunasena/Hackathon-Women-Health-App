import 'package:blossom_health_app/presentation/widget/advice_card.dart';
import 'package:blossom_health_app/presentation/widget/rectangle_card.dart';
import 'package:blossom_health_app/utils/enum.dart';
import 'package:flutter/material.dart';

import '../../../utils/appcolor.dart';
import '../widget/square_card.dart';

class Dashboard extends StatefulWidget {
  final UserType userType;
  final String name;

  const Dashboard({super.key, required this.userType, required this.name});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  double columnSpace = 16;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTextColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      widget.userType == UserType.USER
                          ? "assets/images/user_profile.png"
                          : "assets/images/doctor_profile.png",
                      height: 48,
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        text: 'Hi, ',
                        style: const TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                        children: [
                          TextSpan(
                            text: widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "Have A Nice Day",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 12),
              const AdviceCard(
                text: "Health Advice",
                description:
                    "Track your daily symptoms and get a detailed weekly summary here.",
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  SquareCard(
                    text: 'Daily Health Tracker',
                    clickCallback: () {},
                    color: AppColors.primaryCardColor,
                    image: "assets/images/daily_health.png",
                  ),
                  SquareCard(
                    text: 'Health Calendar',
                    clickCallback: () {},
                    color: AppColors.secondaryCardColor,
                    image: "assets/images/calendar.png",
                  ),
                  SquareCard(
                    text: 'Image Based Disease Checker',
                    clickCallback: () {},
                    color: AppColors.secondaryCardColor,
                    image: "assets/images/checking.png",
                  ),
                  SquareCard(
                    text: widget.userType == UserType.USER
                        ? 'Find a Doctor'
                        : 'Manage Appointments',
                    clickCallback: () {},
                    color: AppColors.primaryCardColor,
                    image: "assets/images/appoinment.png",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RectangleCard(
                text: "Join Our Community Blog",
                clickCallback: () {},
                color: AppColors.primaryColor,
                image: "assets/images/blog.png",
                description: widget.userType == UserType.USER
                    ? "Let's talk about your health openly. Feel free to ask any questions, without hesitation."
                    : "Support women’s health and share your knowledge with the community",
              ),
            ],
          ),
        ),
      ),
    );
  }

// void _register() {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const Dashboard()),
//   );
// }
}
