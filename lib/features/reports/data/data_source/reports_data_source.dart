import 'package:elfarouk_app/features/reports/data/model/customer_report_model.dart';

import '../../../../core/network/network_provider/api_services.dart';
import '../model/cash_box_report_model.dart';
import '../model/transfers_report_model.dart';

abstract class ReportsDataSource {
  Future<List<Activity>> getCashBoxReport(
      String startDate, String endDate, int cashBoxId);

  Future<CustomerReportModel> getCustomerReportModel(String country);

  Future<TransfersModel> getTransfersReport(int cashBoxId, String status);
}

class ReportsDataSourceImpl implements ReportsDataSource {
  final ApiService _apiService;

  ReportsDataSourceImpl(this._apiService);

  @override
  Future<List<Activity>> getCashBoxReport(
      String startDate, String endDate, int cashBoxId) async {
    final response = await _apiService.get(
      "cash-box/$cashBoxId/activity-log",
      queryParameters: {
        "start_date": startDate,
        "end_date": endDate,
      },
    );

    return response.fold(
      // if failure → throw
      (failure) => throw Exception(failure.message ?? "Failed to load reports"),
      // if success → parse activities
      (success) {
        final data = success.data["data"];
        final activitiesJson = data["activities"] as List;
        return activitiesJson.map((e) => Activity.fromJson(e)).toList();
      },
    );
  }

  @override
  @override
  Future<CustomerReportModel> getCustomerReportModel(String country) async {
    final response = await _apiService.get(
      "customer/balance-report",
      queryParameters: {
        "country": country,
      },
    );

    return response.fold(
      (failure) =>
          throw Exception(failure.message ?? "Failed to load  customer report"),
      (success) {
        final data = success.data["data"];
        return CustomerReportModel.fromJson(data);
      },
    );
  }

  @override
  Future<TransfersModel> getTransfersReport(
      int cashBoxId, String status) async {
    final response =
        await _apiService.get("transfer/reports", queryParameters: {
      "cash_box_id": cashBoxId,
      "status": status,
    });
    return response.fold(
        (failure) => throw Exception(
            failure.message ?? "Failed to load  transfers report"),
        (success) => TransfersModel.fromJson(success.data["data"]));
  }
}
