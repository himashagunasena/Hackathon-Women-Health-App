import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/appcolor.dart';

class AdviceCard extends StatelessWidget {
  final String text;
  final String description;
  final String? image;
  final Color? color;

  const AdviceCard({
    super.key,
    required this.text,
    this.image,
    this.color=AppColors.purpleCardColor,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image != null
                ? Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    image!,
                    height: 42,
                  )),
            )
                : const SizedBox.shrink(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w200,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
