import 'package:blossom_health_app/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../utils/appcolor.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String address;
  final String city;
  final String country;
  final String? phoneNumber;
  final String? specialist;
  final Function? onTapPhoneNumber;

  const DoctorCard({
    super.key,
    required this.name,
    required this.address,
    this.phoneNumber,
    required this.city,
    required this.country,
    this.specialist, this.onTapPhoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryCardColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Extensions().capitalizeEachWord("Dr $name"),
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              specialist ?? "",
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            address == ""
                ? const SizedBox.shrink()
                : Text(
                    address,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
            country == "" && city == ""
                ? const SizedBox.shrink()
                : Text(
                    "${Extensions().capitalizeEachWord(city)},$country",
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
            phoneNumber == ""
                ? const SizedBox.shrink()
                : Text(
                    phoneNumber ?? "",
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.left,
                  ),
            SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor),
                    child: const Text("Online Appoinment",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightTextColor,
                        )),
                  ),
                ),
                IconButton(
                  icon:  const Icon(Icons.call_rounded),
                  onPressed: () {onTapPhoneNumber;},
                  color: AppColors.primaryColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
