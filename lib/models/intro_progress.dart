// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class IntroProgres extends StatelessWidget {
  Color color = Colors.blue;
  double radius = 10;
  IntroProgres({super.key, required this.color, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CircleAvatar(backgroundColor: color, radius: radius),
    );
  }
}
