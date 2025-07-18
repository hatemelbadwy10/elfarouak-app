part of 'cash_box_bloc.dart';

@immutable
sealed class CashBoxState {}

final class CashBoxInitial extends CashBoxState {}

final class CashBoxLoading extends CashBoxState {}

final class CashBoxSuccess extends CashBoxState {
  final List<CashBoxEntity> list;

  CashBoxSuccess({required this.list});
}

final class CashBoxFailure extends CashBoxState {
  final String errMessage;

  CashBoxFailure({required this.errMessage});
}

final class StoreCashBoxLoading extends CashBoxState {}

final class StoreCashBoxSuccess extends CashBoxState {
  final String message;

  StoreCashBoxSuccess({required this.message});
}

final class StoreCashBoxFailure extends CashBoxState {
  final String errMessage;

  StoreCashBoxFailure({required this.errMessage});
}

final class UpdateCashBoxLoading extends CashBoxState {}

final class UpdateCashBoxSuccess extends CashBoxState {
  final String message;

  UpdateCashBoxSuccess({required this.message});
}

final class UpdateCashBoxFailure extends CashBoxState {
  final String errMessage;

  UpdateCashBoxFailure({required this.errMessage});
}

final class DeleteCashBoxLoading extends CashBoxState {}

final class DeleteCashBoxSuccess extends CashBoxState {
  final String message;

  DeleteCashBoxSuccess({required this.message});
}

final class DeleteCashBoxFailure extends CashBoxState {
  final String errMessage;

  DeleteCashBoxFailure({required this.errMessage});
}
final class UpdateCashBoxBalanceLoading extends CashBoxState{}
final class UpdateCashBoxBalanceSuccess extends CashBoxState{
  final String successMsg;

  UpdateCashBoxBalanceSuccess(this.successMsg);
}
final class UpdateCashBoxBalanceFailure extends CashBoxState{
  final String errorMsg;

  UpdateCashBoxBalanceFailure({required this.errorMsg});
}