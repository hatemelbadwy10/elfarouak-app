import 'package:dartz/dartz.dart';
import '../../../../core/network/exception/server_exception.dart';
import '../../../../core/network/models/api_error_model.dart';
import '../../domain/repository/repository.dart';
import '../data_source/login_remote_data_source.dart';
import '../models/login_parameters.dart';
import '../models/user_data_model.dart';


class LoginRepositoryImpl extends LoginRepository {
  final LoginRemoteDatasource _loginRemoteDatasource;

  LoginRepositoryImpl(this._loginRemoteDatasource);

  @override
  Future<Either<ApiFaliureModel, (String, UserDataModel)>> login(
      LoginParameteres loginParameteres) async {
    try {
      final result = await _loginRemoteDatasource.login(loginParameteres);
      return Right(result);
    } on ServerException catch (faliure) {
      return Left(faliure.errorModel);
    }
  }
}
