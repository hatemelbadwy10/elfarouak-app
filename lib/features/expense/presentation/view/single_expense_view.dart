import 'package:flutter/material.dart';

class SingleExpenseView extends StatelessWidget {
final Map<String,dynamic>argument;
  const SingleExpenseView({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المصروف')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('الفرع:', argument['expense'].expanseBranch),
                _buildRow('الكمية:', '${argument['expense'].expanseAmount} دينار'),
                _buildRow('الوصف:', argument['expense'].expanseDescription),
                _buildRow('التاج:', argument['expense'].expanseTag),
                // You can add more fields if your model has date, createdBy, etc.
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
