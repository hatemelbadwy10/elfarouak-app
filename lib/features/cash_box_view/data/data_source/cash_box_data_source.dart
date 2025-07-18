import 'dart:developer';

import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';

import '../../domain/entity/cash_box_entity.dart';
import '../model/store_cash_box_model.dart';
import '../model/update_model.dart';

abstract class CashBoxDataSource {
  Future<List<CashBoxEntity>> getCashBox();

  Future<String> storeCashBox(StoreCashBoxModel entity);

  Future<String> updateCashBox(StoreCashBoxModel entity, int id);

  Future<String> deleteCashBox(int id);

  Future<String> updateCashBoxBalance(int id, UpdateModel updateModel);
}

class CashBoxDataSourceImpl extends CashBoxDataSource {
  final ApiService _apiService;

  CashBoxDataSourceImpl(this._apiService);

  @override
  Future<List<CashBoxEntity>> getCashBox() async {
    final result = await _apiService.get(ApiConstants.getCashBox);

    return result.fold((l) {
      log('GET cashBox failed: ${l.message}');
      throw ServerException(errorModel: l);
    }, (r) {
      final List<dynamic> dataJsonList = r.data['data'];
      return dataJsonList.map((json) => CashBoxEntity.fromJson(json)).toList();
    });
  }

  @override
  Future<String> deleteCashBox(int id) async {
    final url = '${ApiConstants.deleteCashBox}/$id';
    final result = await _apiService.delete(url);

    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<String> storeCashBox(StoreCashBoxModel entity) async {
    final result = await _apiService.post(ApiConstants.storeCashBox,
        body: entity.toJson());

    if (result.isRight()) {
      final r =
          result.getOrElse(() => throw Exception('Unexpected right failure'));
      log('right ${r.data}');
      return r.data['message'];
    } else {
      final l = result
          .swap()
          .getOrElse(() => throw Exception('Unexpected left success'));
      log('left status: ${l.status}');
      log('left message: ${l.message}');
      log('left data: ${l.data}');

      if (l.status == true && (l.message.contains('successfully'))) {
        log('[!] Treating LEFT as success based on message!');
        return l.message;
      }

      // ❌ Real failure
      throw ServerException(errorModel: l);
    }
  }

  @override
  Future<String> updateCashBox(StoreCashBoxModel entity, int id) async {
    final url = '${ApiConstants.updateCashBox}/$id';
    final result = await _apiService.put(url, body: entity.toJson());

    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<String> updateCashBoxBalance(int id, UpdateModel updateModel) async {
    final result = await _apiService.post(
        "${ApiConstants.updateCashBoxBalance}$id",
        body: updateModel.toJson());
    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }
}
