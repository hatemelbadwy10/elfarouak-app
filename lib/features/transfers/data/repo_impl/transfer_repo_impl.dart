import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/auto_complete_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/customers_transfer_model.dart';

import 'package:elfarouk_app/features/transfers/domain/entity/transfer_entity.dart';
import 'package:elfarouk_app/features/transfers/domain/repo/transfer_repo.dart';

import '../data_source/transfers_data_source.dart';
import '../model/store_tranfer_model.dart';

class TransferRepoImpl extends TransferRepo {
  final TransfersDataSource _transferDataSource;

  TransferRepoImpl(this._transferDataSource);

  @override
  Future<Either<ApiFaliureModel, TransfersEntity>> getTransfers(
      {String? search,
      String? status,
      String? transferType,
      int? tagId,
      String? dateRange,
      int page = 1,
      bool? isHome,
      int? cashBoxId}) async {
    try {
      final result = await _transferDataSource.getTransfers(
          search: search,
          status: status,
          transferType: transferType,
          tagId: tagId.toString(),
          dateRange: dateRange,
          page: page,
          isHome: isHome ?? false,
          cashBoxId: cashBoxId);
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
  Future<Either<ApiFaliureModel, AutoCompleteModel>> storeTag(
      String name, String type) async {
    try {
      final result = await _transferDataSource.addTag(name, type);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> partialUpdate(
    int customerId, {
    double? balance,
    String? transferType,
    String? type,
  }) async {
    try {
      final result = await _transferDataSource.partialUpdate(
        customerId,
        balance: balance,
        transferType: transferType,
        type: type,
      );
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> sendMoney(int fromCashBoxId,
      int toCashBoxId, double amount, String? note, double? exchangeFee) async {
    try {
      final result = await _transferDataSource.sendMoney(
          fromCashBoxId, toCashBoxId, amount, note, exchangeFee);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateImage(
      int transferId, File image) async {
    try {
      final result = await _transferDataSource.updatePhoto(transferId, image);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, List<AutoCompleteModel>>> getTags(
      String type) async {
    try {
      final result = await _transferDataSource.getTags(type);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateStatus(
      int id, String status) async {
    try {
      final result = await _transferDataSource.updateStatus(id, status);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeCustomerTransfer(
      CustomersTransferModel customer) async {
    try {
      final result = await _transferDataSource.storeCustomerTransfer(customer);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, TransferEntity>> getSingleTransfer(
      int id) async {
    try {
      final result = await _transferDataSource.getSingleTransfer(id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateRate(double rate) async {
    try {
      final result = await _transferDataSource.updateRate(rate);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
}
