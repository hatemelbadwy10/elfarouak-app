import 'dart:developer';

import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/expense/data/models/store_expense_mode.dart';
import 'package:elfarouk_app/features/expense/domain/entity/expense_entity.dart';

import '../models/expense_model.dart';

abstract class ExpenseDataSource {
  Future<List<ExpenseEntity>> getExpense();
  Future storeExpense(StoreExpenseModel expense);
  Future updateExpense(StoreExpenseModel expense, int id);
  Future deleteExpense(int id);
}

class ExpenseDataSourceImpl implements ExpenseDataSource {
  final ApiService _apiService;

  ExpenseDataSourceImpl(this._apiService);

  @override
  Future<List<ExpenseEntity>> getExpense() async {
    try {
      final response = await _apiService.get(ApiConstants.getExpense);
      return response.fold(
            (l) => throw ServerException(errorModel: l),
            (r) {
          final List<dynamic> data = r.data['data']['data'];
          return data.map((item) => Datum.fromJson(item)).toList();
        },
      );
    } catch (e) {
      log('Error fetching expenses: $e');
      rethrow;
    }
  }

  @override
  Future storeExpense(StoreExpenseModel expense) async {
    try {
      final response = await _apiService.post(
        ApiConstants.storeExpense,
        body: expense.toJson(),
      );
      return response.fold(
            (l) => throw ServerException(errorModel: l),
            (r) => r.data['message'],
      );
    } catch (e) {
      log('Error storing expense: $e');
      rethrow;
    }
  }

  @override
  Future updateExpense(StoreExpenseModel expense, int id) async {
    final url = '${ApiConstants.updateExpense}/$id';
    try {
      final response = await _apiService.put(
        url,
        body: expense.toJson(),
      );
      return response.fold(
            (l) => throw ServerException(errorModel: l),
            (r) => r.data['message'],
      );
    } catch (e) {
      log('Error updating expense: $e');
      rethrow;
    }
  }

  @override
  Future deleteExpense(int id) async {
    final url = '${ApiConstants.deleteExpense}/$id';
    try {
      final response = await _apiService.delete(url);
      return response.fold(
            (l) => throw ServerException(errorModel: l),
            (r) => r.data['message'],
      );
    } catch (e) {
      log('Error deleting expense: $e');
      rethrow;
    }
  }
}
