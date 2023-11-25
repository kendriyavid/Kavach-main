import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class OtpEditor extends StatelessWidget {
  OtpEditor({super.key});
  final textOnectrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextFormField(
        controller: textOnectrl,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          hintText: "*",
          filled: true,
          fillColor: AppColor.otpboxColor,
        ),
      ),
    );
  }
}
