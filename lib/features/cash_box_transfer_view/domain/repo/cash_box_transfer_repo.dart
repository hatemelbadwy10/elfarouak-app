import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/domain/entity/cash_box_transfer_entity.dart';

abstract class CashBoxTransferRepo{
  Future<Either<ApiFaliureModel,List<CashBoxTransferEntity>>>getCashBoxTransfer();
}