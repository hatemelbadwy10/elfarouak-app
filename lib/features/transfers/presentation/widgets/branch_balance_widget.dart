import 'package:flutter/material.dart';

class BranchBalanceCard extends StatelessWidget {
  final String name;
  final String branchBalance;
  final String customerBalance;
  final String currency;
  final dynamic totalBalance;
  final double expense;

  const BranchBalanceCard({
    super.key,
    required this.name,
    required this.branchBalance,
    required this.customerBalance,
    required this.currency,
    required this.totalBalance,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('رصيد الفرع: $totalBalance $currency'),
        ],
      ),
    );
  }
}
