

import 'package:elfarouk_app/features/customers/data/data_source/customer_data_source.dart';
import 'package:elfarouk_app/features/customers/presentation/controller/customers_bloc.dart';
import 'package:elfarouk_app/features/home_view/data/data_source/home_data_source.dart';
import 'package:elfarouk_app/features/home_view/data/repo/home_repo_impl.dart';
import 'package:elfarouk_app/features/home_view/domain/repo/home_repo.dart';
import 'package:elfarouk_app/features/home_view/presentation/controller/home_bloc.dart';
import 'package:elfarouk_app/features/users/data/data_source/users_data_source.dart';
import 'package:elfarouk_app/features/users/data/repo/user_repo_impl.dart';
import 'package:elfarouk_app/features/users/domain/repo/user_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/customers/data/repo/customer_repo_impl.dart';
import '../../features/customers/domain/repo/customers_repo.dart';
import '../../features/login_screen/data/data_source/login_remote_data_source.dart';
import '../../features/login_screen/data/repository/repository_impl.dart';
import '../../features/login_screen/domain/repository/repository.dart';
import '../../features/login_screen/presentation/controller/login_bloc.dart';
import '../../features/users/presentation/controller/user_bloc.dart';
import '../network/network_provider/api_services.dart';
import '../network/network_provider/dio_api_service_impl.dart';
import 'local_storage_services.dart';
import 'navigation_service.dart';

GetIt getIt = GetIt.instance;

setupSingeltonServices() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<ApiService>(() => DioApiServiceImpl());
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => SharedPrefServices());
 // await getIt<NotificationService>().initialize();
  await getIt<SharedPrefServices>().init();
_getUsers();
_loginDI();
_homeDI();
_customersDI();
}
_getUsers(){
  getIt.registerLazySingleton<UsersDataSource>(
          () => UserDataSourceImpl(getIt()));
  getIt.registerLazySingleton<UserRepo>(() => UserRepoImpl(getIt()));
  getIt.registerFactory(() => UserBloc(getIt()));

}

_loginDI() {
  getIt.registerLazySingleton<LoginRemoteDatasource>(
          () => LoginRemoteDatasourceImpl(getIt()));
  getIt.registerLazySingleton<LoginRepository>(
          () => LoginRepositoryImpl(getIt()));
  getIt.registerFactory(() => LoginBloc(getIt()));
}
_homeDI(){
  getIt.registerLazySingleton<HomeDataSource>(()=>HomeDataSourceImpl(getIt()));
  getIt.registerLazySingleton<HomeRepo>(()=>HomeRepoImpl(getIt()));
  getIt.registerFactory(() => HomeBloc(getIt()));

}
_customersDI(){
  getIt.registerLazySingleton<CustomerDataSource>(()=>CustomerDataSourceImpl(getIt()));
  getIt.registerLazySingleton<CustomersRepo>(()=>CustomerRepoImpl(getIt()));
  getIt.registerFactory(() => CustomersBloc(getIt()));
}