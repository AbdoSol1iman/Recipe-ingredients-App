import 'package:flutter/material.dart';
import 'package:wasftk/presentation/screens/bmi/constants.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.borderSide,
    this.height = 190,
    this.width = 180,
  });

  final BorderSide? borderSide;
  final double height;
  final double width;
  final Column child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: borderSide ?? BorderSide.none,
        ),
        color: ktranparentColor,
        child: child,
      ),
    );
  }
}
