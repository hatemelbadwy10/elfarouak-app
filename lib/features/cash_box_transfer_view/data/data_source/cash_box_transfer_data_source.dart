import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/domain/entity/cash_box_transfer_entity.dart';

import '../../../cash_box_transfer_view/data/model/cash_box_transfer_model.dart';

abstract class CashBoxTransferDataSource{
  Future<List<CashBoxTransferEntity>>getCashBoxTransferEntity();
}
class CashBoxTransferDataSourceImpl extends CashBoxTransferDataSource{
  final ApiService _apiService;

  CashBoxTransferDataSourceImpl(this._apiService);
  @override
  Future<List<CashBoxTransferEntity>> getCashBoxTransferEntity() async{
    final response = await _apiService.get('cash-box-transfers/index');
   return response.fold((l){
     throw ServerException(errorModel: l);
   }, (r){
     final List<dynamic> dataJsonList = r.data['data']['data'];
     return dataJsonList
         .map((json) => Datum.fromJson(json))
         .toList();
   });

  }
}