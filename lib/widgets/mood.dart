import 'package:flutter/material.dart';

class MoodFace extends StatelessWidget {
  final double value;

  const MoodFace({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    if (value < 1) {
      icon = Icons.sentiment_very_dissatisfied;
      color = Colors.redAccent;
    } else if (value == 1) {
      icon = Icons.sentiment_dissatisfied;
      color = Colors.redAccent;
    } else if (value <= 2) {
      icon = Icons.sentiment_neutral;
      color = Colors.amber;
    } else if (value == 3) {
      icon = Icons.sentiment_satisfied;
      color = Colors.green;
    } else {
      icon = Icons.sentiment_very_satisfied;
      color = Colors.green;
    }

    return CircleAvatar(
      radius: 55,
      backgroundColor: color.withValues(alpha: 0.2),
      child: Icon(icon, size: 70, color: color),
    );
  }
}
