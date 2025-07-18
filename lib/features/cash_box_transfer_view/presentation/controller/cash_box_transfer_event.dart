import 'package:equatable/equatable.dart';

abstract class CashBoxTransferEvent extends Equatable {
  const CashBoxTransferEvent();

  @override
  List<Object?> get props => [];
}

class GetCashBoxTransferEvent extends CashBoxTransferEvent {}
class CompleteCashBoxTransferEvent extends CashBoxTransferEvent {
  final int id;

  const CompleteCashBoxTransferEvent(this.id);

  @override
  List<Object?> get props => [id];
}