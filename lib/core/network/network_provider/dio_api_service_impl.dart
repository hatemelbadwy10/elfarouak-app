import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../api_constants.dart';
import '../interceptors/dio_interceptor.dart';
import '../models/api_error_model.dart';
import '../models/api_success_model.dart';
import 'api_services.dart';



class DioApiServiceImpl extends ApiService {
  DioApiServiceImpl() {
    _dio.interceptors.add(DioInterceptor());
    _dio.interceptors.add(PrettyDioLogger(
      error: true,
      compact: true,
      requestBody: true,
      request: true,
      requestHeader: true,
      responseBody: true,
    ));
    _dio.options.validateStatus = (status) {
      return true;
    };
  }

  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  @override
  Future<Either<ApiFaliureModel, ApiSuccessModel>> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  }) async {
    try {
      final Response response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return Right(ApiSuccessModel(
        statusCode: response.statusCode!,
        // here, we should to pasxs the response message to display it for the user if needed
        message: response.statusMessage!,
        // return API data with generic type
        data: response.data,
      ));
    } on DioException catch (error) {
      return Left(ApiFaliureModel.fromJson(error.response?.data ?? {}));
    }
  }

  @override
  Future<Either<ApiFaliureModel, ApiSuccessModel>> post(String path,
      {Map<String, dynamic> body = const {}}) async {
    try {
      final Response response = await _dio.post(path, data: body);
      log('response $response');
      return Right(ApiSuccessModel(
        statusCode: response.statusCode!,
        message: response.statusMessage!,
        data: response.data,
      ));
    } on DioException catch (error) {
      log('error ${error.response?.data}');
      return Left(ApiFaliureModel.fromJson(error.response?.data ?? {}));
    }
  }

  @override
  Future<Either<ApiFaliureModel, ApiSuccessModel>> delete(String path,
      {Map<String, dynamic> body = const {}}) async {
    try {
      final Response response = await _dio.delete(path, data: body);
      log('response $response');
      return Right(ApiSuccessModel(
        statusCode: response.statusCode!,
        message: response.statusMessage!,
        data: response.data,
      ));
    } on DioException catch (error) {
      log('error ${error.response?.data}');
      return Left(ApiFaliureModel.fromJson(error.response?.data ?? {}));
    }
  }

  @override
  Future<Either<ApiFaliureModel, ApiSuccessModel>> put(String path,
      {Map<String, dynamic> body = const {}}) async {
    try {
      final Response response = await _dio.put(path, data: body);
      return Right(ApiSuccessModel(
        statusCode: response.statusCode!,
        message: response.statusMessage!,
        data: response.data,
      ));
    } on DioException catch (error) {
      return Left(ApiFaliureModel.fromJson(error.response?.data ?? {}));
    }
  }
}
