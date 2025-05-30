import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/debtor_customers/domain/entity/debtor_customers_entity.dart';

import '../../../../core/network/exception/server_exception.dart';
import '../model/debtor_customers.dart';

abstract class DebtorCustomersDataSource {
  Future<List<DebtorCustomersEntity>> getDebtors();
}

class DebtorCustomersDataSourceImpl extends DebtorCustomersDataSource {
  final ApiService _apiService;

  DebtorCustomersDataSourceImpl(this._apiService);

  @override
  Future<List<DebtorCustomersEntity>> getDebtors() async {
    final result = await _apiService.get(ApiConstants.getDebtor);

    return result.fold(
          (error) => throw ServerException(errorModel: error),
          (response) {
        final List<dynamic> data = response.data['data']['data'];
        return data.map((item) => Datum.fromJson(item)).toList();
      },
    );
  }
}
