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

  const TransferEntity({
    this.id,
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
  });

// Factory constructor can be implemented later for converting from API response
// factory TransferEntity.fromDatum(Datum datum) {
//   return TransferEntity(
//     id: datum.id,
//     date: datum.createdAt,
//     senderName: datum.sender?['name'],
//     amountSent: datum.amountSent,
//     amountReceived: datum.amountReceived,
//     receiverName: datum.receiver?['name'],
//     transferType: datum.transferType,
//     transferTag: datum.tag?['name'],
//     phone: datum.receiver?['phone'],
//     address: datum.receiver?['address'],
//     note: datum.note,
//     senderId: datum.senderId,
//     receiverId: datum.receiverId,
//     tagId: datum.tagId,
//     cashBoxId: datum.cashBoxId,
//     currencySent: datum.currencySent,
//     currencyReceived: datum.currencyReceived,
//     dayExchangeRate: datum.dayExchangeRate,
//     exchangeRateWithFee: datum.exchangeRateWithFee,
//     status: datum.status,
//     cashBoxName: datum.cashBox?['name'],
//     receiptImage: datum.receiptImage,
//   );
// }
}