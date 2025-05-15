import 'package:flutter/material.dart';
import '../../domain/entity/cash_box_entity.dart';

class CashBoxCard extends StatelessWidget {
  final CashBoxEntity cashBox;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const CashBoxCard({
    super.key,
    required this.cashBox,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(child: Icon(Icons.account_balance_wallet)),
        title: Text(
          cashBox.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("الدولة: ${cashBox.country}"),
            Text("الرصيد: EGP ${cashBox.balance.toStringAsFixed(2)}"),
            Text("ملاحظات: ${cashBox.note.isNotEmpty ? cashBox.note : 'لا يوجد'}"),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'update') onUpdate();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'update', child: Text('تحديث')),
            PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
          icon: const Icon(Icons.more_vert),
        ),
      ),
    );
  }
}
