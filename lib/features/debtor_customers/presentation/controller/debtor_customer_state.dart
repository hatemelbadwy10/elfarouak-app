part of 'debtor_customer_bloc.dart';

@immutable
sealed class DebtorCustomerState {}

final class DebtorCustomerInitial extends DebtorCustomerState {}

final class DebtorCustomerLoading extends DebtorCustomerState {}

final class DebtorCustomerLoaded extends DebtorCustomerState {
  final List<DebtorCustomersEntity> debtors;

  DebtorCustomerLoaded(this.debtors);
}

final class DebtorCustomerError extends DebtorCustomerState {
  final String message;

  DebtorCustomerError(this.message);
}
