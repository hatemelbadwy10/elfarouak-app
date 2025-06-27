import '../../../../core/utils/enums.dart';
import '../../domain/entity/expense_entity.dart';

class ExpenseState {
  final RequestStatus requestStatus;
  final List<ExpenseEntity> list;
  final String errMessage;
  final String storeExpenseSuccess;
  final String storeExpenseFailure;
  final String updateExpenseSuccess;
  final String updateExpenseFailure;
  final String deleteExpenseSuccess;
  final String deleteExpenseFailure;

  const ExpenseState({
    this.requestStatus = RequestStatus.initial,
    this.list = const [],
    this.errMessage = '',
    this.storeExpenseSuccess = '',
    this.storeExpenseFailure = '',
    this.updateExpenseSuccess = '',
    this.updateExpenseFailure = '',
    this.deleteExpenseSuccess = '',
    this.deleteExpenseFailure = '',
  });

  ExpenseState copyWith({
    RequestStatus? requestStatus,
    List<ExpenseEntity>? list,
    String? errMessage,
    String? storeExpenseSuccess,
    String? storeExpenseFailure,
    String? updateExpenseSuccess,
    String? updateExpenseFailure,
    String? deleteExpenseSuccess,
    String? deleteExpenseFailure,
  }) {
    return ExpenseState(
      requestStatus: requestStatus ?? this.requestStatus,
      list: list ?? this.list,
      errMessage: errMessage ?? this.errMessage,
      storeExpenseSuccess: storeExpenseSuccess ?? this.storeExpenseSuccess,
      storeExpenseFailure: storeExpenseFailure ?? this.storeExpenseFailure,
      updateExpenseSuccess: updateExpenseSuccess ?? this.updateExpenseSuccess,
      updateExpenseFailure: updateExpenseFailure ?? this.updateExpenseFailure,
      deleteExpenseSuccess: deleteExpenseSuccess ?? this.deleteExpenseSuccess,
      deleteExpenseFailure: deleteExpenseFailure ?? this.deleteExpenseFailure,
    );
  }
}
