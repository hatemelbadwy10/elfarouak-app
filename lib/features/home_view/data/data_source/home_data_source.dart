import '../../../../core/network/api_constants.dart';
import '../../../../core/network/exception/server_exception.dart';
import '../../../../core/network/network_provider/api_services.dart';

abstract class HomeDataSource{
  Future<String> logout();
}
class HomeDataSourceImpl extends HomeDataSource{
  final ApiService _apiService;

  HomeDataSourceImpl(this._apiService);

  @override
  Future<String> logout() async {
    final response = await _apiService.post(ApiConstants.logout);
    return response.fold(
          (l) {
        throw ServerException(errorModel: l);
      },
          (r) {
        return r.data['message'];
      },
    );
  }

}