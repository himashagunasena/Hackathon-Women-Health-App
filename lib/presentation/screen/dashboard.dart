import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/screen/daily_health_tracker/health_calendar.dart';
import 'package:blossom_health_app/presentation/screen/onboarding_screen/sign_up_personal_details.dart';
import 'package:blossom_health_app/presentation/screen/self_diseases_checker/image_base_health_tracker.dart';
import 'package:blossom_health_app/presentation/screen/self_diseases_checker/text_based_health_tracker.dart';
import 'package:blossom_health_app/presentation/screen/weekly_summary.dart';
import 'package:blossom_health_app/presentation/widget/advice_card.dart';
import 'package:blossom_health_app/presentation/widget/rectangle_card.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../utils/appcolor.dart';
import '../widget/square_card.dart';
import 'blog/display_article.dart';
import 'daily_health_tracker/daily_health_tracker.dart';
import 'doctors.dart';

class Dashboard extends StatefulWidget {
  final UserModel userModel;

  const Dashboard({super.key, required this.userModel});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPassword = TextEditingController();

  double columnSpace = 16;
  GenerativeModel? model;

  @override
  void initState() {
    super.initState();
  }

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
                      widget.userModel.role == "User"
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
                            text: widget.userModel.nickName,
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
              WeeklyReport(userId: widget.userModel.uid ?? ""),
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
                    clickCallback: () => _dailyHealthTracker(),
                    color: AppColors.primaryCardColor,
                    image: "assets/images/daily_health.png",
                  ),
                  SquareCard(
                    text: 'Health Calendar',
                    clickCallback: () => _healthCalendar(),
                    color: AppColors.secondaryCardColor,
                    image: "assets/images/calendar.png",
                  ),
                  SquareCard(
                    text: 'Self Disease Checker',
                    clickCallback: () {
                      bottomSheet();
                    },
                    color: AppColors.secondaryCardColor,
                    image: "assets/images/checking.png",
                  ),
                  SquareCard(
                    text: widget.userModel.role == "User"
                        ? 'Find a Doctor'
                        : 'Manage Appointments',
                    clickCallback: _findDoctors,
                    color: AppColors.primaryCardColor,
                    image: "assets/images/appoinment.png",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RectangleCard(
                text: "Join Our Community Blog",
                clickCallback: () {
                  _blog();
                },
                color: AppColors.primaryColor,
                image: "assets/images/blog.png",
                description: widget.userModel.role == "User"
                    ? "Let's talk about your health openly. Feel free to ask any questions, without hesitation."
                    : "Support women’s health and share your knowledge with the community",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _findDoctors() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DoctorListScreen()));
  }

  void _imageBasedHealthTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DiseaseCheckerScreen(
              city: widget.userModel.city, country: widget.userModel.country)),
    );
  }

  void _textBasedHealthTracker() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TextDiseaseCheckerScreen(
              city: widget.userModel.city, country: widget.userModel.country)),
    );
  }

  void _healthCalendar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HealthCalendar(userId: widget.userModel.uid ?? "")));
  }

  void _dailyHealthTracker() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DailyHealthTracker(
                  userId: widget.userModel.uid ?? "",
                )));
  }

  void _blog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleListScreen(userModel: widget.userModel),
      ),
    );
  }

  Future bottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryCardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => _imageBasedHealthTracker(),
                child: const Text(
                  'Image Based Diseases Checker',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () => _textBasedHealthTracker(),
                child: const Text(
                  'Text Based Diseases Checker',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
