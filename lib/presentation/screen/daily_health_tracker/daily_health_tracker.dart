import 'package:blossom_health_app/presentation/widget/alert.dart';
import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../utils/appcolor.dart';
import '../../../utils/enum.dart';

class DailyHealthTracker extends StatefulWidget {
  final String userId;

  const DailyHealthTracker({super.key, required this.userId});

  @override
  DailyHealthTrackerState createState() => DailyHealthTrackerState();
}

class DailyHealthTrackerState extends State<DailyHealthTracker> {
  Mood selectedMood = Mood.happy;
  List<String> selectedSymptoms = [];
  List<String> selectedMenstrualSymptoms = [];
  List<String> selectedPregnancySymptoms = [];
  String healthNote = '';
  bool isDataSavedForToday = false;
  bool visibleWarning = true;
  bool isMenstruating = false;
  bool isPregnant = false;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('dailyHealth');

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: "Daily Health Tracker",
      subtitle: "",
      button: CommonButton(
          text: 'Save',
          enabled: !isDataSavedForToday,
          clickCallback: () => isDataSavedForToday ? null : saveData()),
      error: isDataSavedForToday && visibleWarning
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Alerts().warningCardAlert(
                  "You already saved data for today. Please try tomorrow.", () {
                setState(() {
                  visibleWarning = false;
                });
              }))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: 'Today ',
              style: const TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              children: [
                TextSpan(
                  text: DateFormat("dd/MM/yyyy")
                      .format(DateTime.now())
                      .toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _MoodWidget(
            selectedMood: selectedMood,
            onMoodChanged: (mood) {
              setState(() {
                selectedMood = mood;
              });
            },
          ),
          const SizedBox(height: 20),
          _SymptomSelectionWidget(
            title: 'Physical Symptoms',
            options: const [
              'Feel good',
              'Headache',
              'Fatigue',
              'Muscle pain',
              'Fever',
              'Nausea',
              'Dizziness',
              'Shortness of breath',
            ],
            selectedOptions: selectedSymptoms,
            onOptionChanged: (option) {
              setState(() {
                selectedSymptoms.contains(option)
                    ? selectedSymptoms.remove(option)
                    : selectedSymptoms.add(option);
              });
            },
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Are you menstruating?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _YesNoButton(
                    label: "Yes",
                    isSelected: isMenstruating,
                    onTap: () {
                      setState(() {
                        isMenstruating = true;
                        isPregnant = false; // Ensure pregnancy is unselected
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _YesNoButton(
                    label: "No",
                    isSelected: !isMenstruating,
                    onTap: () {
                      setState(() {
                        isMenstruating = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isMenstruating)
                _SymptomSelectionWidget(
                  title: 'Menstruation Symptoms',
                  options: const [
                    'Nothing',
                    'Menstrual cramps',
                    'Heavy Bleeding',
                    'Light Bleeding',
                    'Irregular periods',
                  ],
                  selectedOptions: selectedMenstrualSymptoms,
                  onOptionChanged: (option) {
                    setState(() {
                      selectedMenstrualSymptoms.contains(option)
                          ? selectedMenstrualSymptoms.remove(option)
                          : selectedMenstrualSymptoms.add(option);
                    });
                  },
                ),
              SizedBox(height: isMenstruating ? 20 : 0),
              const Text("Are you pregnant?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _YesNoButton(
                    label: "Yes",
                    isSelected: isPregnant,
                    onTap: () {
                      setState(() {
                        isPregnant = true;
                        isMenstruating = false;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _YesNoButton(
                    label: "No",
                    isSelected: !isPregnant,
                    onTap: () {
                      setState(() {
                        isPregnant = false;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: isPregnant ? 20 : 0),
              if (isPregnant)
                _SymptomSelectionWidget(
                  title: 'Pregnancy-Related Symptoms',
                  options: const [
                    'Nothing',
                    'Morning sickness',
                    'Swollen feet or ankles',
                    'Back pain',
                  ],
                  selectedOptions: selectedPregnancySymptoms,
                  onOptionChanged: (option) {
                    setState(() {
                      selectedPregnancySymptoms.contains(option)
                          ? selectedPregnancySymptoms.remove(option)
                          : selectedPregnancySymptoms.add(option);
                    });
                  },
                ),
              const SizedBox(height: 20),
              _HealthNoteWidget(
                healthNote: healthNote,
                onNoteChanged: (value) {
                  setState(() {
                    healthNote = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> saveData() async {
    try {
      final data = {
        'date': DateFormat("dd/MM/yyyy").format(DateTime.now()).toString(),
        'mood': selectedMood.name,
        'symptoms': selectedSymptoms,
        'menstrualSymptoms': selectedMenstrualSymptoms,
        'pregnancySymptoms': selectedPregnancySymptoms,
        'healthNote': healthNote,
      };

      if (kDebugMode) {
        print('Saving data: $data');
      } // Debugging print

      await usersCollection
          .doc(widget.userId)
          .collection('healthData')
          .add(data);

      setState(() {
        selectedMood = Mood.happy;
        selectedSymptoms.clear();
        selectedMenstrualSymptoms.clear();
        selectedPregnancySymptoms.clear();
        healthNote = '';
        isDataSavedForToday = true;
        Navigator.of(context).pop();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving data: ${e.toString()}');
      } // Log the error
    }
  }

  Future<void> checkDataForToday() async {
    try {
      String todayDate = DateFormat("dd/MM/yyyy").format(DateTime.now());

      QuerySnapshot snapshot = await usersCollection
          .doc(widget.userId)
          .collection('healthData')
          .where('date', isEqualTo: todayDate)
          .get();
      setState(() {
        isDataSavedForToday = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error checking data: ${e.toString()}');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkDataForToday();
  }
}

class _MoodWidget extends StatelessWidget {
  final Mood selectedMood;
  final Function(Mood) onMoodChanged;

  const _MoodWidget({required this.selectedMood, required this.onMoodChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Mood',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              for (Mood mood in Mood.values)
                GestureDetector(
                  onTap: () => onMoodChanged(mood),
                  child: Opacity(
                    opacity: selectedMood == mood ? 1 : 0.5,
                    child: Image.asset(
                      mood.imagePath,
                      scale: 3,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SymptomSelectionWidget extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final Function(String) onOptionChanged;

  const _SymptomSelectionWidget({
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: [
            for (String option in options)
              _SelectableButton(
                label: option,
                isSelected: selectedOptions.contains(option),
                onTap: () => onOptionChanged(option),
              ),
          ],
        ),
      ],
    );
  }
}

class _SelectableButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppColors.primaryColor : AppColors.enableButton,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.lightTextColor : AppColors.textColor,
        ),
      ),
    );
  }
}

class _HealthNoteWidget extends StatelessWidget {
  final String healthNote;
  final Function(String) onNoteChanged;

  const _HealthNoteWidget({
    required this.healthNote,
    required this.onNoteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Health Note',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
            onChanged: onNoteChanged,
            maxLines: 5,
            decoration:
                Style().textFieldDecoration(null, null, "Say here", false)),
      ],
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _YesNoButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? AppColors.primaryColor : AppColors.enableButton,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.lightTextColor : AppColors.textColor,
        ),
      ),
    );
  }
}
