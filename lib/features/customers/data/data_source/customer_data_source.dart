import 'dart:developer';

import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/customers/data/model/store_customer_model.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

import '../../../../core/network/exception/server_exception.dart';

abstract class CustomerDataSource {
  Future<List<CustomerEntity>> getCustomers();

  Future<String> storeCustomer(StoreCustomerModel storeCustomerModel);

  Future<String> updateCustomer(StoreCustomerModel storeCustomerModel, int id);

  Future<String> deleteCustomer(int id);
}

class CustomerDataSourceImpl extends CustomerDataSource {
  final ApiService _apiService;

  CustomerDataSourceImpl(this._apiService);

  @override
  Future<List<CustomerEntity>> getCustomers() async {
    final result = await _apiService.get(ApiConstants.customers);
    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      log('r.data ${r.data['data']['data']}');
      final List<dynamic> dataJsonList = r.data['data']['data'];
      final customers =
          dataJsonList.map((json) => CustomerEntity.fromJson(json)).toList();
      return customers;
    });
  }

  @override
  Future<String> deleteCustomer(int id) async {
    final url = '${ApiConstants.updateCustomer}/$id';
    final response = await _apiService.delete(url);
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<String> storeCustomer(StoreCustomerModel storeCustomerModel) async {
    final response = await _apiService.post(ApiConstants.storeCustomer,
        body: storeCustomerModel.toJson());
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<String> updateCustomer(
      StoreCustomerModel storeCustomerModel, int id) async {
    final url = '${ApiConstants.updateCustomer}/$id';
    final response =
        await _apiService.post(url, body: storeCustomerModel.toJson());
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }
}
