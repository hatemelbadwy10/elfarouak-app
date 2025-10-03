part of 'transfer_report_bloc.dart';

@immutable
sealed class TransferReportEvent {}

final class FetchCashBoxReports extends TransferReportEvent {
  final String startDate;
  final String endDate;
  final int cashBoxId;

  FetchCashBoxReports({
    required this.startDate,
    required this.endDate,
    required this.cashBoxId,
  });
}

final class FetchCustomerReport extends TransferReportEvent {
  final String country;

  FetchCustomerReport({required this.country});
}
final class FetchTransferReport extends TransferReportEvent {
  final int cashBoxId;
  final String status;
  FetchTransferReport({
    required this.cashBoxId,
    required this.status,
  });
}