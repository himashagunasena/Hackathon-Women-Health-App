import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../widget/advice_card.dart';

class WeeklyReport extends StatefulWidget {
  final String userId;

  const WeeklyReport({super.key, required this.userId});

  @override
  _WeeklyReportState createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  late CollectionReference healthCollection;
  String report = '';
  String advice = '';
  GenerativeModel? _model;
  bool isLoading = true;
  bool hasPregnancySymptoms = false;
  bool hasMenstrualSymptoms = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: 'AIzaSyCD4TBsaDFFqeFrMk2nPAYSpyC0FdmygP8');
    healthCollection = FirebaseFirestore.instance
        .collection('dailyHealth')
        .doc(widget.userId)
        .collection('healthData');
    generateWeeklyReport();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    generateWeeklyReport();
  }

  Future<void> generateWeeklyReport() async {
    setState(() {
      isLoading = true;
    });

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
        if (dailyData['menstrualSymptoms'] != null ||
            dailyData['menstrualSymptoms'] != "") {
          hasMenstrualSymptoms = true;
        }
        periodSymptomCount[period] = (periodSymptomCount[period] ?? 0) + 1;
      }
      for (var pregnancy in pregnancys) {
        if (dailyData['pregnancySymptoms'] != null ||
            dailyData['pregnancySymptoms'] != "") {
          hasPregnancySymptoms = true;
        }
        pregnancySymptomCount[pregnancy] =
            (periodSymptomCount[pregnancy] ?? 0) + 1;
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

    setState(() {
      report = reportBuffer.toString();
      generateText(report);
    });
  }

  void generateText(String text) async {
    if (text.isEmpty) {
      setState(() {
        advice = "No text provided.";
        isLoading = false;
      });
      return;
    }
    try {
      var prompt1 =
          "Analyze the following data: $text.  If there are $hasPregnancySymptoms is true then pregnancy symptoms present, provide two sentences of advice related to pregnancy. else If the provided data is empty, return 'e'. If there are  $hasMenstrualSymptoms is true then menstrual symptoms present, give two sentences of advice related to menstruation. Otherwise, share two sentences of general health advice. Please ensure the responses are concise, limited to two short sentences each.";

      final content = [Content.text(prompt1)];

      final response = await (_model?.generateContent(content));

      setState(() {
        advice = response?.text ?? "Failed to generate text.";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        advice = "Error: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdviceCard(
      text: "Health Advice",
      description: advice.isEmpty || advice == "e" || isLoading
          ? "Track your daily symptoms and get a detailed weekly summary here."
          : advice,
    );
  }
}
