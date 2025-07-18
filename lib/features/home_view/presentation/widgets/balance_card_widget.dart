import 'package:flutter/material.dart';
import '../../../../core/utils/styles.dart';

class BalanceCardWidget extends StatelessWidget {
  const BalanceCardWidget(
      {super.key,
      required this.label,
      required this.balance,
      required this.color});

  final String label;
  final String balance;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Styles.text15.copyWith(color: color)),
          const SizedBox(height: 8),
          Text("$balance جنيه مصري",
              style: Styles.text18SemiBold.copyWith(color: color)),
        ],
      ),
    );
  }
}
