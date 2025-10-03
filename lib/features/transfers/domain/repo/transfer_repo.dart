import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/auto_complete_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/customers_transfer_model.dart';
import 'package:elfarouk_app/features/transfers/domain/entity/transfer_entity.dart';
import '../../data/model/store_tranfer_model.dart';

abstract class TransferRepo {
  Future<Either<ApiFaliureModel, TransfersEntity>> getTransfers({
    String? search,
    String? status,
    String? transferType,
    int? tagId,
    String? dateRange,
    int page = 1,
    bool? isHome,
    int? cashBoxId
  });

  Future<Either<ApiFaliureModel, String>> storeTransfer(StoreTransferModel model);
  Future<Either<ApiFaliureModel, String>> updateTransfer(StoreTransferModel model, int id);
  Future<Either<ApiFaliureModel, String>> deleteTransfer(int id);
  Future<Either<ApiFaliureModel,List<AutoCompleteModel>>>autoCompleteList(String listType,String text);
  Future<Either<ApiFaliureModel,AutoCompleteModel>>storeTag(String name,String type);
  Future<Either<ApiFaliureModel,String>>partialUpdate(
      int customerId, {
        double? balance,
        String? transferType,
        String? type,
      });
  Future<Either<ApiFaliureModel,String>>sendMoney(
      int fromCashBoxId, int toCashBoxId, double amount, String? note,double? exchangeFee);
  Future<Either<ApiFaliureModel,String>>updateImage(
      int transferId, File image, );
Future<Either<ApiFaliureModel,List<AutoCompleteModel>>>getTags(String type);
Future<Either<ApiFaliureModel,String>>updateStatus(int id , String status);
Future<Either<ApiFaliureModel,String>>storeCustomerTransfer(CustomersTransferModel customer);
Future<Either<ApiFaliureModel,TransferEntity>>getSingleTransfer (int id);
Future<Either<ApiFaliureModel,String>>updateRate(double rate);
}
