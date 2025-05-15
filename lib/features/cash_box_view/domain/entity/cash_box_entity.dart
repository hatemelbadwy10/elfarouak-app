class CashBoxEntity {
  final int id;
  final String name;
  final String country;
  final double balance;
  final String note;
  final String status;

  const CashBoxEntity({
    required this.id,
    required this.name,
    required this.country,
    required this.balance,
    required this.note,
    required this.status,
  });

  factory CashBoxEntity.fromJson(Map<String, dynamic> json) {
    return CashBoxEntity(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      balance: (json['balance'] ?? 0).toDouble(),
      note: json['note'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'balance': balance,
      'note': note,
      'status': status,
    };
  }
}
