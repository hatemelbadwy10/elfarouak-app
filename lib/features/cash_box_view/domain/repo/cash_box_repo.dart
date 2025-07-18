import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import '../../data/model/store_cash_box_model.dart';
import '../../data/model/update_model.dart';
import '../entity/cash_box_entity.dart';

abstract class CashBoxRepo {
  Future<Either<ApiFaliureModel, List<CashBoxEntity>>> getCashBoxes();
  Future<Either<ApiFaliureModel, String>> storeCashBox(StoreCashBoxModel entity);
  Future<Either<ApiFaliureModel, String>> updateCashBox(StoreCashBoxModel entity, int id);
  Future<Either<ApiFaliureModel, String>> deleteCashBox(int id);
  Future<Either<ApiFaliureModel,String>>updateCashBoxBalance(int id,UpdateModel updateModel);
}
