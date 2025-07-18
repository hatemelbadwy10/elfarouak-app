import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/transfers/data/model/auto_complete_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/customers_transfer_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/transfer_model.dart';

import '../../domain/entity/transfer_entity.dart';
import '../model/store_tranfer_model.dart';

abstract class TransfersDataSource {
  Future<TransfersEntity> getTransfers(
      {String? search,
      String? status,
      String? transferType,
      String? tagId,
      String? dateRange,
      int page = 1,
      bool isHome = false,
      int? cashBoxId
      });

  Future storeTransfer(StoreTransferModel model);

  Future updateTransfer(StoreTransferModel model, int id);

  Future deleteTransfer(int id);

  Future<List<AutoCompleteModel>> autoCompleteSearch(
      String listType, String text);

  Future addTag(String tag, String type);

  Future partialUpdate(int customerId,
      {double? balance, String? transferType, String? type});

  Future sendMoney(int fromCashBoxId, int toCashBoxId, double amount,
      String? note, double? exchangeFee);

  Future updatePhoto(int id, File image);

  Future getTags(String type);

  Future updateStatus(int id, String status);

  Future storeCustomerTransfer(CustomersTransferModel customer);

  Future<TransferEntity> getSingleTransfer(int id);
}

class TransfersDataSourceImpl extends TransfersDataSource {
  final ApiService _apiService;

  TransfersDataSourceImpl(this._apiService);

  @override
  Future<TransfersEntity> getTransfers(
      {String? search,
      String? status,
      String? transferType,
      String? tagId,
      String? dateRange,
      int page = 1,
      int? cashBoxId,
      bool isHome = false}) async {
      final queryParameters = <String, String>{
      'page': page.toString(),
      "page_size": "10"
    };

    if (search?.isNotEmpty ?? false) {
      queryParameters['search'] = search!;
    }
    if (status != null) {
      queryParameters['status'] = status;
    }
    if (transferType != null) {
      queryParameters['transfer_type'] = transferType;
    }
    if (tagId != null && tagId.toLowerCase() != 'null') {
      queryParameters['tag_id'] = tagId;
    }
    if(cashBoxId !=null){
      queryParameters['cash_box_id']=cashBoxId.toString();
    }
    if (dateRange != null &&
        dateRange.isNotEmpty &&
        dateRange.toLowerCase() != 'null') {
      queryParameters['date_range'] = dateRange;
    }
    final uri = Uri.parse(ApiConstants.getTransfers)
        .replace(queryParameters: queryParameters);

    try {
      final response = await _apiService.get(uri.toString(), queryParameters: {
        "is_home": isHome,
      });

      log('getTransfers response: $response');

      return response.fold(
        (l) {
          throw ServerException(errorModel: l);
        },
        (r) {
          final dynamic dataJson = r.data['data'];
          final transfers = Data.fromJson(dataJson);
          return transfers;
        },
      );
    } catch (e) {
      log('Error fetching transfers: $e');
      rethrow;
    }
  }

  @override
  Future storeTransfer(StoreTransferModel model) async {
    final formData = FormData.fromMap(model.toJson());

    try {
      final response = await _apiService.post(
        ApiConstants.storeTransfers,
        body: formData,
      );
      log('storeTransfer request: ${model.toJson()}');
      log('storeTransfer response: $response');

      return response.fold(
        (l) {
          log('storeTransfer error: ${l.message}');
          throw ServerException(errorModel: l);
        },
        (r) {
          log('storeTransfer success: ${r.message}');
          return r.data['message'];
        },
      );
    } catch (e) {
      log('Error storing transfer: $e');
      rethrow;
    }
  }

  @override
  Future updateTransfer(StoreTransferModel model, int id) async {
    final url = '${ApiConstants.updateTransfer}/$id';
    try {
      final response = await _apiService.put(url, body: model.toJson());
      log('updateTransfer response: $response');

      return response.fold(
        (l) {
          log('update error: $l');
          throw ServerException(errorModel: l);
        },
        (r) {
          return r.data['message'];
        },
      );
    } catch (e) {
      log('Error updating transfer: $e');
      rethrow;
    }
  }

