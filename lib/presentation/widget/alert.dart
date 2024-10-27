import 'package:blossom_health_app/utils/appcolor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Alerts {
  Widget warningCardAlert(String? message, VoidCallback? ontap) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.badColor.withOpacity(0.15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.badColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 6,
                  child: Text(
                    message ?? "",
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: AppColors.badColor, fontSize: 14),
                  ),
                ),
              ],),
            ),
            GestureDetector(onTap: ontap,child:  const Icon(
              Icons.close,
              color: AppColors.badColor,
            ),)
          ],
        ),
      ),
    );
  }
}
