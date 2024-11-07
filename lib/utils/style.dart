import 'package:flutter/material.dart';

import 'appcolor.dart';

class Style{

  InputDecoration textFieldDecoration(Widget? suffix,Widget? prefix,String? text,bool readonly){
    return InputDecoration(
      labelText: text,
      alignLabelWithHint: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color: AppColors.primaryColor, width: 1)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:  BorderSide(
              color:readonly?AppColors.borderColor: AppColors.primaryColor, width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
              color: AppColors.borderColor, width: 1)),
      suffixIcon: suffix ?? const SizedBox.shrink(),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 0, // Set minimum width
        minHeight: 0, // Set minimum height
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: prefix ?? const SizedBox.shrink(),
      ),);}
}