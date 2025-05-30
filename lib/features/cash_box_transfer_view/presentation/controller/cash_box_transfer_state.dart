import 'package:equatable/equatable.dart';
import '../../domain/entity/cash_box_transfer_entity.dart';

abstract class CashBoxTransferState extends Equatable {
  const CashBoxTransferState();

  @override
  List<Object?> get props => [];
}

class CashBoxTransferInitial extends CashBoxTransferState {}

class CashBoxTransferLoading extends CashBoxTransferState {}

class CashBoxTransferLoaded extends CashBoxTransferState {
  final List<CashBoxTransferEntity> transfers;

  const CashBoxTransferLoaded(this.transfers);

  @override
  List<Object?> get props => [transfers];
}

class CashBoxTransferError extends CashBoxTransferState {
  final String message;

  const CashBoxTransferError(this.message);

  @override
  List<Object?> get props => [message];
}
