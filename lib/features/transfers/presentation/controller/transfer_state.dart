part of 'transfer_bloc.dart';

@immutable
sealed class TransferState {}

class TransferInitial extends TransferState {}

class GetTransfersLoading extends TransferState {}

class GetTransfersSuccess extends TransferState {
  final List<TransferEntity> list;
  final dynamic rate;
  final bool hasReachedEnd;
  final int currentPage;
  final bool isLoadingMore;
  final dynamic totalTransfers;
  final dynamic totalAmountReceived;
  final dynamic totalBalanceEgp;
  final String? search;
  final String? status;
  final String? transferType;
  final String? tagId;
  final String? dateRange;
  final int? cashBoxId;
  final bool showBox;
  final List<CashBoxes> cashBoxes;

  GetTransfersSuccess(
      {required this.list,
      required this.hasReachedEnd,
      required this.currentPage,
      this.isLoadingMore = false,
      required this.rate,
      this.totalTransfers,
      this.totalAmountReceived,
      this.totalBalanceEgp,
      this.search,
      this.status,
      this.transferType,
      this.tagId,
      this.dateRange,
      this.cashBoxId,
      required this.showBox,
      required this.cashBoxes});
}

class GetTransfersFailure extends TransferState {
  final String errMessage;

  GetTransfersFailure({required this.errMessage});
}

// Store Transfer States
class StoreTransferLoading extends TransferState {}

class StoreTransferSuccess extends TransferState {
  final String message;

  StoreTransferSuccess({required this.message});
}

class StoreTransferFailure extends TransferState {
  final String errMessage;

  StoreTransferFailure({required this.errMessage});
}

// Update Transfer States
class UpdateTransferLoading extends TransferState {}

class UpdateTransferSuccess extends TransferState {
  final String message;

  UpdateTransferSuccess({required this.message});
}

class UpdateTransferFailure extends TransferState {
  final String errMessage;

  UpdateTransferFailure({required this.errMessage});
}

// Delete Transfer States
class DeleteTransferLoading extends TransferState {}

class DeleteTransferSuccess extends TransferState {
  final String message;

  DeleteTransferSuccess({required this.message});
}

class DeleteTransferFailure extends TransferState {
  final String errMessage;

  DeleteTransferFailure({required this.errMessage});
}

// Auto Complete States
class AutoCompleteLoading extends TransferState {}

class AutoCompleteSuccess extends TransferState {
  final List<AutoCompleteModel> autoCompleteList;

  AutoCompleteSuccess({required this.autoCompleteList});
}

class AutoCompleteFailure extends TransferState {
  final String errMessage;

  AutoCompleteFailure({required this.errMessage});
}

// Tag States
class StoreTagLoading extends TransferState {}

class StoreTagSuccess extends TransferState {
  final String title;
  final int id;

  StoreTagSuccess({required this.title, required this.id});
}

class StoreTagFailure extends TransferState {
  final String errMessage;

  StoreTagFailure({required this.errMessage});
}

// Image Picked State
class ImagePickedState extends TransferState {
  final File image;

  ImagePickedState({required this.image});
}

class CurrencyExchanged extends TransferState {
  final double currencyExchange;

  CurrencyExchanged({required this.currencyExchange});
}

class PartialUpdateCustomerLoading extends TransferState {}

class PartialUpdateCustomerSuccess extends TransferState {
  final String message;

  PartialUpdateCustomerSuccess({required this.message});
}

class PartialUpdateCustomerFailure extends TransferState {
  final String errMessage;

  PartialUpdateCustomerFailure({required this.errMessage});
}

class SendMoneyLoading extends TransferState {}

class SendMoneySuccess extends TransferState {
  final String message;

  SendMoneySuccess({required this.message});
}

class SendMoneyFailure extends TransferState {
  final String errMessage;

  SendMoneyFailure({required this.errMessage});
}

class UpdateImageLoading extends TransferState {}

class UpdateImageSuccess extends TransferState {}

class UpdateImageFailure extends TransferState {}

class GetTagsSuccess extends TransferState {
  final List<AutoCompleteModel> list;

  GetTagsSuccess({required this.list});
}

class GetTagsFailure extends TransferState {}

class GetTagsLoading extends TransferState {}

class AddOrSearchCustomer extends TransferState {
  final bool addSender;
  final bool addReceiver;

  AddOrSearchCustomer({this.addSender = false, this.addReceiver = false});

  AddOrSearchCustomer copyWith({
    bool? addSender,
    bool? addReceiver,
  }) {
    return AddOrSearchCustomer(
      addSender: addSender ?? this.addSender,
      addReceiver: addReceiver ?? this.addReceiver,
    );
  }
}

class UpdateStatusSuccess extends TransferState {}

class StoreCustomerTransferLoading extends TransferState {}

class StoreCustomerTransferSuccess extends TransferState {}

class StoreCustomerTransferFailure extends TransferState {}

class GetSingleTransferLoading extends TransferState {}

class GetSingleTransferSuccess extends TransferState {
  final TransferEntity transferEntity;

  GetSingleTransferSuccess({required this.transferEntity});
}

class GetSingleTransferFailure extends TransferState {
  final String errMessage;

  GetSingleTransferFailure({required this.errMessage});
}

class UpdateRateSuccess extends TransferState {
  final String message;

  UpdateRateSuccess({required this.message});
}

class UpdateRateLoading extends TransferState {}

class UpdateRateFailure extends TransferState {
  final String errMessage;

  UpdateRateFailure({required this.errMessage});
}
