import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/reports/data/model/customer_report_model.dart';
import 'package:elfarouk_app/features/reports/data/model/cash_box_report_model.dart';
import 'package:elfarouk_app/features/reports/data/model/transfers_report_model.dart';
import '../../../../core/network/exception/server_exception.dart';
import '../../domain/repo/transfer_report_repo.dart';
import '../data_source/reports_data_source.dart';

class TransferReportRepoImpl implements TransferReportRepo {
  final ReportsDataSource _transferReportDataSource;

  TransferReportRepoImpl(this._transferReportDataSource);

  @override
  Future<Either<ApiFaliureModel, List<Activity>>> getCashBoxReports(
      String startDate, String endDate, int cashBoxId) async {
    try {
      final result = await _transferReportDataSource.getCashBoxReport(
        startDate,
        endDate,
        cashBoxId,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, CustomerReportModel>> getCustomerReportModel(
      String country) async {
    try {
      final result =
          await _transferReportDataSource.getCustomerReportModel(country);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, TransfersModel>> getTransfersReport(
      int cashBoxId, String status) async {
    try {
      final result =
          await _transferReportDataSource.getTransfersReport(cashBoxId, status);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
}
