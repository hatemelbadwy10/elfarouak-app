class CustomersTransferModel{
  final int senderId,receiverId;
  final double amount;

  CustomersTransferModel({required this.senderId, required this.receiverId, required this.amount});
  Map<String,dynamic>toJson(){
    return {
       'sender_id': senderId,
      'receiver_id': receiverId,
      'amount': amount
    };
  }
}