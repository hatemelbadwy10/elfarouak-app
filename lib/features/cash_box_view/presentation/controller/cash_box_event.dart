part of 'cash_box_bloc.dart';

@immutable
sealed class CashBoxEvent {}
class GetCashBoxesEvent extends CashBoxEvent {}
class StoreCashBoxEvent extends CashBoxEvent {
  final String name;
  final String country;
  final double balance;
  final String note;
  final String status;

  StoreCashBoxEvent({
    required this.name,
    required this.country,
    required this.balance,
    required this.note,
    required this.status,
  });
}

class UpdateCashBoxEvent extends CashBoxEvent {
  final int id;
  final String name;
  final String country;
  final double balance;
  final String note;
  final String status;

  UpdateCashBoxEvent({
    required this.id,
    required this.name,
    required this.country,
    required this.balance,
    required this.note,
    required this.status,
  });
}

class DeleteCashBoxEvent extends CashBoxEvent {
  final int id;

  DeleteCashBoxEvent({required this.id});
}
class UpdateCashBoxBalanceEvent extends CashBoxEvent{
  final int id;
  final UpdateModel updateModel;

  UpdateCashBoxBalanceEvent({required this.id,required this.updateModel});
}