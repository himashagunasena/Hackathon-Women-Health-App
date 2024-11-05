import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../utils/appcolor.dart';

class BaseScrollableView extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? error;
  final Widget child;
  final Widget? button;
  final double? headAndBodySpace;
  final Widget? icon;

  const BaseScrollableView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.button,
    this.headAndBodySpace,  this.error, this.icon,
  });

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
                padding:
                    EdgeInsets.only(top: 24, bottom: headAndBodySpace ?? 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: icon?? const SizedBox.shrink(),
                        )
                      ],
                    ),
                    subtitle == ""
                        ? const SizedBox.shrink()
                        : Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.hintTextColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                    error??const SizedBox.shrink(),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: child,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: button ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
