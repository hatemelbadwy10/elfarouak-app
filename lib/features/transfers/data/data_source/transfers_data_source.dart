import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elfarouk_app/core/network/api_constants.dart';
import 'package:elfarouk_app/core/network/exception/server_exception.dart';
import 'package:elfarouk_app/core/network/network_provider/api_services.dart';
import 'package:elfarouk_app/features/transfers/data/model/auto_complete_model.dart';
import 'package:elfarouk_app/features/transfers/data/model/transfer_model.dart';

import '../../domain/entity/transfer_entity.dart';
import '../model/store_tranfer_model.dart';

abstract class TransfersDataSource {
  Future<List<TransferEntity>> getTransfers({
    String? search,
    String? status,
    String? transferType,
    String? tagId,
    String? dateRange,
  });

  Future storeTransfer(StoreTransferModel model);

  Future updateTransfer(StoreTransferModel model, int id);

  Future deleteTransfer(int id);

  Future<List<AutoCompleteModel>> autoCompleteSearch(String listType, String text);

  Future addTag(String tag);
}

class TransfersDataSourceImpl extends TransfersDataSource {
  final ApiService _apiService;

  TransfersDataSourceImpl(this._apiService);

  @override
  Future<List<TransferEntity>> getTransfers({
    String? search,
    String? status,
    String? transferType,
    String? tagId,
    String? dateRange,
  }) async {
    final queryParameters = <String, String>{};

    // Add the filters dynamically based on provided arguments
    if (search?.isNotEmpty ?? false) {
      queryParameters['search'] = search!;
    }
    if (status != null) {
      queryParameters['status'] = status;
    }
    if (transferType != null) {
      queryParameters['transfer_type'] = transferType;
    }
    if (tagId != null) {
      queryParameters['tag_id'] = tagId;
    }
    if (dateRange?.isNotEmpty ?? false) {
      queryParameters['date_range'] = dateRange!;
    }

    final uri = Uri.parse(ApiConstants.getTransfers).replace(queryParameters: queryParameters);

    try {
      final response = await _apiService.get(uri.toString());

      log('getTransfers response: $response');

      return response.fold(
            (l) {
          throw ServerException(errorModel: l);
        },
            (r) {
          final List<dynamic> dataJson = r.data['data']['data'];
          final transfers = dataJson.map((e) => Datum.fromJson(e)).toList();
          return transfers;
        },
      );
    } catch (e) {
      log('Error fetching transfers: $e');
      rethrow; // Rethrow the error after logging it
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
  Future<List<AutoCompleteModel>> autoCompleteSearch(String listType, String text) async {
    try {
      final result = await _apiService.get(ApiConstants.autoComplete(listType, text));

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
  Future addTag(String tag) async {
    try {
      final result = await _apiService.post(
        ApiConstants.storeTag,
        body: {"name": tag, "status": "active"},
      );

      return result.fold(
            (l) {
          throw ServerException(errorModel: l);
        },
            (r) {
          return r.message;
        },
      );
    } catch (e) {
      log('Error adding tag: $e');
      rethrow;
    }
  }
}
