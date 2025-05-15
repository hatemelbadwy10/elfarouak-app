import 'dart:io';

class StoreTransferModel {
  final int? senderId;
  final int? receiverId;
  final String? amountSent;
  final String? currencySent;
  final String? amountReceived;
  final String? currencyReceived;
  final String? dayExchangeRate;
  final String? exchangeRateWithFee;
  final String? transferType;
  final int? cashBoxId;
  final String? status;
  final String? note;
  final File? profilePicture;
  final int? tagId;

  StoreTransferModel({
    this.senderId,
    this.receiverId,
    this.amountSent,
    this.currencySent,
    this.amountReceived,
    this.currencyReceived,
    this.dayExchangeRate,
    this.exchangeRateWithFee,
    this.transferType,
    this.cashBoxId,
    this.status,
    this.note,
    this.profilePicture,
    this.tagId,
  });

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'amount_sent': amountSent,
      'currency_sent': currencySent,
      'amount_received': amountReceived,
      'currency_received': currencyReceived,
      'day_exchange_rate': dayExchangeRate,
      'exchange_rate_with_fee': exchangeRateWithFee,
      'transfer_type': transferType,
      'cash_box_id': cashBoxId,
      'status': status,
      'note': note,
      'profile_picture': profilePicture,
      'tag_id': tagId,
    };
  }
}
