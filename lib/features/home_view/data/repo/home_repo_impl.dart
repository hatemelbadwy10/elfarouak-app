import 'package:dartz/dartz.dart';

import 'package:elfarouk_app/core/network/models/api_error_model.dart';
import 'package:elfarouk_app/features/home_view/data/data_source/home_data_source.dart';

import '../../../../core/network/exception/server_exception.dart';
import '../../domain/repo/home_repo.dart';

class HomeRepoImpl extends HomeRepo{
  final HomeDataSource _dataSource;

  HomeRepoImpl(this._dataSource);
  @override
  Future<Either<ApiFaliureModel, String>> logout() async {
    try {
      final result = await _dataSource.logout();
      return Right(result);
    } on ServerException catch (faliure) {
      return Left(faliure.errorModel);
    }
  }
}