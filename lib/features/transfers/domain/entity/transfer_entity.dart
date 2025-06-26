import 'dart:developer';

import '../../data/model/transfer_model.dart';

class TransfersEntity {
  final List<TransferEntity> list;
  final double transferRate;
  final dynamic totalTransfers;
  final dynamic totalAmountReceived;
  final dynamic totalBalanceEgp;
  final bool showBox;
  final List<CashBoxes>cashBoxes;

  TransfersEntity(
      {required this.list,
      required this.transferRate,
      required this.totalTransfers,
      required this.totalBalanceEgp,
      required this.totalAmountReceived,required this.showBox,
        required this.cashBoxes
      });
}

class TransferEntity {
  final int? id;
  final DateTime? date;
  final String? senderName;
  final String? amountSent;
  final String? amountReceived;
  final String? receiverName;
  final String? transferType;
  final String? transferTag;
  final String? phone;
  final String? address;
  final String? note;
  final dynamic transferSenderId;
  final dynamic receiverId;
  final dynamic tagId;
  final dynamic cashBoxId;
  final String? currencySent;
  final String? currencyReceived;
  final String? dayExchangeRate;
  final String? exchangeRateWithFee;
  final String? status;
  final String? cashBoxName;
  final String? receiptImage;
  final String? tagName;
  final String? transferCreatedAt;
  final String? sellerReceiverName;
  final String? sellerSenderName;
  final String? image;

  const TransferEntity(
      {this.id,
      this.date,
      this.senderName,
      this.amountSent,
      this.amountReceived,
      this.receiverName,
      this.transferType,
      this.transferTag,
      this.phone,
      this.address,
      this.note,
      this.transferSenderId,
      this.receiverId,
      this.tagId,
      this.cashBoxId,
      this.currencySent,
      this.currencyReceived,
      this.dayExchangeRate,
      this.exchangeRateWithFee,
      this.status,
      this.cashBoxName,
      this.receiptImage,
      this.tagName,
      this.transferCreatedAt,
      this.sellerReceiverName,
      this.sellerSenderName,
      this.image
      });

  factory TransferEntity.fromDatum(Datum datum) {
    log('datum createdAt: ${datum.createdAt}');
    log('datum tag name: ${datum.tag?.name}');
    log('datum sellerReceiver name: ${datum.sellerReceiver?.name}');
    log('datum sellerSender name: ${datum.sellerSender?.name}');

    return TransferEntity(
      id: datum.id,
      date: datum.createdAt,
      senderName: datum.sender?.name,
      amountSent: datum.amountSent,
      amountReceived: datum.amountReceived,
      receiverName: datum.receiver?.name,
      transferType: datum.transferType,
      transferTag: datum.tag?.name,
      phone: datum.receiver?.phone,
      address: datum.address,
      note: datum.note,
      transferSenderId: datum.senderId,
      receiverId: datum.receiverId,
      tagId: datum.tagId,
      cashBoxId: datum.cashBoxId,
      currencySent: datum.currencySent,
      currencyReceived: datum.currencyReceived,
      dayExchangeRate: datum.dayExchangeRate,
      exchangeRateWithFee: datum.exchangeRateWithFee,
      status: datum.status,
      cashBoxName: datum.cashBox?.name,
      receiptImage: null,
      transferCreatedAt: datum.createdAt?.toString(),
      sellerReceiverName: datum.sellerReceiver?.name, // 👈 Safe now
      sellerSenderName: datum.sellerSender?.name,     // 👈 Safe now
    );
  }
}
