part of 'transfer_report_bloc.dart';

@immutable
sealed class TransferReportState {}

final class TransferReportInitial extends TransferReportState {}

final class CashBoxReportLoading extends TransferReportState {}

final class CashBoxReportLoaded extends TransferReportState {
  final List<Activity> activities;

  CashBoxReportLoaded(this.activities);
}

final class CustomerReportLoaded extends TransferReportState {
  final CustomerReportModel report;

  CustomerReportLoaded(this.report);
}

final class TransferReportError extends TransferReportState {
  final String message;

  TransferReportError(this.message);
}
final class TransferReportLoading extends TransferReportState {}

final class TransferReportSuccess extends TransferReportState {
  final TransfersModel transfersModel;

  TransferReportSuccess(this.transfersModel);
}