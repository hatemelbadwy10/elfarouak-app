import 'dart:developer';

import '../../domain/entity/transfer_entity.dart';

class TransferModel {
  TransferModel({
    required this.message,
    required this.status,
    required this.data,
  });

  final String? message;
  final bool? status;
  final Data? data;

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      message: json["message"],
      status: json["status"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}

class Data extends TransfersEntity {
  Data({required this.transfers,
    required this.rate,
    required this.totalAmountReceived,
    required this.totalBalanceEgp,
    required this.totalTransfers,
    required this.showBox
  })
      : super(
      list: transfers?.data ?? [],
      transferRate: rate ?? 0,
      totalTransfers: totalTransfers,
      totalAmountReceived: totalAmountReceived,
      totalBalanceEgp: totalBalanceEgp,showBox: showBox);

  final Transfers? transfers;
  final double? rate;
  final dynamic totalTransfers;
  final dynamic totalAmountReceived;
  final dynamic totalBalanceEgp;
  final bool showBox;

  factory Data.fromJson(Map<String, dynamic> json) {
    log('json["total_transfers"]${json['total_transfers']}');
    log('json["total_transfers"]${ json['total_balance_egp']}');
    return Data(
      transfers: json["transfers"] == null
          ? null
          : Transfers.fromJson(json["transfers"]),
      rate: json["rate"],
      totalAmountReceived: double.parse(
          json['total_amount_received'].toString()),
      totalBalanceEgp: json['total_balance_egp'],
      totalTransfers: json['total_transfers'],
      showBox: json['show_box']??false
    );
  }
}

class Transfers {
  Transfers({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  final int? currentPage;
  final List<Datum> data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory Transfers.fromJson(Map<String, dynamic> json) {
    return Transfers(
      currentPage: json["current_page"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: json["first_page_url"],
      from: json["from"],
      lastPage: json["last_page"],
      lastPageUrl: json["last_page_url"],
      links: json["links"] == null
          ? []
          : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
      nextPageUrl: json["next_page_url"],
      path: json["path"],
      perPage: json["per_page"],
      prevPageUrl: json["prev_page_url"],
      to: json["to"],
      total: json["total"],
    );
  }
}

class Datum extends TransferEntity {
  Datum({
    required this.id,
    required this.senderId,
    required this.sender,
    required this.receiverId,
    required this.receiver,
    required this.amountSent,
    required this.currencySent,
    required this.amountReceived,
    required this.currencyReceived,
    required this.dayExchangeRate,
    required this.exchangeRateWithFee,
    required this.transferType,
    required this.cashBoxId,
    required this.cashBox,
    required this.status,
    required this.note,
    required this.sellerReceiverId,
    required this.sellerReceiver,
    required this.sellerSenderId,
    required this.sellerSender,
    required this.tagId,
    required this.tag,
    required this.createdAt,
    required this.updatedAt,
    this.image
  }) : super(senderName: sender?.name ?? '',
      receiverName: receiver?.name,
      sellerSenderName: sellerSender?.name,
      sellerReceiverName: sellerReceiver.name,
      tagName: tag?.name,
      transferCreatedAt: createdAt.toString(),
      status: status,
      amountSent:amountSent,
      amountReceived:amountReceived,
    note: note,
    exchangeRateWithFee: exchangeRateWithFee,
    dayExchangeRate: dayExchangeRate,
    phone: receiver?.phone,
    image: image


      );

  final int? id;
  final String? senderId;
  final Receiver? sender;
  final String? receiverId;
  final Receiver? receiver;
  final String? amountSent;
  final String? currencySent;
  final String? amountReceived;
  final String? currencyReceived;
  final String? dayExchangeRate;
  final String? exchangeRateWithFee;
  final String? transferType;
  final String? cashBoxId;
  final CashBox? cashBox;
  final String? status;
  final String? note;
  final dynamic sellerReceiverId;
  final CashBox sellerReceiver;
  final String? sellerSenderId;
  final CashBox? sellerSender;
  final String? tagId;
  final Tag? tag;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? image;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      senderId: json["sender_id"],
      sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
      receiverId: json["receiver_id"],
      receiver:
      json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
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
      image:json['image'],
      note: json["note"],
      sellerReceiverId: json["seller_receiver_id"],
      sellerReceiver: CashBox.fromJson(json["seller_receiver"]),
      sellerSenderId: json["seller_sender_id"],
      sellerSender: json["seller_sender"] == null
          ? null
          : CashBox.fromJson(json["seller_sender"]),
      tagId: json["tag_id"],
      tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
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

  final String? id;
  final String? name;

  factory CashBox.fromJson(Map<String, dynamic> json) {
    return CashBox(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Receiver {
  Receiver({
    required this.id,
    required this.name,
    required this.phone,
  });

  final String? id;
  final String? name;
  final String? phone;

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
    );
  }
}

class SellerReceiver {
  final int id;
  final String name;

  SellerReceiver({required this.id, required this.name});

  factory SellerReceiver.fromJson(Map<String, dynamic> json) {
    return SellerReceiver(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Tag {
  Tag({
    required this.id,
    required this.name,
    required this.color,
  });

  final int? id;
  final String? name;
  final dynamic color;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["id"],
      name: json["name"],
      color: json["color"],
    );
  }
}

class Link {
  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  final String? url;
  final String? label;
  final bool? active;

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json["url"],
      label: json["label"],
      active: json["active"],
    );
  }
}
