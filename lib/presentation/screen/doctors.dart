import 'package:blossom_health_app/presentation/widget/base_view.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:blossom_health_app/presentation/widget/doctor_card.dart';
import 'package:flutter/material.dart';
import '../../controller/doctor_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/doctor_model.dart'; // Import the Doctor model

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  TextEditingController searchController = TextEditingController();
  String? name;
  String? city;
  String? country;
  String? specialization;
  late Future<List<Doctor>> doctorList;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    doctorList = fetchDoctors(name, city, country, specialization);
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
        doctorList = fetchFilteredDoctors();
      });
    });
  }

  _makingPhoneCall(String? mobile) async {
    var url = Uri.parse("tel:$mobile");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Doctor>> fetchFilteredDoctors() async {
    final allDoctors = await fetchDoctors(name, city, country, specialization);
    return allDoctors.where((doctor) {
      final nameMatches = searchQuery.isEmpty ||
          (doctor.name ?? '').toLowerCase().contains(searchQuery.toLowerCase());
      final cityMatches = searchQuery.isEmpty ||
          (doctor.city ?? '').toLowerCase().contains(searchQuery.toLowerCase());
      final countryMatches = searchQuery.isEmpty ||
          (doctor.country ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      final specializationMatches = searchQuery.isEmpty ||
          (doctor.specialization ?? '')
              .toLowerCase()
              .contains(searchQuery.toLowerCase());

      return nameMatches ||
          cityMatches ||
          countryMatches ||
          specializationMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableView(
      title: "Find A Doctor",
      subtitle: "You can find the best female doctors worldwide",
      child: Column(
        children: [
          CommonTextField(
            controller: searchController,
            hint: 'Search doctors by name, city, country, or specialization',
            labelText: '',
            prefix: const Icon(Icons.search),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Doctor>>(
            future: doctorList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No doctors found'));
              } else {
                final doctors = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return Column(
                      children: [
                        DoctorCard(
                          name: doctor.name ?? "",
                          city: doctor.city ?? "",
                          country: doctor.country ?? "",
                          address: doctor.address ?? "",
                          phoneNumber: doctor.phoneNumber ?? "",
                          specialist: doctor.specialization ?? "",
                          onTapPhoneNumber: () {
                            _makingPhoneCall(doctor.phoneNumber ?? "");
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
