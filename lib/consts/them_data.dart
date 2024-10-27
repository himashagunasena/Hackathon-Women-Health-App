import 'package:flutter/material.dart';

import '../utils/appcolor.dart';

class ThemesData {
  DatePickerThemeData dateTimePickerTheme = DatePickerThemeData(
    cancelButtonStyle: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(AppColors.primaryColor)),
    confirmButtonStyle: ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all<Color>(AppColors.primaryColor)),
    todayBackgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
    backgroundColor: AppColors.lightTextColor,
    headerBackgroundColor: AppColors.primaryColor,
    headerForegroundColor: AppColors.lightTextColor,
    dayBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? AppColors.secondaryColor
            : Colors.transparent),
    dayForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? AppColors.lightTextColor
            : AppColors.textColor),
    yearForegroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? AppColors.lightTextColor
            : AppColors.textColor),
    todayForegroundColor:
        MaterialStateProperty.all<Color>(AppColors.primaryColor),
    yearBackgroundColor: MaterialStateColor.resolveWith((states) =>
        states.contains(MaterialState.selected)
            ? AppColors.secondaryColor
            : Colors.transparent),
    dayOverlayColor:
        MaterialStateProperty.all<Color>(AppColors.secondaryCardColor),
    rangeSelectionBackgroundColor: AppColors.secondaryColor.withOpacity(0.3),
  );
}
