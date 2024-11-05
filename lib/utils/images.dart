import 'package:blossom_health_app/utils/appcolor.dart';
import 'package:flutter/material.dart';

class Category{

String getImageForCategory(String category) {
  switch (category) {
    case 'Disease':
      return 'assets/images/disease.jpg';
    case 'Health Advice':
      return 'assets/images/health_advice.jpg';
    case 'Beauty Tips':
      return 'assets/images/beauty_tips.jpg';
    case 'Education':
      return 'assets/images/education.jpg';
    case 'Others':
    default:
      return 'assets/images/default.jpg';
  }

}
Color getCategoryColor(String category){
  switch (category) {
    case 'Disease':
      return AppColors.purpleCardColor;
    case 'Health Advice':
      return AppColors.purpleCardColor;
    case 'Beauty Tips':
      return AppColors.primaryColor;
    case 'Education':
      return AppColors.peachColor;
    case 'Others':
    default:
      return AppColors.secondaryColor;
  }
}
}