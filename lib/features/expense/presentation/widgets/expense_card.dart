import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/features/expense/domain/entity/expense_entity.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        getIt<NavigationService>().navigateTo(RouteNames.singleExpenseView,
        arguments: {
          "expense":expense
        }
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: const CircleAvatar(child: Icon(Icons.money_off)),
          title: Text(
            expense.expanseBranch,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الكمية: ${expense.expanseAmount} دينار"),
              Text("الوصف: ${expense.expanseDescription}"),
              Text("التاج: ${expense.expanseTag}"),
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
      ),
    );
  }
}
