part of 'customers_bloc.dart';

@immutable
sealed class CustomersEvent {}

class GetCustomersEvent extends CustomersEvent {}

class StoreCustomerEvent extends CustomersEvent {
  final String name;
  final String phone;
  final String address;
  final String gender;
  final String country;
  final String balance;
  final String status;
  final String note;

  StoreCustomerEvent({
    required this.name,
    required this.phone,
    required this.address,
    required this.gender,
    required this.country,
    required this.balance,
    required this.status,
    required this.note,
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
  });
}

class DeleteCustomerEvent extends CustomersEvent {
  final int id;

  DeleteCustomerEvent({required this.id});
}
