part of 'transfer_bloc.dart';

@immutable
sealed class TransferState {}

final class TransferInitial extends TransferState {}

final class GetTransfersLoading extends TransferState {}

final class GetTransfersSuccess extends TransferState {
  final List<TransferEntity> list;

  GetTransfersSuccess({required this.list});
}

final class GetTransfersFailure extends TransferState {
  final String errMessage;

  GetTransfersFailure({required this.errMessage});
}

final class StoreTransferLoading extends TransferState {}

final class StoreTransferSuccess extends TransferState {
  final String message;

  StoreTransferSuccess({required this.message});
}

final class StoreTransferFailure extends TransferState {
  final String errMessage;

  StoreTransferFailure({required this.errMessage});
}

final class UpdateTransferLoading extends TransferState {}

final class UpdateTransferSuccess extends TransferState {
  final String message;

  UpdateTransferSuccess({required this.message});
}

final class UpdateTransferFailure extends TransferState {
  final String errMessage;

  UpdateTransferFailure({required this.errMessage});
}

final class DeleteTransferLoading extends TransferState {}

final class DeleteTransferSuccess extends TransferState {
  final String message;

  DeleteTransferSuccess({required this.message});
}

final class DeleteTransferFailure extends TransferState {
  final String errMessage;

  DeleteTransferFailure({required this.errMessage});
}
final class AutoCompleteLoading extends TransferState {}

final class AutoCompleteSuccess extends TransferState {
  final List<AutoCompleteModel> autoCompleteList;

  AutoCompleteSuccess({required this.autoCompleteList});
}

final class AutoCompleteFailure extends TransferState {
  final String errMessage;

  AutoCompleteFailure({required this.errMessage});
}

final class StoreTagLoading extends TransferState {}

final class StoreTagSuccess extends TransferState {
  final String tagId;

  StoreTagSuccess({required this.tagId});
}

final class StoreTagFailure extends TransferState {
  final String errMessage;

  StoreTagFailure({required this.errMessage});
}
