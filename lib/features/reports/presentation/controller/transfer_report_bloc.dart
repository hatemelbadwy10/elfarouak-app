import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/features/reports/data/model/transfers_report_model.dart';
import 'package:meta/meta.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/reports/data/model/cash_box_report_model.dart';
import 'package:elfarouk_app/features/reports/data/model/customer_report_model.dart';
import 'package:elfarouk_app/features/reports/domain/repo/transfer_report_repo.dart';

part 'transfer_report_event.dart';

part 'transfer_report_state.dart';

class TransferReportBloc
    extends Bloc<TransferReportEvent, TransferReportState> {
  final TransferReportRepo _repo;

  TransferReportBloc(this._repo) : super(TransferReportInitial()) {
    on<FetchCashBoxReports>(_onFetchCashBoxReports);
    on<FetchCustomerReport>(_onFetchCustomerReport);
    on<FetchTransferReport>(_onFetchTransferReport);
  }

  Future<void> _onFetchCashBoxReports(
      FetchCashBoxReports event, Emitter<TransferReportState> emit) async {
    emit(CashBoxReportLoading());

    final Either<ApiFaliureModel, List<Activity>> result =
        await _repo.getCashBoxReports(
      event.startDate,
      event.endDate,
      event.cashBoxId,
    );

    result.fold(
      (failure) =>
          emit(TransferReportError(failure.message ?? "Unknown error")),
      (activities) => emit(CashBoxReportLoaded(activities)),
    );
  }

  Future<void> _onFetchCustomerReport(
      FetchCustomerReport event, Emitter<TransferReportState> emit) async {
    emit(CashBoxReportLoading());

    final Either<ApiFaliureModel, CustomerReportModel> result =
        await _repo.getCustomerReportModel(event.country);

    result.fold(
      (failure) =>
          emit(TransferReportError(failure.message ?? "Unknown error")),
      (report) => emit(CustomerReportLoaded(report)),
    );
  }

  Future<void> _onFetchTransferReport(
      FetchTransferReport event, Emitter<TransferReportState> emit) async {
    emit(TransferReportLoading());
    final Either<ApiFaliureModel, TransfersModel> result =
        await _repo.getTransfersReport(event.cashBoxId, event.status);

    result.fold(
      (failure) =>
          emit(TransferReportError(failure.message ?? "Unknown error")),
      (report) => emit(TransferReportSuccess(report)),
    );
  }
}
