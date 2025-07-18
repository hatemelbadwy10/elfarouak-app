import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

import '../../data/model/store_customer_model.dart';

abstract class CustomersRepo{
  Future<Either<ApiFaliureModel, List<CustomerEntity>>> getCustomers({int page});
  Future<Either<ApiFaliureModel,String>>storeCustomer(StoreCustomerModel storeCustomerModel);
  Future<Either<ApiFaliureModel,String>>updateCustomer(StoreCustomerModel storeCustomerModel,int id);
  Future<Either<ApiFaliureModel,String>>deleteCustomer(int id);}