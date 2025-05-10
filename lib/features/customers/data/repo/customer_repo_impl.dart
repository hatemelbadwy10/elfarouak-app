import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/customers/data/data_source/customer_data_source.dart';
import 'package:elfarouk_app/features/customers/data/model/store_customer_model.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';
import 'package:elfarouk_app/features/customers/domain/repo/customers_repo.dart';

class CustomerRepoImpl extends CustomersRepo {
  final CustomerDataSource _customerDataSource;

  CustomerRepoImpl(this._customerDataSource);

  @override
  Future<Either<ApiFaliureModel, List<CustomerEntity>>> getCustomers() async {
    try {
      final result = await _customerDataSource.getCustomers();
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
}
