class ExpenseEntity {
  final int? expenseId;
  final String expanseBranch;
  final String expanseAmount;
  final String expanseDescription;
  final String expanseTag;

  ExpenseEntity({
     this.expenseId,
    required this.expanseBranch,
    required this.expanseAmount,
    required this.expanseDescription,
    required this.expanseTag,
  });

  Map<String, dynamic> toJson() {
    return {
      'expanseBranch': expanseBranch,
      'expanseAmount': expanseAmount,
      'expanseDescription': expanseDescription,
      'expanseTag': expanseTag,
    };
  }
}
