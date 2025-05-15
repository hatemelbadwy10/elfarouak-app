import '../../domain/entity/transfer_entity.dart';

class TransferModel {
  TransferModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final List<Datum> data;

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum extends TransferEntity {
  final int? id;
  final dynamic senderId;
  final Sender sender;
  final dynamic receiverId;
  final Receiver receiver;
  final String? currencySent;
  final String? currencyReceived;
  final String? dayExchangeRate;
  final String? exchangeRateWithFee;
  final dynamic cashBoxId;
  final CashBox? cashBox;
  final String? status;
  final dynamic sellerReceiverId;
  final dynamic sellerReceiver;
  final dynamic sellerSenderId;
  final dynamic sellerSender;
  final dynamic tagId;
  final Tag tag;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    required this.id,
    required this.senderId,
    required this.sender,
    required this.receiverId,
    required this.receiver,
    required String? amountSent,
    required this.currencySent,
    required String? amountReceived,
    required this.currencyReceived,
    required this.dayExchangeRate,
    required this.exchangeRateWithFee,
    required String? transferType,
    required this.cashBoxId,
    required this.cashBox,
    required this.status,
    required String? note,
    required this.sellerReceiverId,
    required this.sellerReceiver,
    required this.sellerSenderId,
    required this.sellerSender,
    required this.tagId,
    required this.tag,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  })  : createdAt = createdAt,
        updatedAt = updatedAt,
        super(
          date: createdAt,
          senderName: sender.name,
          amountSent: amountSent,
          amountReceived: amountReceived,
          receiverName: receiver.name,
          transferType: transferType,
          transferTag: tag.name,
          phone: sender.phone,
          address: '',
          note: note,
        cashBoxId: cashBoxId,
        cashBoxName: cashBox?.name??"",
        currencySent: currencySent,
        currencyReceived: currencyReceived,
        receiverId: receiverId,
        transferSenderId: senderId,
        dayExchangeRate: dayExchangeRate,
        exchangeRateWithFee: exchangeRateWithFee,
        status: status,

        );

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      senderId: json["sender_id"],
      sender: Sender.fromJson(json["sender"]),
      receiverId: json["receiver_id"],
      receiver: Receiver.fromJson(json["receiver"]??{}),
      amountSent: json["amount_sent"],
      currencySent: json["currency_sent"],
      amountReceived: json["amount_received"],
      currencyReceived: json["currency_received"],
      dayExchangeRate: json["day_exchange_rate"],
      exchangeRateWithFee: json["exchange_rate_with_fee"],
      transferType: json["transfer_type"],
      cashBoxId: json["cash_box_id"],
      cashBox:
          json["cash_box"] == null ? null : CashBox.fromJson(json["cash_box"]),
      status: json["status"],
      note: json["note"],
      sellerReceiverId: json["seller_receiver_id"],
      sellerReceiver: json["seller_receiver"],
      sellerSenderId: json["seller_sender_id"],
      sellerSender: json["seller_sender"],
      tagId: json["tag_id"],
      tag: Tag.fromJson(json["tag"]),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}

class CashBox {
  CashBox({
    required this.id,
    required this.name,
  });

  final dynamic id;
  final String? name;

  factory CashBox.fromJson(Map<String, dynamic> json) {
    return CashBox(
      id: json["id"],
      name: json["name"],
    );
  }
}
class Tag {
  Tag({
    required this.id,
    required this.name,
  });

  final dynamic id;
  final String? name;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      name: json["name"],
    );
  }
}
class Sender{
  final String id ;
  final String name;
  final String phone;

  Sender({required this.id, required this.name, required this.phone});
  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json["id"],
      name: json["name"],
      phone: json['phone']
    );
  }
}
class Receiver{
  final String id ;
  final String name;
  final String phone;

  Receiver({required this.id, required this.name, required this.phone});
  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json["id"]??'',
      name: json["name"]??"",
      phone: json['phone']??""
    );
  }
}