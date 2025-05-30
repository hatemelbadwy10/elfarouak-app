class CashBoxTransferEntity{
  final String fromCashBoxId,toCashBoxId;
  final String amount;
  final String? note;
  final String creator,transferCreatedAt;

  CashBoxTransferEntity({required this.fromCashBoxId, required this.toCashBoxId, required this.amount, required this.note,required this.transferCreatedAt,required this.creator});
}