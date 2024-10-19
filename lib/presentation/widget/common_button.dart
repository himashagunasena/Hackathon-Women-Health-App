import 'package:flutter/material.dart';
import '../../utils/appcolor.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Function clickCallback;
  final Color? textColor;
  final bool enabled;
  final double margin;
  final Color? buttonColor;

  const CommonButton(
      {super.key,
      this.textColor,
      this.enabled = true,
      this.margin = 0.0,
      this.buttonColor = AppColors.primaryColor,
      required this.text,
      required this.clickCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: margin, right: margin),
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(Radius.circular(12.0))),
      child: TextButton(
        onPressed: enabled ? clickCallback as void Function()? : null,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(16.0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor ?? AppColors.lightTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}