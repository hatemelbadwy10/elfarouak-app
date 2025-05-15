import 'package:dartz/dartz.dart';
import '../models/api_error_model.dart';
import '../models/api_success_model.dart';


abstract class ApiService {
  Future<Either<ApiFaliureModel, ApiSuccessModel>> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  });

  Future<Either<ApiFaliureModel, ApiSuccessModel>> post(
    String path, {
    dynamic body = const {},
  });

  Future<Either<ApiFaliureModel, ApiSuccessModel>> put(
    String path, {
   dynamic body = const {},
  });

  Future<Either<ApiFaliureModel, ApiSuccessModel>> delete(
    String path, {
    Map<String, dynamic> body = const {},
  });
}
