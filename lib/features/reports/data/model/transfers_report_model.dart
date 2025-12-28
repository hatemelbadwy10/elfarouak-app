class TransfersModel {
  TransfersModel({
    required this.transfers,
    required this.summary,
    required this.rows,
    required this.filters,
  });

  final List<Transfer> transfers;
  final Summary? summary;
  final List<Row> rows;
  final Filters? filters;

  factory TransfersModel.fromJson(Map<String, dynamic> json){
    return TransfersModel(
      transfers: json["transfers"] == null ? [] : List<Transfer>.from(json["transfers"]!.map((x) => Transfer.fromJson(x))),
      summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
      rows: json["rows"] == null ? [] : List<Row>.from(json["rows"]!.map((x) => Row.fromJson(x))),
      filters: json["filters"] == null ? null : Filters.fromJson(json["filters"]),
    );
  }

}

class Filters {
  Filters({
    required this.cashBoxId,
    required this.status,
    required this.dateRange,
  });

  final int? cashBoxId;
  final String? status;
  final dynamic dateRange;

  factory Filters.fromJson(Map<String, dynamic> json){
    return Filters(
      cashBoxId: json["cash_box_id"],
      status: json["status"],
      dateRange: json["date_range"],
    );
  }

}

class Row {
  Row({
    required this.id,
    required this.customer,
    required this.amount,
    required this.buyRate,
    required this.total,
    required this.exchangeRate,
    required this.profit,
  });

  final int? id;
  final String? customer;
  final dynamic amount;
  final dynamic buyRate;
  final dynamic total;
  final dynamic exchangeRate;
  final dynamic profit;

  factory Row.fromJson(Map<String, dynamic> json){
    return Row(
      id: json["id"],
      customer: json["customer"],
      amount: json["amount"],
      buyRate: json["buy_rate"],
      total: json["total"],
      exchangeRate: json["exchange_rate"],
      profit: json["profit"],
    );
  }
}


class Summary {
  Summary({
    required this.totalTransfers,
    required this.totalAmount,
    required this.totalProfit,
  });

  final dynamic? totalTransfers;
  final dynamic  totalAmount;
  final dynamic totalProfit;

  factory Summary.fromJson(Map<String, dynamic> json){
    return Summary(
      totalTransfers: json["total_transfers"],
      totalAmount: json["total_amount"],
      totalProfit: json["total_profit"],
    );
  }

}

class Transfer {
  Transfer({
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
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? senderId;
  final Receiver? sender;
  final int? receiverId;
  final Receiver? receiver;
  final String? amountSent;
  final String? currencySent;
  final String? amountReceived;
  final String? currencyReceived;
  final String? dayExchangeRate;
  final String? exchangeRateWithFee;
  final String? transferType;
  final int? cashBoxId;
  final CashBox? cashBox;
  final String? status;
  final String? note;
  final int? sellerReceiverId;
  final CashBox? sellerReceiver;
  final int? sellerSenderId;
  final CashBox? sellerSender;
  final int? tagId;
  final Tag? tag;
  final dynamic image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Transfer.fromJson(Map<String, dynamic> json){
    return Transfer(
      id: json["id"],
      senderId: json["sender_id"],
      sender: json["sender"] == null ? null : Receiver.fromJson(json["sender"]),
      receiverId: json["receiver_id"],
      receiver: json["receiver"] == null ? null : Receiver.fromJson(json["receiver"]),
      amountSent: json["amount_sent"],
      currencySent: json["currency_sent"],
      amountReceived: json["amount_received"],
      currencyReceived: json["currency_received"],
      dayExchangeRate: json["day_exchange_rate"],
      exchangeRateWithFee: json["exchange_rate_with_fee"],
      transferType: json["transfer_type"],
      cashBoxId: json["cash_box_id"],
      cashBox: json["cash_box"] == null ? null : CashBox.fromJson(json["cash_box"]),
      status: json["status"],
      note: json["note"],
      sellerReceiverId: json["seller_receiver_id"],
      sellerReceiver: json["seller_receiver"] == null ? null : CashBox.fromJson(json["seller_receiver"]),
      sellerSenderId: json["seller_sender_id"],
      sellerSender: json["seller_sender"] == null ? null : CashBox.fromJson(json["seller_sender"]),
      tagId: json["tag_id"],
      tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
      image: json["image"],
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

  final int? id;
  final String? name;

  factory CashBox.fromJson(Map<String, dynamic> json){
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

  final int? id;
  final String? name;
  final String? phone;

  factory Receiver.fromJson(Map<String, dynamic> json){
    return Receiver(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
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

  factory Tag.fromJson(Map<String, dynamic> json){
    return Tag(
      id: json["id"],
      name: json["name"],
      color: json["color"],
    );
  }

}
