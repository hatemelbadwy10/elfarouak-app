import 'package:dartz/dartz.dart';

import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/data/data_source/cash_box_transfer_data_source.dart';

import 'package:elfarouk_app/features/cash_box_transfer_view/domain/entity/cash_box_transfer_entity.dart';

import '../../../../core/network/exception/server_exception.dart';
import '../../domain/repo/cash_box_transfer_repo.dart';

class CashBoxTransferRepoImpl extends CashBoxTransferRepo {
  final CashBoxTransferDataSource _transferDataSource;

  CashBoxTransferRepoImpl(this._transferDataSource);

  @override
  Future<Either<ApiFaliureModel, List<CashBoxTransferEntity>>>
      getCashBoxTransfer() async {
    try {
      final result = await _transferDataSource.getCashBoxTransferEntity();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
}
