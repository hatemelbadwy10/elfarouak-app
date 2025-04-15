

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

}

