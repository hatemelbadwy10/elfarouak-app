part of 'customers_bloc.dart';

@immutable
sealed class CustomersEvent {}

class GetCustomersEvent extends CustomersEvent {
  final int page;
  GetCustomersEvent({this.page = 1});
}

class StoreCustomerEvent extends CustomersEvent {
  final String name;
  final String phone;
  final String address;
  final String gender;
  final String country;
  final String balance;
  final String status;
  final String note;
  final File? profilePic;

  StoreCustomerEvent({
    required this.name,
    required this.phone,
    required this.address,
    required this.gender,
    required this.country,
    required this.balance,
    required this.status,
    required this.note,
     this.profilePic
  });
}

class UpdateCustomerEvent extends CustomersEvent {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String gender;
  final String country;
  final String balance;
  final String status;
  final String note;
  final File? profilePic;


  UpdateCustomerEvent({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.gender,
    required this.country,
    required this.balance,
    required this.status,
    required this.note,
     this.profilePic
  });
}

class DeleteCustomerEvent extends CustomersEvent {
  final int id;

  DeleteCustomerEvent({required this.id});
}
