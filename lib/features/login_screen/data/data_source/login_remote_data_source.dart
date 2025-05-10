
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/exception/server_exception.dart';
import '../../../../core/network/network_provider/api_services.dart';
import '../models/login_parameters.dart';
import '../models/user_data_model.dart';


abstract class LoginRemoteDatasource {
  Future<(String message, UserDataModel userDataModel)> login(
      LoginParameteres loginParameteres);



}

class LoginRemoteDatasourceImpl extends LoginRemoteDatasource {
  final ApiService _apiService;

  LoginRemoteDatasourceImpl(this._apiService);

  @override
  Future<(String, UserDataModel)> login(
      LoginParameteres loginParameteres) async {
    final response = await _apiService.post(
      ApiConstants.login,
      body: loginParameteres.toJson(),
    );
    return response.fold(
      (l) {
        throw ServerException(errorModel: l);
      },
      (r) {
        var userDataModel = UserDataModel.fromJson(r.data);
        return (r.data['message'] as String, userDataModel);
      },
    );
  }

}
