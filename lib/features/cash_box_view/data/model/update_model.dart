class UpdateModel {
  final double amount;
  final String operation;
  final String reason;

  UpdateModel(
      {required this.amount, required this.operation, required this.reason});

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'amount': amount,
      'notes': reason,
    };
  }
}
