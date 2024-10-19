import 'package:blossom_health_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/appcolor.dart';

class CommonTextField extends StatelessWidget {
  final String labelText;
  final String? hint;
  final TextEditingController controller;
  final IconButton? iconButton;
  final Widget? prefix;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? format;
  final VoidCallback? onTap;
  final Function? onChange;
  final bool readOnly;

  CommonTextField(
      {required this.labelText,
      required this.controller,
      this.iconButton,
      this.keyBoardType,
      this.format,
      this.onChange, this.onTap, this.prefix, this.readOnly=false, this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(labelText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 8),
        TextField(
          readOnly: readOnly,
          controller: controller,
          keyboardType: keyBoardType,
          inputFormatters: format,
          onTap: onTap,
          onChanged:(value)=> onChange,
          decoration: Style().textFieldDecoration(iconButton, prefix, hint,readOnly),
        ),
      ],
    );
  }
}
