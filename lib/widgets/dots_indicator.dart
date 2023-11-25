import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onPageSelected;
  final Color activeColor;
  final Color inactiveColor;
  final double size;
  final double spacing;

  const DotsIndicator({
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.size = 10,
    this.spacing = 5,
    Key? key,
    required int currentPage,
  }) : super(key: key, listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => GestureDetector(
          onTap: () {
            onPageSelected(index);
          },
          child: Container(
            width: size,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: spacing / 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (index == (listenable as PageController).page)
                  ? activeColor
                  : inactiveColor,
            ),
          ),
        ),
      ),
    );
  }
}
