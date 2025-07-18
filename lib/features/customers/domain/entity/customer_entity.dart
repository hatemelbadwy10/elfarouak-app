class CustomerEntity {
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
 // final String customerGender;
  final String customerNote;
  final String customerBalance;
  final String? customerCountry;
  final String customerProfilePicture;


  const CustomerEntity({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
   // required this.customerGender,
    required this.customerNote,
    required this.customerBalance,
     this.customerCountry,
    required this.customerProfilePicture,
  });

  factory CustomerEntity.fromJson(Map<String, dynamic> json) {
    return CustomerEntity(
      customerId: json['id'],
      customerName: json['name'],
      customerPhone: json['phone'],
      customerAddress: json['address']??"لا يوجد عنوان",
      //customerGender: json['gender'],
      customerNote: json['note']??"لا يوجد ملاحظات",
      customerBalance: json['balance'],
      customerCountry: json['country'],
      customerProfilePicture: json['profile_picture']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': customerId,
      'name': customerName,
      'phone': customerPhone,
      'address': customerAddress,
     // 'gender': customerGender,
      'note': customerNote,
      'balance': customerBalance,
      'country': customerCountry,
      'profile_picture': customerProfilePicture,

    };
  }
}
