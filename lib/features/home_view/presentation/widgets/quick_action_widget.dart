import 'package:flutter/material.dart';

import '../../../../core/utils/styles.dart';
class QuickActionWidget extends StatelessWidget {
  const QuickActionWidget({super.key, required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: Styles.text13.copyWith(color: color)),
      ],
    );
  }
}
