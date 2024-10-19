import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/appcolor.dart';

class BaseScrollableView extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const BaseScrollableView({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.textColor),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.hintTextColor,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
