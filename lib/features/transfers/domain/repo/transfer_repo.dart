import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/auto_complete_model.dart';
import 'package:elfarouk_app/features/transfers/domain/entity/transfer_entity.dart';
import '../../data/model/store_tranfer_model.dart';

abstract class TransferRepo {
  Future<Either<ApiFaliureModel, List<TransferEntity>>> getTransfers({String? search,
    String? status,
    String? transferType,
    int? tagId,
    String? dateRange,});
  Future<Either<ApiFaliureModel, String>> storeTransfer(StoreTransferModel model);
  Future<Either<ApiFaliureModel, String>> updateTransfer(StoreTransferModel model, int id);
  Future<Either<ApiFaliureModel, String>> deleteTransfer(int id);
  Future<Either<ApiFaliureModel,List<AutoCompleteModel>>>autoCompleteList(String listType,String text);
  Future<Either<ApiFaliureModel,String>>storeTag(String name);
}
