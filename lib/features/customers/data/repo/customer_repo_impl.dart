import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/customers/data/data_source/customer_data_source.dart';
import 'package:elfarouk_app/features/customers/data/model/store_customer_model.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';
import 'package:elfarouk_app/features/customers/domain/repo/customers_repo.dart';

import '../model/customer_partial_update_model.dart';

class CustomerRepoImpl extends CustomersRepo {
  final CustomerDataSource _customerDataSource;

  CustomerRepoImpl(this._customerDataSource);

  @override
  @override
  Future<Either<ApiFaliureModel, List<CustomerEntity>>> getCustomers({int page = 1}) async {
    try {
      final result = await _customerDataSource.getCustomers(page: page);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> deleteCustomer(int id) async {
    try {
      final result = await _customerDataSource.deleteCustomer(id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeCustomer(
      StoreCustomerModel storeCustomerModel) async {
    try {
      final result = await _customerDataSource.storeCustomer(storeCustomerModel);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateCustomer(
      StoreCustomerModel storeCustomerModel, int id) async {
    try {
      final result = await _customerDataSource.updateCustomer(storeCustomerModel, id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
    Future<Either<ApiFaliureModel, CustomerPartialUpadteModel>> getCustomerActivities({required int customerId, int page = 1}) async {
    try {
      final result = await _customerDataSource.getCustomerActivities(customerId: customerId, page: page);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
  
  @override
  Future<Either<ApiFaliureModel, String>> undoActivity({required int activityId}) async {
    try {
      final result = await _customerDataSource.undoActivity(activityId: activityId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
}
