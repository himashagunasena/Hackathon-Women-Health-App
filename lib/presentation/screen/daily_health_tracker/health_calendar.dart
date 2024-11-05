import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/appcolor.dart';
import '../../../utils/enum.dart';
import '../../widget/table_calendar.dart';

class HealthCalendar extends StatefulWidget {
  final String userId;

  const HealthCalendar({super.key, required this.userId});

  @override
  _HealthCalendarState createState() => _HealthCalendarState();
}

class _HealthCalendarState extends State<HealthCalendar> {
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic> dailyData = {};
  late CollectionReference healthCollection;
  List physical = [];
  List periods = [];
  List pregnancy = [];
  Mood? mood;

  @override
  void initState() {
    super.initState();
    healthCollection = FirebaseFirestore.instance
        .collection('dailyHealth')
        .doc(widget.userId)
        .collection('healthData');
    fetchDailyData(_selectedDate);
  }

  Future<void> fetchDailyData(DateTime date) async {
    physical = [];
    periods = [];
    pregnancy = [];
    String formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    QuerySnapshot snapshot =
        await healthCollection.where('date', isEqualTo: formattedDate).get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        dailyData = snapshot.docs.first.data() as Map<String, dynamic>;
        physical.addAll(dailyData['symptoms'] ?? []);
        periods.addAll(dailyData['menstrualSymptoms'] ?? []);
        pregnancy.addAll(dailyData['pregnancySymptoms'] ?? []);
        String moodString = dailyData["mood"] ?? "";
        mood = Mood.values.firstWhere(
          (m) => m.name == moodString,
        );
      });
    } else {
      setState(() {
        dailyData = {};
      });
    }
  }

  void _onDateSelected(DateTime selectedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
    fetchDailyData(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: 'Calendar',
      subtitle: "",
      icon: dailyData["mood"] != "" && dailyData["mood"] != null
          ? Image.asset(
              mood?.imagePath ?? "",
              height: 32,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCalendar(
            initialDate: _selectedDate,
            onDateSelected: _onDateSelected,
          ), // Using CustomWeekCalendar
          const SizedBox(height: 20),
          dailyData.isEmpty
              ? title("You have not entered the daily health")
              : _buildDailyDetails(),
        ],
      ),
    );
  }

  Widget _buildDailyDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Physical Symptoms"),
        physicalList(),
        const SizedBox(height: 20),
        periodSymptoms(),
        pregnancySymptoms(),
        healthNote()
      ],
    );
  }

  Widget title(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget physicalList() {
    return Wrap(
      spacing: 24.0,
      children: physical.map((symptom) {
        return Text(
          symptom.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textColor,
          ),
        );
      }).toList(),
    );
  }

  Widget healthNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title("Health Note"),
        Text(
          dailyData["healthNote"] == "" || dailyData["healthNote"] == null
              ? "--"
              : dailyData["healthNote"].toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textColor,
          ),
        ),
      ],
    );
  }

  Widget periodSymptoms() {
    return periods == [] || periods.isEmpty
        ? Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title("Periods"),
                  const SizedBox(width: 24),
                  const Text(
                    "No",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
          ],
        )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title("Menstruation Symptoms"),
              Wrap(
                spacing: 24.0,
                children: periods.map((symptom) {
                  return Text(
                    symptom.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          );
  }

  Widget pregnancySymptoms() {
    return pregnancy == [] || pregnancy.isEmpty
        ? Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title("Are You Pregnant?"),
                  const SizedBox(width: 16),
                  const Text(
                    "No",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
          ],
        )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title("Pregnancy-Related Symptoms"),
              Wrap(
                spacing: 24.0,
                children: pregnancy.map((symptom) {
                  return Text(
                    symptom.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.textColor,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          );
  }
}
