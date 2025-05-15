import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/auto_complete_model.dart';

import 'package:elfarouk_app/features/transfers/domain/entity/transfer_entity.dart';
import 'package:elfarouk_app/features/transfers/domain/repo/transfer_repo.dart';

import '../data_source/transfers_data_source.dart';
import '../model/store_tranfer_model.dart';

class TransferRepoImpl extends TransferRepo {
  final TransfersDataSource _transferDataSource;

  TransferRepoImpl(this._transferDataSource);

  @override
  Future<Either<ApiFaliureModel, List<TransferEntity>>> getTransfers({String? search,
    String? status,
    String? transferType,
    int? tagId,
    String? dateRange,}) async {
    try {
      final result = await _transferDataSource.getTransfers();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeTransfer(
      StoreTransferModel model) async {
    try {
      final result = await _transferDataSource.storeTransfer(model);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateTransfer(
      StoreTransferModel model, int id) async {
    try {
      final result = await _transferDataSource.updateTransfer(model, id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> deleteTransfer(int id) async {
    try {
      final result = await _transferDataSource.deleteTransfer(id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, List<AutoCompleteModel>>> autoCompleteList(
      String listType, String text) async {
    try {
      final result =
          await _transferDataSource.autoCompleteSearch(listType, text);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeTag(String name)async {
try{
  final result =await _transferDataSource.addTag(name);
  return Right(result);
}on ServerException catch (failure) {
  return Left(failure.errorModel);
}

  }
}
