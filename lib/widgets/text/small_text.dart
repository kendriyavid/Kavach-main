// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

// ignore: must_be_immutable
class SmallText extends StatelessWidget {
  Color color;
  final String text;
  double size;
  double height;

  SmallText({
    Key? key,
    this.color = AppColor.smalltextColor,
    required this.text,
    this.size = 12,
    this.height = 1.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'Roboto',
        fontSize: size,
      ),
    );
  }
}
