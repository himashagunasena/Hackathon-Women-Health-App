import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:blossom_health_app/presentation/widget/bullet_list.dart';
import 'package:blossom_health_app/presentation/widget/doctor_card.dart';
import 'package:blossom_health_app/utils/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../controller/get_data_controller.dart';

class FindDoctorScreen extends StatefulWidget {
  final String? disease;
  final String? city;
  final String? country;
  final List<String>? doctorList;
  final List<String>? doctorWork;

  const FindDoctorScreen(
      {super.key,
      this.disease,
      this.doctorList,
      this.doctorWork,
      this.city,
      this.country});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  List<BulletList>? guideline = [];
  Map<String, List<UserModel>> filteredUsersBySpecialization = {};
  List<GlobalKey> subtitleKeys = [];
  List<double> _subtitleHeights = [];

  @override
  void initState() {
    super.initState();
    _subtitleHeights = List<double>.filled(widget.doctorList?.length ?? 0, 0);
    subtitleKeys =
        List.generate(widget.doctorList?.length ?? 0, (index) => GlobalKey());
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    for (String specialization in widget.doctorList ?? []) {
      List<UserModel> users = await fetchFilteredUsers(
          specialization.toLowerCase(),
          "Doctor",
          widget.city ?? "",
          widget.country ?? "");
      filteredUsersBySpecialization[specialization] = users;
    }
    list();
    setState(() {});
  }

  void list() {
    guideline?.clear();
    if (widget.doctorList != null && widget.doctorList!.isNotEmpty) {
      for (int i = 0; i < widget.doctorList!.length; i++) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (subtitleKeys[i].currentContext != null) {
            RenderBox renderBox =
                subtitleKeys[i].currentContext!.findRenderObject() as RenderBox;
            double height = renderBox.size.height;

            if (height != _subtitleHeights[i]) {
              setState(() {
                _subtitleHeights[i] = height;
              });
            }
          }
        });

        String specialization =
            widget.doctorList![i].trimRight().replaceAll('.', '');
        List<UserModel> users =
            filteredUsersBySpecialization[specialization] ?? [];
        String doctorWork =
            (widget.doctorWork != null && widget.doctorWork!.length > i)
                ? widget.doctorWork![i].trim() == "e"
                    ? "No information available"
                    : widget.doctorWork![i].trimLeft()
                : "No information available";
        Widget userWidget = Column(
          key: subtitleKeys[i],
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: doctorWork,
            ),
            ...users.map((user) {
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DoctorCard(
                  name: user.fullName ?? "",
                  address: user.address ?? "",
                  phoneNumber: user.phoneNumber ?? "",
                  city: user.city ?? "",
                  country: user.country ?? "",
                ),
              );
            }),
          ],
        );

        guideline?.add(BulletList(specialization, userWidget));
      }
    } else {
      guideline?.add(BulletList("No specializations available",
          const Text("No doctors found for the specified criteria.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: "Guideline To Find A Doctor",
      subtitle:
          "You can find the best female doctor in your area regarding your ${widget.disease?.trim() == "e" ? "diseases" : widget.disease?.trimRight().replaceAll('.', '')}",
      headAndBodySpace: 0,
      child: filteredUsersBySpecialization.isEmpty
          ? Center(
              child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
              child: const CircularProgressIndicator(
                color: AppColors.primaryCardColor,
              ),
            ))
          : Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BulletListScreen(
                list: guideline,
                height: _subtitleHeights,
              ),
            ),
    );
  }
}
