import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/expense/domain/entity/expense_entity.dart';
import 'package:elfarouk_app/features/expense/domain/repo/expense_repo.dart';
import 'package:elfarouk_app/features/expense/data/data_source/expense_data_source.dart';

import '../models/store_expense_mode.dart';

class ExpenseRepoImpl extends ExpenseRepo {
  final ExpenseDataSource _dataSource;

  ExpenseRepoImpl(this._dataSource);

  @override
  Future<Either<ApiFaliureModel, List<ExpenseEntity>>> getExpense() async {
    try {
      final result = await _dataSource.getExpense();
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeExpense(StoreExpenseModel entity) async {
    try {
      final result = await _dataSource.storeExpense(entity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateExpense(StoreExpenseModel entity, int id) async {
    try {
      final result = await _dataSource.updateExpense(entity, id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> deleteExpense(int id) async {
    try {
      final result = await _dataSource.deleteExpense(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(e.errorModel);
    }
  }
}
