part of 'debtor_customer_bloc.dart';

@immutable
sealed class DebtorCustomerEvent {}

final class GetDebtorsEvent extends DebtorCustomerEvent {}
