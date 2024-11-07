import 'package:flutter/material.dart';
import '../../utils/appcolor.dart';

class SquareCard extends StatelessWidget {
  final String text;
  final Function clickCallback;
  final String? image;
  final Color? color;

  const SquareCard({
    super.key,
    required this.text,
    required this.clickCallback,
    this.image,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> clickCallback(),
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              image != null
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        image!,
                        height: 42,
                      ))
                  : const SizedBox.shrink(),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.lightTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
