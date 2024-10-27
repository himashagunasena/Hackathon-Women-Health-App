import 'package:blossom_health_app/models/user_model.dart';
import 'package:blossom_health_app/presentation/screen/onboarding_screen/sign_up_password.dart';
import 'package:blossom_health_app/presentation/widget/common_button.dart';
import 'package:blossom_health_app/presentation/widget/common_textfield.dart';
import 'package:blossom_health_app/utils/enum.dart';
import 'package:blossom_health_app/utils/style.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../utils/appcolor.dart';
import '../../widget/alert.dart';

User? user;

class PersonalDetailsScreen extends StatefulWidget {
  final UserType userType;

  const PersonalDetailsScreen({super.key, required this.userType});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController nickNameController = TextEditingController();

  final TextEditingController birthdayController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  final TextEditingController contactController = TextEditingController();

  final TextEditingController specializationController =
      TextEditingController();

  double columnSpace = 16;
  bool agree = false;
  String _phoneNumber = "";
  String countryImage = "";
  String countryPhoneCode = "";
  String countryCode = "LK";
  String? message = "";
  bool visibleWarning = false;

  @override
  initState() {
    birthdayController.text = DateFormat('yyyy/MM/dd').format(DateTime.now());
    countryController.text = "Sri Lanka";
    countryImage = Country.parse('Sri Lanka').flagEmoji;
    countryPhoneCode = Country.parse('Sri Lanka').phoneCode;
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        birthdayController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTextColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24,
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi Girl,',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      RichText(
                        text: const TextSpan(
                          text: 'Sign Up To ',
                          style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: 'Blossom',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/indicator_1.png",
                            height: 10,
                          ),
                          const Text(
                            "Personal Details",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "Full Name",
                        controller: fullNameController,
                      ),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "Nick Name",
                        controller: nickNameController,
                      ),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "Birthday (YYYY / MM / DD)",
                        controller: birthdayController,
                        keyBoardType: TextInputType.datetime,
                        format: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChange: (value) {
                          setState(() {
                            // if (birthdayController.text
                            //     .length == 4) {
                            //   birthdayController.text =
                            //   "${birthdayController.text}/";
                            // }
                            // if (birthdayController.text
                            //     .length == 7) {
                            //   birthdayController.text =
                            //   "${birthdayController.text}/";
                            // }
                          });
                        },
                        iconButton: IconButton(
                          icon: Image.asset(
                            "assets/images/ic_calendar.png",
                            height: 24,
                          ),
                          onPressed: () => _selectDate(context),
                        ),
                      ),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "Email",
                        controller: emailController,
                      ),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: widget.userType == UserType.DOCTOR
                            ? "Hospital Address/ Working Place"
                            : "Address",
                        controller: addressController,
                      ),
                      widget.userType == UserType.DOCTOR
                          ? Padding(
                              padding: EdgeInsets.only(top: columnSpace),
                              child: CommonTextField(
                                labelText: "Specialization",
                                controller: specializationController,
                                hint: "Ex: Dermatologist",
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: columnSpace),
                      CommonTextField(
                        labelText: "City",
                        controller: cityController,
                      ),
                      SizedBox(height: columnSpace),
                      country(),
                      widget.userType == UserType.DOCTOR
                          ? Padding(
                              padding: EdgeInsets.only(top: columnSpace),
                              child: CommonTextField(
                                labelText: "Official Contact Number",
                                controller: contactController,
                                keyBoardType: TextInputType.number,
                                prefix: Text(
                                  "$countryImage | +$countryPhoneCode ",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                format: [
                                  LengthLimitingTextInputFormatter(9),
                                ],
                                onChange: (value) {
                                  setState(() {
                                    _phoneNumber = countryPhoneCode +
                                        contactController.text;
                                  });
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: columnSpace),
                        child: const Text(
                          'Terms and conditions',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                agree = !agree;
                              });
                            },
                            child: Icon(
                              !agree
                                  ? Icons.circle_outlined
                                  : Icons.radio_button_checked_rounded,
                              color: agree
                                  ? AppColors.primaryColor
                                  : AppColors.borderColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'By agreeing to the terms and conditions, you confirm that you are female. To protect user privacy, access to other genders is restricted within the app.',
                              // Display ON/OFF state
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              message != "" && visibleWarning == true
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Alerts().warningCardAlert(message, () {
                        setState(() {
                          visibleWarning = false;
                        });
                      }),
                    )
                  : const SizedBox.shrink(),
              CommonButton(
                text: "Next",
                clickCallback: () => _next(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget country() {
    return CommonTextField(
      labelText: "Country",
      controller: countryController,
      readOnly: true,
      onTap: () {
        showCountryPicker(
          context: context,
          useSafeArea: true,
          showPhoneCode: false,
          countryListTheme: CountryListThemeData(
            flagSize: 25,
            backgroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, color: AppColors.textColor),
            bottomSheetHeight: MediaQuery.of(context).size.height / 1.5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            inputDecoration: Style().textFieldDecoration(
                null,
                const Icon(Icons.search_rounded, color: AppColors.textColor),
                "Search",
                false),
          ),
          onSelect: (Country country) {
            setState(() {
              countryCode = country.countryCode;
              countryController.text = country.name;
              countryImage = country.flagEmoji;
              countryPhoneCode = country.phoneCode;
            });
          },
        );
      },
    );
  }

  void _next() {
    setState(() {
      if (emailController.text.isEmpty) {
        message = "Please enter your email";
        visibleWarning = true;
        return;
      } else if (fullNameController.text.isEmpty) {
        message = "Please enter your full name";
        visibleWarning = true;
        return;
      } else if (nickNameController.text.isEmpty) {
        message = "Please enter your nickname";
        visibleWarning = true;
        return;
      } else if (cityController.text.isEmpty) {
        message = "Please enter your city";
        visibleWarning = true;
        return;
      } else if (countryController.text.isEmpty) {
        message = "Please enter your country";
        visibleWarning = true;
        return;
      } else if (birthdayController.text.isEmpty) {
        message = "Please enter your birthday";
        visibleWarning = true;
        return;
      } else if (widget.userType == UserType.DOCTOR &&
          specializationController.text.isEmpty) {
        message = "Please enter your specialization";
        visibleWarning = true;
        return;
      } else if (widget.userType == UserType.DOCTOR && _phoneNumber.isEmpty) {
        message = "Please enter your phone number";
        visibleWarning = true;
        return;
      } else if (agree == false) {
        message =
            "Sorry, We cannot proceed without agree with our Terms and Conditions";
        visibleWarning = true;
        return;
      }
      UserModel userModel = UserModel(
        uid: user?.uid,
        fullName: fullNameController.text,
        nickName: nickNameController.text,
        email: emailController.text,
        phoneNumber: _phoneNumber ?? "",
        address: addressController.text,
        city: cityController.text.toLowerCase(),
        country: countryController.text,
        birthday: DateFormat('yyyy/MM/dd').parse(birthdayController.text),
        role: widget.userType == UserType.DOCTOR ? "Doctor" : "User",
        specialization: specializationController.text.toLowerCase() ?? "",
      );

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SetPasswordScreen(
                  userModel: userModel,
                )),
      );
    });
  }
}
