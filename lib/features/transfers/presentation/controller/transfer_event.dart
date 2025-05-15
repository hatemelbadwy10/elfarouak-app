part of 'transfer_bloc.dart';

@immutable
sealed class TransferEvent {}

class GetTransfersEvent extends TransferEvent {
  final String? search;
  final String? status;
  final String? transferType;
  final int? tagId;
  final String? dateRange;

  GetTransfersEvent({
    this.search,
    this.status,
    this.transferType,
    this.tagId,
    this.dateRange,
  });
}
class StoreTransferEvent extends TransferEvent {
  final int senderId;
  final int receiverId;
  final String amountSent;
  final String currencySent;
  final String amountReceived;
  final String currencyReceived;
  final String dayExchangeRate;
  final String exchangeRateWithFee;
  final String transferType;
  final int? cashBoxId;
  final String status;
  final String note;
  final int tagId;
  final File? image;

  StoreTransferEvent({
    required this.senderId,
    required this.receiverId,
    required this.amountSent,
    required this.currencySent,
    required this.amountReceived,
    required this.currencyReceived,
    required this.dayExchangeRate,
    required this.exchangeRateWithFee,
    required this.transferType,
     this.cashBoxId,
    required this.status,
    required this.note,
    required this.tagId,
    this.image
  });
}

class DeleteTransferEvent extends TransferEvent {
  final int id;

  DeleteTransferEvent({required this.id});
}

class UpdateTransferEvent extends TransferEvent {
  final int senderId;
  final int receiverId;
  final String amountSent;
  final String currencySent;
  final String amountReceived;
  final String currencyReceived;
  final String dayExchangeRate;
  final String exchangeRateWithFee;
  final String transferType;
  final int cashBoxId;
  final String status;
  final String note;
  final int tagId;
  final int id;

  UpdateTransferEvent({
    required this.senderId,
    required this.receiverId,
    required this.amountSent,
    required this.currencySent,
    required this.amountReceived,
    required this.currencyReceived,
    required this.dayExchangeRate,
    required this.exchangeRateWithFee,
    required this.transferType,
    required this.cashBoxId,
    required this.status,
    required this.note,
    required this.tagId,
    required this.id,
  });
}
class FetchAutoCompleteEvent extends TransferEvent {
  final String listType;
  final String searchText;

  FetchAutoCompleteEvent({
    required this.listType,
    required this.searchText,
  });
}
class StoreTagEvent extends TransferEvent{
  final String tag;

  StoreTagEvent({required this.tag});
}