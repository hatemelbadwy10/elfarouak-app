import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/customers/data/model/store_customer_model.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

import '../../../../core/network/exception/server_exception.dart';
import '../model/customer_partial_update_model.dart';

abstract class CustomerDataSource {
  Future<List<CustomerEntity>> getCustomers({int page});

  Future<String> storeCustomer(StoreCustomerModel storeCustomerModel);

  Future<String> updateCustomer(StoreCustomerModel storeCustomerModel, int id);

  Future<String> deleteCustomer(int id);
  Future<CustomerPartialUpadteModel> getCustomerActivities(
      {required int customerId, int page = 1});
  Future<String> undoActivity({required int activityId});
}

class CustomerDataSourceImpl extends CustomerDataSource {
  final ApiService _apiService;

  CustomerDataSourceImpl(this._apiService);

  @override
  Future<List<CustomerEntity>> getCustomers({int page = 1}) async {
    final result = await _apiService.get('${ApiConstants.customers}$page');
    return result.fold((l) {
      log('l ${l.data}');
      throw ServerException(errorModel: l);
    }, (r) {
      log('r.data ${r.data['data']['data']}');
      final List<dynamic> dataJsonList = r.data['data']['data']['data'];
      final customers =
          dataJsonList.map((json) => CustomerEntity.fromJson(json)).toList();
      return customers;
    });
  }

  @override
  Future<String> deleteCustomer(int id) async {
    final url = '${ApiConstants.deleteCustomer}/$id';
    final response = await _apiService.delete(url);
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<String> storeCustomer(StoreCustomerModel storeCustomerModel) async {
    final formData = FormData.fromMap(storeCustomerModel.toJson());

    final response = await _apiService.post(
      ApiConstants.storeCustomer,
      body: formData,
    );

    log("storeCustomerModel.toJson(): ${storeCustomerModel.toJson()}");
    log('response: $response');

    if (response.isRight()) {
      final r =
          response.getOrElse(() => throw Exception('Unexpected right failure'));
      log('right ${r.data}');
      return r.data['message'];
    } else {
      final l = response
          .swap()
          .getOrElse(() => throw Exception('Unexpected left success'));
      log('left status: ${l.status}');
      log('left message: ${l.message}');
      log('left data: ${l.data}');

      if (l.status == true && (l.message.contains('successfully') ?? false)) {
        log('[!] Treating LEFT as success based on message!');
        return l.message ?? 'Customer created';
      }

      throw ServerException(errorModel: l);
    }
  }

  @override
  Future<String> updateCustomer(
      StoreCustomerModel storeCustomerModel, int id) async {
    final url = '${ApiConstants.updateCustomer}/$id';

    final response =
        await _apiService.put(url, body: storeCustomerModel.toJson());
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<CustomerPartialUpadteModel> getCustomerActivities({
    required int customerId,
    int page = 1,
    int perPage = 20,
  }) async {
    final url =
        '${ApiConstants.customerActivities}?customer_id=$customerId&page=$page&per_page=$perPage';

    final result = await _apiService.get(url);

    return result.fold(
          (l) {
        log('Error fetching activities: ${l.data}');
        throw ServerException(errorModel: l);
      },
          (r) {
        return CustomerPartialUpadteModel.fromJson(r.data);
      },
    );
  }


  @override
  Future<String> undoActivity({required int activityId}) async {
    final url = '${ApiConstants.undoActivity}/$activityId/undo';
    final result = await _apiService.post(url);

    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'] ?? 'Activity undone successfully';
    });
  }
}
