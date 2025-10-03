import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/features/reports/data/model/cash_box_report_model.dart';

import '../../../../core/network/models/api_error_model.dart';
import '../../data/model/customer_report_model.dart';
import '../../data/model/transfers_report_model.dart';

abstract class TransferReportRepo {
  Future<Either<ApiFaliureModel, List<Activity>>> getCashBoxReports(
      String startDate, String endDate, int cashBoxId);
  Future<Either<ApiFaliureModel, CustomerReportModel>> getCustomerReportModel(String country);
  Future<Either<ApiFaliureModel, TransfersModel>> getTransfersReport(int cashBoxId,String status);
}
