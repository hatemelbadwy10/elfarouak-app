import 'package:equatable/equatable.dart';

abstract class CashBoxTransferEvent extends Equatable {
  const CashBoxTransferEvent();

  @override
  List<Object?> get props => [];
}

class GetCashBoxTransferEvent extends CashBoxTransferEvent {}
