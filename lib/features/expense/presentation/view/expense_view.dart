import 'package:elfarouk_app/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../controller/expense_bloc.dart';
import '../controller/expense_state.dart';
import '../widgets/expense_card.dart';

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المصروفات')),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.requestStatus == RequestStatus.success) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final expense = state.list[index];
                return ExpenseCard(
                  expense: expense,
                  onDelete: () {
                    context
                        .read<ExpenseBloc>()
                        .add(DeleteExpenseEvent(id: expense.expenseId ?? 1));
                  },
                  onUpdate: () {
                    getIt<NavigationService>().navigateTo(
                      RouteNames.addExpenseView,
                      arguments: {"expense": expense},
                    );
                  },
                );
              },
            );
          } else if (state.requestStatus == RequestStatus.failure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIt<NavigationService>().navigateTo(RouteNames.addExpenseView);
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة مصروف',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
