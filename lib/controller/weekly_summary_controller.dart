import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class WeeklyReportController extends ChangeNotifier {
  final String userId;
  final GenerativeModel model;
  late CollectionReference healthCollection;
  String report = '';
  String advice = '';
  bool isLoading = true;
  bool hasPregnancySymptoms = false;
  bool hasMenstrualSymptoms = false;

  WeeklyReportController({required this.userId, required this.model}) {
    healthCollection = FirebaseFirestore.instance
        .collection('dailyHealth')
        .doc(userId)
        .collection('healthData');
    generateWeeklyReport();
  }

  Future<void> generateWeeklyReport() async {
    isLoading = true;
    notifyListeners();

    DateTime endDate = DateTime.now();
    List<Map<String, dynamic>> weeklyData = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = endDate.subtract(Duration(days: i));
      String formattedDate =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

      QuerySnapshot snapshot =
      await healthCollection.where('date', isEqualTo: formattedDate).get();

      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> dailyData =
        snapshot.docs.first.data() as Map<String, dynamic>;
        weeklyData.add(dailyData);
      }
    }

    analyzeSymptoms(weeklyData);
  }

  void analyzeSymptoms(List<Map<String, dynamic>> weeklyData) {
    Map<String, int> symptomCount = {};
    Map<String, int> pregnancySymptomCount = {};
    Map<String, int> periodSymptomCount = {};

    for (var dailyData in weeklyData) {
      List symptoms = dailyData['symptoms'] ?? [];
      List periods = dailyData['menstrualSymptoms'] ?? [];
      List pregnancys = dailyData['pregnancySymptoms'] ?? [];
      for (var symptom in symptoms) {
        symptomCount[symptom] = (symptomCount[symptom] ?? 0) + 1;
      }
      for (var period in periods) {
        if (dailyData['menstrualSymptoms'] != null &&
            dailyData['menstrualSymptoms'] != "") {
          hasMenstrualSymptoms = true;
        }
        periodSymptomCount[period] = (periodSymptomCount[period] ?? 0) + 1;
      }
      for (var pregnancy in pregnancys) {
        if (dailyData['pregnancySymptoms'] != null &&
            dailyData['pregnancySymptoms'] != "") {
          hasPregnancySymptoms = true;
        }
        pregnancySymptomCount[pregnancy] =
            (pregnancySymptomCount[pregnancy] ?? 0) + 1;
      }
    }

    createReport(symptomCount, pregnancySymptomCount, periodSymptomCount);
  }

  void createReport(Map<String, int> symptomCount, pregnancySymptomCount,
      periodSymptomCount) {
    report = "";
    StringBuffer reportBuffer = StringBuffer('Weekly Symptom Report:\n\n');

    symptomCount.forEach((symptom, count) {
      reportBuffer.writeln('$symptom: $count times');
    });
    pregnancySymptomCount.forEach((symptom, count) {
      reportBuffer.writeln('$symptom: $count times');
    });
    periodSymptomCount.forEach((symptom, count) {
      reportBuffer.writeln('$symptom: $count times');
    });

    report = reportBuffer.toString();
    generateText(report);
  }

  void generateText(String text) async {
    if (text.isEmpty) {
      advice = "e";
      isLoading = false;
      notifyListeners();
      return;
    }
    try {
      var prompt1 =
          "Analyze the Weekly Symptom Report data: $text. If the Weekly Symptom Report data ($text) is empty, unavailable, or has no content to analyze, return only 'e' without any additional sentences. If $hasPregnancySymptoms is true, then pregnancy symptoms are present; provide two sentences of advice related to pregnancy. If $hasMenstrualSymptoms is true, then menstrual symptoms are present; provide two sentences of advice related to menstruation. If neither symptom is present and data is available, share two sentences of general health advice. Ensure all responses are concise and limited to two sentences.";

      final content = [Content.text(prompt1)];

      final response = await model.generateContent(content);

      advice = response.text ?? "Failed to generate text.";
      isLoading = false;
      notifyListeners();
    } catch (e) {
      advice = "Error: ${e.toString()}";
      isLoading = false;
      notifyListeners();
    }
  }
}
