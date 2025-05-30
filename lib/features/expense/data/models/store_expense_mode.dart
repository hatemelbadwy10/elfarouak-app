class StoreExpenseModel{
  final int tagId,branchId;
  final double amount;
  final String description;

  StoreExpenseModel({required this.tagId, required this.branchId, required this.amount, required this.description});
Map<String,dynamic>toJson(){
  return {
    "cash_box_id":branchId,
    "tag_id":tagId,
    "amount":amount,
    "description":description
  };

}
}