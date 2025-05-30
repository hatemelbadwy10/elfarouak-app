part of 'transfer_bloc.dart';

@immutable
sealed class TransferEvent {}

class GetTransfersEvent extends TransferEvent {
  final String? search;
  final String? status;
  final String? transferType;
  final int? tagId;
  final String? dateRange;
  final bool isLoadMore;
  final int page;
  final bool? isHome;

  GetTransfersEvent({
    this.search,
    this.status,
    this.transferType,
    this.tagId,
    this.dateRange,
    this.isLoadMore = false,
    this.page = 1,
    this.isHome
  });
}
class LoadMoreTransfersEvent extends TransferEvent {
  final String? search;
  final String? status;
  final String? transferType;
  final int? tagId;
  final String? dateRange;


  LoadMoreTransfersEvent({
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
  final String transferType;
  final int? cashBoxId;
  final String note;
  final int tagId;
  final String exchangeRateWithFee;


  StoreTransferEvent({
    required this.senderId,
    required this.receiverId,
    required this.amountSent,

    required this.transferType,
     this.cashBoxId,
    required this.note,
    required this.tagId,
    required this.exchangeRateWithFee
  });
}

class DeleteTransferEvent extends TransferEvent {
  final int id;

  DeleteTransferEvent({required this.id});
}

class UpdateTransferEvent extends TransferEvent {
  final int? senderId;
  final int? receiverId;
  final String? amountSent;
  final String? transferType;
  final int? cashBoxId;
  final String? note;
  final int? tagId;
  final int id;
  final String? exchangeRateWithFee;
  final String? status;
  final File? image;

  UpdateTransferEvent({
     this.senderId,
     this.receiverId,
     this.amountSent,
     this.transferType,
     this.cashBoxId,
     this.note,
     this.tagId,
    required this.id,
     this.exchangeRateWithFee,
    this.status,
    this.image
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
  final String type;

  StoreTagEvent({required this.tag,required this.type});
}
class ImagePickedEvent extends TransferEvent {
  final File image;

  ImagePickedEvent({required this.image});
}
class ConvertCurrency extends TransferEvent{
  final int branchId;
  final double exchangeFee,amount;
  ConvertCurrency({required this.amount,required this.exchangeFee,required this.branchId});
}
class PartialUpdateCustomerEvent extends TransferEvent {
  final int customerId;
  final double? balance;
  final String? transferType;
  final String? type;

  PartialUpdateCustomerEvent({
    required this.customerId,
    this.balance,
    this.transferType,
    this.type,
  });
}

class SendMoneyEvent extends TransferEvent {
  final int fromCashBoxId;
  final int toCashBoxId;
  final double amount;
  final String? note;

  SendMoneyEvent({
    required this.fromCashBoxId,
    required this.toCashBoxId,
    required this.amount,
    this.note,
  });
}
class UpdateImage extends TransferEvent{
  final File image;
  final int id;

  UpdateImage({required this.image, required this.id});
}
class GetTagsEvent extends TransferEvent{
  final String type;

  GetTagsEvent({required this.type});

}
class UpdateStatus extends TransferEvent{
  final String status;
  final int id;

  UpdateStatus({required this.status, required this.id});
}