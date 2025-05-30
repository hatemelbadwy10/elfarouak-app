import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_routing/route_names.dart';
import '../../components/packages/toast/message_handlers.dart';
import '../../services/local_storage_services.dart';
import '../../services/navigation_service.dart';
import '../../services/services_locator.dart';
import '../../utils/storage_keys.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      "accept": "application/json",
      "content-type": "application/json",
    });

    final token = await getIt<SharedPrefServices>().getString(StorageKeys.token);
    if (token != null) {
      options.headers.addAll({"Authorization": "Bearer $token"});
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      handler.next(response);
      return;
    }

    late String message;

    switch (response.statusCode) {
      case 401:
        message = "أنت غير مصرح لك بالوصول.";
        getIt<SharedPrefServices>().clearLocalStorage();
        getIt<NavigationService>().navigateToAndClearStack(RouteNames.loginScreen);
        break;

      case 404:
        message = "ليس لديك صلاحية الوصول إلى هذه الميزة. يرجى التواصل مع مسؤول النظام.";
        break;

      case 422:
        final data = response.data;
        if (data['message'] != null && data['message'] is String) {
          message = data['message'];
        } else if (data['errors'] != null && data['errors'] is Map<String, dynamic>) {
          final errors = data['errors'] as Map<String, dynamic>;
          final firstKey = errors.keys.first;
          final errorMessages = errors[firstKey];

          if (errorMessages is List && errorMessages.isNotEmpty && errorMessages.first is String) {
            message = errorMessages.first;
          } else if (errorMessages is String) {
            message = errorMessages;
          } else {
            message = "حدث خطأ في البيانات المدخلة.";
          }
        } else {
          message = "حدث خطأ في البيانات المدخلة.";
        }
        break;

      case 400:
      case 500:
      case 503:
        message = "تم الإبلاغ عن هذا الخطأ، ونعمل على إصلاحه.";
        break;

      default:
        message = "حدث خطأ غير متوقع.";
        break;
    }

    ShowToastMessages.showMessage(
      message,
      backgroundColor: Colors.orangeAccent,
      textColor: Colors.black,
      toastLength: Toast.LENGTH_LONG,
    );

    handler.reject(DioException(
      requestOptions: response.requestOptions,
      response: response,
    ));
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = "حدث خطأ. حاول مرة أخرى.";
    log("خطأ: ${err.response?.data}");

    if (err.type == DioExceptionType.badResponse && err.response != null) {
      final responseData = err.response?.data;

      if (responseData is Map<String, dynamic>) {
        if (responseData['message'] != null && responseData['message'] is String) {
          message = responseData['message'];
        } else if (responseData['errors'] != null && responseData['errors'] is Map<String, dynamic>) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          final firstKey = errors.keys.first;
          final errorMessages = errors[firstKey];

          if (errorMessages is List && errorMessages.isNotEmpty && errorMessages.first is String) {
            message = errorMessages.first;
          } else if (errorMessages is String) {
            message = errorMessages;
          } else {
            message = "حدث خطأ في البيانات المدخلة.";
          }
        }
      }
    } else {
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          message = "انتهت مهلة الاتصال. تحقق من اتصال الإنترنت.";
          break;
        case DioExceptionType.sendTimeout:
          message = "انتهت مهلة إرسال الطلب.";
          break;
        case DioExceptionType.receiveTimeout:
          message = "انتهت مهلة استلام الرد.";
          break;
        case DioExceptionType.cancel:
          message = "تم إلغاء الطلب.";
          break;
        case DioExceptionType.connectionError:
          message = "فشل الاتصال بالخادم. تحقق من الشبكة.";
          break;
        case DioExceptionType.unknown:
          message = "حدث خطأ غير معروف.";
          break;
        default:
          message = "حدث خطأ. حاول مرة أخرى.";
      }
    }

    ShowToastMessages.showMessage(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );

    handler.reject(err);
  }
}
