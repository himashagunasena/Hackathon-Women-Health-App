import 'package:blossom_health_app/presentation/screen/self_diseases_checker/find_doctor.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../utils/appcolor.dart';
import '../../../utils/prompts.dart';
import '../../../utils/style.dart';
import '../../widget/base_view.dart';

class TextDiseaseCheckerScreen extends StatefulWidget {
  final String? city;
  final String? country;

  const TextDiseaseCheckerScreen({super.key, this.city, this.country});

  @override
  State<TextDiseaseCheckerScreen> createState() =>
      _TextDiseaseCheckerScreenState();
}

class _TextDiseaseCheckerScreenState extends State<TextDiseaseCheckerScreen> {
  GenerativeModel? _model;
  String? title;
  String? des;
  String? doctorSpec;
  String? doctorWorks;
  String? diseaseName;
  bool isLoading = false;
  bool submit = false;
  TextEditingController explainController = TextEditingController();

  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: 'AIzaSyCD4TBsaDFFqeFrMk2nPAYSpyC0FdmygP8');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: 'Disease Checker',
      subtitle:
          'Check your health and get AI-based advice instantly with our self-assessment tool',
      button: (submit && !isLoading && diseaseName?.trim() != "e" && title != null)
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CommonButton(
                text: "Guideline To Find A Doctor",
                clickCallback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindDoctorScreen(
                              disease: diseaseName,
                              doctorList: doctorList(),
                              doctorWork: doctorWorksList(),
                              country: widget.country,
                              city: widget.city,
                            )),
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explain Your Condition',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: Style().textFieldDecoration(const SizedBox.shrink(),
                const SizedBox.shrink(), "Say here", false),
            controller: explainController,
            minLines: 10,
            maxLines: 10,   ),
          TextButton(
            onPressed: () {
              setState(() {
                submit = true;
                isLoading = true;
                title = "";
                des = "";
                generateText(explainController.text);
              });
            },
            child: const Text(
              'Generate',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text('Analyzing your condition...'),
            ),
          if (!isLoading && title != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: MarkdownBody(
                data: title ?? "",
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void generateText(String text) async {
    if (text.isEmpty) {
      setState(() {
        title = "No text provided.";
        isLoading = false;
      });
      return;
    }
    try {
      var prompt1 = Prompt.diseaseAnalysisText(text);
      var prompt2 = Prompt.diseaseAnalysisValueText(text);
      var prompt3 = Prompt.doctorDetailsText(text);
      var prompt4 = Prompt.diseaseNameText(text);

      final content = [Content.text(prompt1)];
      final value = [Content.text(prompt2)];
      final doctor = [Content.text(prompt3)];
      final name = [Content.text(prompt4)];

      final response = await _model?.generateContent(content);
      final percentage = await _model?.generateContent(value);
      final doctorDetails = await _model?.generateContent(doctor);
      final nameOfDisease = await _model?.generateContent(name);

      setState(() {
        title = response?.text ?? "Failed to generate text.";
        des = percentage?.text ?? "0";
        doctorSpec = doctorDetails?.text ?? "";
        diseaseName = nameOfDisease?.text ?? "";
        isLoading = false;
      });

      var prompt5 =
          "Analysis the $title provide explanations what is the job of $doctorSpec for $diseaseName in order. If you have no idea of one doctor role please return empty string with ';' for seperate them. Separate each explanation by a ';' and return only how to work with disease each doctors don't return specialization name or any title. If cannot identify the $doctorSpec then only return 'e'.";
      final work = [Content.text(prompt5)];
      final workLoad = await _model?.generateContent(work);
      doctorWorks = workLoad?.text ?? "";
    } catch (e) {
      setState(() {
        title = "Error: ${e.toString()}";
        des = "e";
        diseaseName="e";
        isLoading = false;
      });
    }
  }

  List<String>? doctorList() {
    List<String>? value = doctorSpec?.split(',');
    return value;
  }

  List<String>? doctorWorksList() {
    List<String>? value = doctorWorks?.split(';');
    return value;
  }
}
