import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import '../../controller/weekly_summary_controller.dart';
import '../widget/advice_card.dart';

class WeeklyReport extends StatelessWidget {
  final String userId;

  const WeeklyReport({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeeklyReportController(
        userId: userId,
        model: GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: 'AIzaSyCD4TBsaDFFqeFrMk2nPAYSpyC0FdmygP8',
        ),
      ),
      child: Consumer<WeeklyReportController>(
        builder: (context, controller, child) {
          return AdviceCard(
            text: "Health Advice",
            description: controller.advice.isEmpty ||
                controller.advice.trim() == "e" ||
                controller.isLoading
                ? "Track your daily symptoms and get a detailed weekly summary here."
                : controller.advice,
          );
        },
      ),
    );
  }
}
