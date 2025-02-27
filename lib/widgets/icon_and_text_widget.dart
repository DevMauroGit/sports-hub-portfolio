import 'package:flutter/material.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final double w;

  const IconAndTextWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: iconColor, size: w > 605 ? 45 : 35),
      const SizedBox(width: 5),
      Text(
        text,
        style: TextStyle(
            fontSize: w > 605
                ? 23
                : w > 405
                    ? 19
                    : 15,
            color: Colors.black),
      ),
    ]);
  }
}
