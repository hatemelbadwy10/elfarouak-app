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
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({
      "accept": "application/json",
      "content-type": "application/json",
    });
    final token =
        await getIt<SharedPrefServices>().getString(StorageKeys.token);
    if (token != null) {
      options.headers.addAll({"Authorization": "Bearer $token",
      });
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      handler.next(response);
      return;
    }
    // if request not success, we can handle the global messages for all requests here or re-throw the error for specifc handling
    // also we can refresh token and re-call the same request after token updated.
    late String message;
    switch (response.statusCode) {
      case 401:
        message = "You are not authorized";
        getIt<SharedPrefServices>().clearLocalStorage();
        getIt<NavigationService>()
            .navigateToAndClearStack(RouteNames.loginScreen);
        break;
      case 404:
        message =
            "You do not have access to this feature. Please contact your system administrator to proceed";
        break;
      case 422:
        message = response.data['message'];
        break;
      case 400:
      case 500:
      case 503:
        message =
            "We have been notified of this mistake and we are looking to fix it.";
        break;
      default:
        message = "An unknown error occurred";
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
    late String message;
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        message =
            "Connection timed out. Please check your internet connection.";
        break;
      case DioExceptionType.sendTimeout:
        message = "Sending request timed out. Please try again later.";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receiving response timed out. Please try again later.";
        break;
      case DioExceptionType.cancel:
        message = "Request has been canceled.";
        break;
      case DioExceptionType.badCertificate:
        message =
            "Invalid SSL certificate. Please contact with technical support.";
        break;
      case DioExceptionType.badResponse:
        message = "An error occurred. Please contact with technical support.";
        break;
      case DioExceptionType.connectionError:
        message =
            "Error establishing a connection. Please check your internet connection.";
        break;
      case DioExceptionType.unknown:
        message = "An unknown error occurred. Please try again later.";
        break;
      default:
        message = "An error occurred. Please try again later.";
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
