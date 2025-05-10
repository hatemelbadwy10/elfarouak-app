import 'package:dartz/dartz.dart';
import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/users/data/models/store_user_model.dart';
import 'package:elfarouk_app/features/users/domain/entity/user_entity.dart';

abstract class UserRepo{
  Future<Either<ApiFaliureModel,List<UserEntity>>>getUsers();
  Future<Either<ApiFaliureModel,String>>storeUser(StoreUserModel storeUserModel);
  Future<Either<ApiFaliureModel,String>>updateUser(StoreUserModel storeUserModel,int id);
  Future<Either<ApiFaliureModel,String>>deleteUser(int id);
}