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
  final String? customerReceiverPhone;
  final String? customerReceiverName;
  final String? customerReceiverCountry;
  final String? customerSenderPhone;
  final String? customerSenderName;
  final String? customerSenderCountry;

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
    this.customerReceiverCountry,
    this.customerReceiverName,
    this.customerReceiverPhone,
    this.customerSenderCountry,
    this.customerSenderName,
    this.customerSenderPhone
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'amount_sent': amountSent,
      'exchange_rate_with_fee': exchangeRateWithFee,
      'transfer_type': transferType,
      'cash_box_id': cashBoxId,
      'status': status,
      'note': note,
      'profile_picture': profilePicture,
      'tag_id': tagId,
      "customer_sender_name": customerSenderName,
      "customer_sender_phone": customerSenderPhone,
      "customer_sender_country": customerSenderCountry,
      "customer_receiver_name": customerReceiverName,
      "customer_receiver_phone": customerReceiverPhone,
      "customer_receiver_country": customerReceiverCountry,
    };

    // Remove all null or empty string values
    data.removeWhere((key, value) => value == null || (value is String && value.trim().isEmpty));

    return data;
  }
}
