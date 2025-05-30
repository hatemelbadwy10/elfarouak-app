import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/debtor_customers/domain/entity/debtor_customers_entity.dart';

abstract class DebtorCustomersRepo{
  Future<Either<ApiFaliureModel,List<DebtorCustomersEntity>>>getDebtors();
}