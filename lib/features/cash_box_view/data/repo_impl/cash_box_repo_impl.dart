import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import '../../domain/entity/cash_box_entity.dart';
import '../../domain/repo/cash_box_repo.dart';
import '../data_source/cash_box_data_source.dart';
import '../model/store_cash_box_model.dart';
import '../model/update_model.dart';

class CashBoxRepoImpl extends CashBoxRepo {
  final CashBoxDataSource _cashBoxDataSource;

  CashBoxRepoImpl(this._cashBoxDataSource);

  @override
  Future<Either<ApiFaliureModel, List<CashBoxEntity>>> getCashBoxes() async {
    try {
      final result = await _cashBoxDataSource.getCashBox();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeCashBox(
      StoreCashBoxModel entity) async {
    try {
      final result = await _cashBoxDataSource.storeCashBox(entity);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateCashBox(
      StoreCashBoxModel entity, int id) async {
    try {
      final result = await _cashBoxDataSource.updateCashBox(entity, id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> deleteCashBox(int id) async {
    try {
      final result = await _cashBoxDataSource.deleteCashBox(id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateCashBoxBalance(int id,UpdateModel updateModel) async {
    try {
      final result = await _cashBoxDataSource.updateCashBoxBalance(id,updateModel);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
}
