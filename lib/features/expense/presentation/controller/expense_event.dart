part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

class GetExpensesEvent extends ExpenseEvent {}

class StoreExpenseEvent extends ExpenseEvent {
  final int tagId,branchId;
  final double amount;
  final String description;
  StoreExpenseEvent({
    required this.tagId,
    required this.amount,
    required this.branchId,
    required this.description,
  });
}

class UpdateExpenseEvent extends ExpenseEvent {
  final int id;
  final int tagId,branchId;
  final double amount;
  final String description;

  UpdateExpenseEvent({
    required this.id,
    required this.tagId,
    required this.amount,
    required this.branchId,
    required this.description,
  });
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int id;

  DeleteExpenseEvent({required this.id});
}
