class CashBoxTransferEntity {
  final String fromCashBoxId, toCashBoxId;
  final String amount;
  final String? note;
  final String creator, transferCreatedAt;
  final String? currency;
  final String? convertedAmount;
  final String? status;
  final String? exchangeRate;
  final dynamic id;

  CashBoxTransferEntity({
    required this.fromCashBoxId,
    required this.toCashBoxId,
    required this.amount,
    required this.note,
    required this.transferCreatedAt,
    required this.creator,
    required this.currency,
    required this.exchangeRate,
    required this.status,
    required this.convertedAmount,
    required this.id
  });

  // Add this copyWith method
  CashBoxTransferEntity copyWith({
    String? fromCashBoxId,
    String? toCashBoxId,
    String? amount,
    String? note,
    String? creator,
    String? transferCreatedAt,
    String? currency,
    String? convertedAmount,
    String? status,
    String? exchangeRate,
    dynamic id,
  }) {
    return CashBoxTransferEntity(
      fromCashBoxId: fromCashBoxId ?? this.fromCashBoxId,
      toCashBoxId: toCashBoxId ?? this.toCashBoxId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      creator: creator ?? this.creator,
      transferCreatedAt: transferCreatedAt ?? this.transferCreatedAt,
      currency: currency ?? this.currency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      status: status ?? this.status,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      id: id ?? this.id,
    );
  }
}