import 'package:dartz/dartz.dart';

import '../../../../core/network/models/api_error_model.dart';

abstract class HomeRepo{
  Future<Either<ApiFaliureModel, String>> logout();

}