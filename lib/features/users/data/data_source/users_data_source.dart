import 'dart:developer';

import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/features/users/data/models/store_user_model.dart';

import '../../../../core/network/exception/server_exception.dart';
import '../../../../core/network/network_provider/api_services.dart';
import '../../domain/entity/user_entity.dart';
import '../models/user_model.dart';

abstract class UsersDataSource {
  Future<List<UserEntity>> getUsers();

  Future storeUser(StoreUserModel storeUserModel);

  Future updateUser(StoreUserModel storeUserModel, int id);

  Future deleteUser(int id);
}

class UserDataSourceImpl extends UsersDataSource {
  final ApiService _apiService;

  UserDataSourceImpl(this._apiService);

  @override
  @override
  Future<List<UserEntity>> getUsers() async {
    final response = await _apiService.get(ApiConstants.users);
    log('response $response');
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      final dataJson = r.data['data'] as Map<String, dynamic>;
      final data = Data.fromJson(dataJson);
      return data.data;
    });
  }

  @override
  Future storeUser(StoreUserModel storeUserModel) async {
    final response = await _apiService.post(ApiConstants.storeUser,
        body: storeUserModel.toJson());
    log('storeUserModel.toJson()${storeUserModel.toJson()}');
    log('response $response');
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future deleteUser(int id) async {
    final url = '${ApiConstants.deleteUser}/$id';
    final response = await _apiService.delete(url);
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future updateUser(StoreUserModel storeUserModel, int id) async {
    final url = '${ApiConstants.updateUser}/$id';
    final response = await _apiService.put(url, body: storeUserModel.toJson());
    log('response $response');
    return response.fold((l) {
      log('error $l');
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }
}
