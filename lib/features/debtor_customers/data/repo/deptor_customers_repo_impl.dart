import 'package:dartz/dartz.dart';

import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/debtor_customers/data/data_source/debtor_customers_data_source.dart';

import 'package:elfarouk_app/features/debtor_customers/domain/entity/debtor_customers_entity.dart';

import '../../../../core/network/exception/server_exception.dart';
import '../../domain/repo/deptor_customers_repo.dart';

class DebtorCustomersRepoImpl extends DebtorCustomersRepo{
  final DebtorCustomersDataSource _debtorCustomersDataSource;

  DebtorCustomersRepoImpl(this._debtorCustomersDataSource);
  @override
  Future<Either<ApiFaliureModel, List<DebtorCustomersEntity>>> getDebtors() async{
    try {
      final result = await _debtorCustomersDataSource.getDebtors();
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    }
  }
  }

