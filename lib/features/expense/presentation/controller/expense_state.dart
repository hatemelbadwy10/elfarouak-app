part of 'expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoading extends ExpenseState {}

final class ExpenseSuccess extends ExpenseState {
  final List<ExpenseEntity> list;

  ExpenseSuccess({required this.list});
}

final class ExpenseFailure extends ExpenseState {
  final String errMessage;

  ExpenseFailure({required this.errMessage});
}

final class StoreExpenseLoading extends ExpenseState {}

final class StoreExpenseSuccess extends ExpenseState {
  final String message;

  StoreExpenseSuccess({required this.message});
}

final class StoreExpenseFailure extends ExpenseState {
  final String errMessage;

  StoreExpenseFailure({required this.errMessage});
}

final class UpdateExpenseLoading extends ExpenseState {}

final class UpdateExpenseSuccess extends ExpenseState {
  final String message;

  UpdateExpenseSuccess({required this.message});
}

final class UpdateExpenseFailure extends ExpenseState {
  final String errMessage;

  UpdateExpenseFailure({required this.errMessage});
}

final class DeleteExpenseLoading extends ExpenseState {}

final class DeleteExpenseSuccess extends ExpenseState {
  final String message;

  DeleteExpenseSuccess({required this.message});
}

final class DeleteExpenseFailure extends ExpenseState {
  final String errMessage;

  DeleteExpenseFailure({required this.errMessage});
}
