import 'package:flutter/material.dart';
import 'package:elfarouk_app/core/utils/styles.dart';

class TransferCard extends StatelessWidget {
  final String from;
  final String to;
  final String amount;
  final String country;

  const TransferCard({
    super.key,
    required this.from,
    required this.to,
    required this.amount,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("من: $from", style: Styles.text18SemiBold),
            const SizedBox(height: 6),
            Text("إلى: $to", style: Styles.text18),
            const SizedBox(height: 6),
            Text("المبلغ: $amount", style: Styles.text18Accent),
            const SizedBox(height: 6),
            Text("البلد: $country", style: Styles.text15),
          ],
        ),
      ),
    );
  }
}
