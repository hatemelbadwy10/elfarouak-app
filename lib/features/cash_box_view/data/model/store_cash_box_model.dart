import '../../domain/entity/cash_box_entity.dart';

class StoreCashBoxModel {
  final String name;
  final String country;
  final double balance;
  final String note;
  final String status;

  StoreCashBoxModel({
    required this.name,
    required this.country,
    required this.balance,
    required this.note,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'balance': balance,
      'note': note,
      'status': status,
    };
  }

  factory StoreCashBoxModel.fromEntity(CashBoxEntity entity) {
    return StoreCashBoxModel(
      name: entity.name,
      country: entity.country,
      balance: entity.balance,
      note: entity.note,
      status: entity.status,
    );
  }
}
