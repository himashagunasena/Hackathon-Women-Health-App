import 'dart:io';

import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../../utils/appcolor.dart';
import '../../utils/prompts.dart';
import '../widget/base_view.dart';

class DiseaseCheckerScreen extends StatefulWidget {
  const DiseaseCheckerScreen({super.key});

  @override
  State<DiseaseCheckerScreen> createState() => _DiseaseCheckerScreenState();
}

class _DiseaseCheckerScreenState extends State<DiseaseCheckerScreen> {
  GenerativeModel? _model;
  String? text;
  String? des;
  XFile? _image;
  bool isLoading = false;
  final picker = ImagePicker();

  @override
  void initState() {
    _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: 'AIzaSyCD4TBsaDFFqeFrMk2nPAYSpyC0FdmygP8');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null && (text == null || des == null)) {
      isLoading = true;
    } else {
      isLoading = false;
    }
    return BaseScrollableView(
      title: 'Disease Checker',
      subtitle:
          'Check your health and get AI-based advice instantly with our self-assessment tool',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload an Image of Your Condition',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonButton(
                text: 'Gallery',
                clickCallback: () => gallery(),
                width: MediaQuery.of(context).size.width / 2.3,
              ),
              const SizedBox(width: 8),
              CommonButton(
                text: 'Camera',
                clickCallback: () => camera(),
                width: MediaQuery.of(context).size.width / 2.3,
                buttonColor: AppColors.secondaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _image == null
              ? const Center(
                  child: Text(
                    'Please select an image',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                )
              : Container(
                  height: 158,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.lightTextColor,
                      image: DecorationImage(
                        image: FileImage(File(_image!.path)),
                        // Use FileImage with Image.file
                        fit: BoxFit.cover,
                      )),
                ),
          _image == null ||
                  isLoading ||
                  des?.replaceAll(RegExp(r'\s+'), '') == "e"
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: healthState()),
                    child: Text(
                      healthDescription(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextColor),
                    ),
                  ),
                ),
          _image == null
              ? const SizedBox.shrink()
              : isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('Analyzing your condition...'),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: (des == "e") ? 24 : 8),
                      child: MarkdownBody(
                        data: text ?? "",
                      ),
                    ),
        ],
      ),
    );
  }

  void generateText(XFile? image) async {
    if (image == null) {
      setState(() {
        text = "No image selected.";
      });
      return;
    }
    try {
      var prompt1 = Prompt.diseaseAnalysis;
      var prompt2 = Prompt.diseaseAnalysisValue;
      var imgBytes = await image.readAsBytes();
      var mimeType = lookupMimeType(_image!.path) ?? 'image/unknown';

      final content = [
        Content.multi([TextPart(prompt1), DataPart(mimeType, imgBytes)]),
      ];
      final value = [
        Content.multi([TextPart(prompt2), DataPart(mimeType, imgBytes)]),
      ];

      final response = await _model?.generateContent(content);
      final percentage = await _model?.generateContent(value);

      setState(() {
        text = response?.text ?? "Failed to generate text.";

        des = percentage?.text ?? "0";
      });
    } catch (e) {
      setState(() {
        text = "Error: ${e.toString()}";
        des = "e";
      });
    }
  }

  Future<void> gallery() async {
    _image = null;
    text = null;
    des = null;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
        generateText(_image);
      } else {
        if (kDebugMode) {
          if (kDebugMode) {
            print('No image selected.');
          }
        }
      }
    });
  }

  Future<void> camera() async {
    _image = null;
    text = null;
    des = null;
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = XFile(pickedFile.path);
        generateText(_image);
      } else {
        if (kDebugMode) {
          print('No image captured.');
        }
      }
    });
  }

  Color healthState() {
    if (des != "e" && des != null) {
      double value = double.tryParse(des ?? "0") ?? 0;
      if (value > 80) {
        return AppColors.goodColor;
      } else if (value > 20) {
        return AppColors.neutralColor;
      }
      return AppColors.badColor;
    }
    return AppColors.badColor;
  }

  String healthDescription() {
    if (des != "e" && des != null) {
      double value = double.tryParse(des ?? "0") ?? 0;
      if (value == 100) {
        return "Good Health Condition";
      } else if (value > 40) {
        return "Cautionary Health Condition";
      }
      return "Critical Health Condition";
    }
    return "";
  }
}
