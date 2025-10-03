import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/cash_box_entity.dart';

class CashBoxCard extends StatelessWidget {
  final CashBoxEntity cashBox;
  final VoidCallback onChangeBalance;
  final VoidCallback onUpdate;

  const CashBoxCard({
    super.key,
    required this.cashBox,
    required this.onChangeBalance,
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
            Text("الرصيد: ${cashBox.country} ${cashBox.balance}"),
            Text("ملاحظات: ${cashBox.note.isNotEmpty ? cashBox.note : 'لا يوجد'}"),
          ],
        ),
        trailing:context.read<UserInfoBloc>().state.user?.role=='admin'? PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'update') onUpdate();
            if (value == 'changeBalance') onChangeBalance();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'update', child: Text('تحديث')),
            PopupMenuItem(value: 'changeBalance', child: Text('تغير الرصيد')),

            // PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
          icon: const Icon(Icons.more_vert),
        // ignore: prefer_const_constructors
        ):SizedBox(),
      ),
    );
  }
}
