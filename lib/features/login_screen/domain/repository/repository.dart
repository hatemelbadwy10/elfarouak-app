import 'package:dartz/dartz.dart';

import '../../../../core/network/models/api_error_model.dart';
import '../../data/models/login_parameters.dart';
import '../../data/models/user_data_model.dart';


abstract class LoginRepository {
  Future<Either<ApiFaliureModel, (String message, UserDataModel userData)>>
      login(LoginParameteres loginParameteres);
}
