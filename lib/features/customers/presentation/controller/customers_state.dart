part of 'customers_bloc.dart';

@immutable
sealed class CustomersState {}

final class CustomersInitial extends CustomersState {}

final class CustomerLoading extends CustomersState {}

final class CustomerSuccess extends CustomersState {
  final List<CustomerEntity> list;
  final int currentPage;

  CustomerSuccess({required this.list, this.currentPage = 1});
}


final class CustomerFailure extends CustomersState {
  final String errMessage;

  CustomerFailure({required this.errMessage});
}

final class StoreCustomerLoading extends CustomersState {}

final class StoreCustomerSuccess extends CustomersState {
  final String message;

  StoreCustomerSuccess({required this.message});
}

final class StoreCustomerFailure extends CustomersState {
  final String errMessage;

  StoreCustomerFailure({required this.errMessage});
}

final class UpdateCustomerLoading extends CustomersState {}

final class UpdateCustomerSuccess extends CustomersState {
  final String message;

  UpdateCustomerSuccess({required this.message});
}

final class UpdateCustomerFailure extends CustomersState {
  final String errMessage;

  UpdateCustomerFailure({required this.errMessage});
}

final class DeleteCustomerLoading extends CustomersState {}

final class DeleteCustomerSuccess extends CustomersState {
  final String message;

  DeleteCustomerSuccess({required this.message});
}

final class DeleteCustomerFailure extends CustomersState {
  final String errMessage;

  DeleteCustomerFailure({required this.errMessage});
}
