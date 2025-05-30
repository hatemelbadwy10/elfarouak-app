import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/features/expense/domain/entity/expense_entity.dart';

import '../../../../core/network/models/api_error_model.dart';
import '../../data/models/store_expense_mode.dart';

abstract class ExpenseRepo{
  Future<Either<ApiFaliureModel, List<ExpenseEntity>>> getExpense();
  Future<Either<ApiFaliureModel, String>> storeExpense(StoreExpenseModel entity);
  Future<Either<ApiFaliureModel, String>> updateExpense(StoreExpenseModel entity, int id);
  Future<Either<ApiFaliureModel, String>> deleteExpense(int id);
}