  @override
  Future deleteTransfer(int id) async {
    final url = '${ApiConstants.deleteTransfer}/$id';
    try {
      final response = await _apiService.delete(url);
      log('deleteTransfer response: $response');

      return response.fold(
        (l) {
          throw ServerException(errorModel: l);
        },
        (r) {
          return r.data['message'];
        },
      );
    } catch (e) {
      log('Error deleting transfer: $e');
      rethrow;
    }
  }

  @override
  Future<List<AutoCompleteModel>> autoCompleteSearch(
      String listType, String text) async {
    try {
      final result =
          await _apiService.get(ApiConstants.autoComplete(listType, text));

      return result.fold(
        (l) {
          throw ServerException(errorModel: l);
        },
        (r) {
          final autoCompleteData = (r.data['data'] as List)
              .map((item) => AutoCompleteModel.fromJson(item))
              .toList();
          return autoCompleteData;
        },
      );
    } catch (e) {
      log('Error in autoCompleteSearch: $e');
      rethrow;
    }
  }

  @override
  Future addTag(String tag, String type) async {
    try {
      final result = await _apiService.post(
        ApiConstants.storeTag,
        body: {"name": tag, "status": "active", "tag_type": type},
      );

      return result.fold(
        (l) {
          throw ServerException(errorModel: l);
        },
        (r) {
          log("r.data['data'] ${r.data['data']}");
          return AutoCompleteModel.fromJson(r.data['data']);
        },
      );
    } catch (e) {
      log('Error adding tag: $e');
      rethrow;
    }
  }

  @override
  Future partialUpdate(
    int customerId, {
    double? balance,
    String? transferType,
    String? type,
  }) async {
    final formData = FormData.fromMap({
      if (balance != null) 'balance_amount': balance,
      if (transferType != null) 'balance_operation': transferType,
      if (type != null) 'balance_operation': type,
      "_method": 'put'
    });

    try {
      final response = await _apiService.post(
        'customer/partial-update/$customerId',
        body: formData,
      );

      log('partialUpdate request: $formData');
      log('partialUpdate response: $response');

      return response.fold(
        (l) {
          log('partialUpdate error: ${l.message}');
          throw ServerException(errorModel: l);
        },
        (r) {
          log('partialUpdate success: ${r.message}');
          return r.data['message'];
        },
      );
    } catch (e) {
      log('Error in partialUpdate: $e');
      rethrow;
    }
  }

  @override
  Future sendMoney(int fromCashBoxId, int toCashBoxId, double amount,
      String? note, double? exchangeFee) async {
    final result =
        await _apiService.post("cash-box/$fromCashBoxId/transfer", body: {
      "amount": amount,
      "to_cash_box_id": toCashBoxId,
      "note": note,
      "exchange_fee": exchangeFee
    });
    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<String> updatePhoto(int id, File image) async {
    final fileName = image.path.split('/').last;

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        image.path,
        filename: fileName,
      ),
    });

    final response = await _apiService.post(
      "transfer/image-update/$id",
      body: formData,
    );

    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future getTags(String type) async {
    final result = await _apiService.get("tag/select-list?tag_type=$type");
    return result.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      final autoCompleteData = (r.data['data'] as List)
          .map((item) => AutoCompleteModel.fromJson(item))
          .toList();
      return autoCompleteData;
    });
  }

  @override
  Future updateStatus(int id, String status) async {
    final response = await _apiService.put(
      "transfer/status-update/$id?status=$status",
    );
    log(' staues ${status}');
    log(' id ${id}');

    return response.fold((l) {
      log('exeption ${l}');
      throw ServerException(errorModel: l);
    }, (r) {
      log(' r ${status}');
      return r.data['message'];
    });
  }

  @override
  Future storeCustomerTransfer(customer) async {
    final response = await _apiService.post("customer/transfer-balance",
        body: customer.toJson());
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      return r.data['message'];
    });
  }

  @override
  Future<TransferEntity> getSingleTransfer(int id) async {
    final response =
        await _apiService.get("${ApiConstants.getSingleTransfer}$id");
    return response.fold((l) {
      throw ServerException(errorModel: l);
    }, (r) {
      final transferEntity = Datum.fromJson(r.data["data"]);
      return transferEntity;
    });
  }
}
