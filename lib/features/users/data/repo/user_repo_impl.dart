import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/users/data/data_source/users_data_source.dart';
import 'package:elfarouk_app/features/users/data/models/store_user_model.dart';
import 'package:elfarouk_app/features/users/domain/entity/user_entity.dart';
import '../../../../core/network/exception/server_exception.dart';
import '../../domain/repo/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final UsersDataSource _userDataSource;

  UserRepoImpl(this._userDataSource);

  @override
  Future<Either<ApiFaliureModel, List<UserEntity>>> getUsers() async {
    try {
      final result = await _userDataSource.getUsers();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> storeUser(
      StoreUserModel storeUserModel) async {
    try {
      final result = await _userDataSource.storeUser(storeUserModel);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> deleteUser(int id) async {
    try {
      final result = await _userDataSource.deleteUser(id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }

  @override
  Future<Either<ApiFaliureModel, String>> updateUser(
      StoreUserModel storeUserModel, int id) async {
    try {
      final result = await _userDataSource.updateUser(storeUserModel, id);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(failure.errorModel);
    }
  }
}
