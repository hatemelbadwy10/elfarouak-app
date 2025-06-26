import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:elfarouk_app/core/services/firebase_services.dart';
import 'package:elfarouk_app/features/login_screen/data/models/login_parameters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/components/packages/toast/message_handlers.dart';
import '../../../../core/services/local_storage_services.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/storage_keys.dart';
import '../../../../user_info/user_info_bloc.dart';
import '../../domain/repository/repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;

  LoginBloc(this._loginRepository) : super(LoginInitial()) {
   on<UserLoginEvent>(_onUserLogin);
  }
   _onUserLogin (UserLoginEvent event,Emitter<LoginState>emit)async{
    final fcmToken = await getIt<NotificationService>().getFcmToken();
    log('fcm token ${fcmToken}');
    emit(LoginLoading());
    final result =await _loginRepository.login(LoginParameteres(email: event.email,password: event.password,deviceToken: fcmToken));
    result.fold((l){
      log('left from login ${l.data}');
      log('left from login ${l.status}');
      log('left from login ${l.message}');
      emit(LoginFailure(errMessage: l.message));

    }, (r){
      emit(LoginSuccess());
      var (message, userData) = r;
      log('user data ${userData}');
      ShowToastMessages.showMessage(message);
      getIt<SharedPrefServices>().saveString(StorageKeys.token, userData.token);
      getIt<SharedPrefServices>().saveBoolean(StorageKeys.isLoggedIn, true);
      getIt<SharedPrefServices>()
          .saveString(StorageKeys.userData, jsonEncode(userData.user));
      getIt<SharedPrefServices>().saveString('role', userData.user.role);
      getIt<SharedPrefServices>().saveString("password", event.password);
      log('event ${event.password}');
      getIt<NavigationService>().navigateToAndClearStack(RouteNames.homeView);

      var context = getIt<NavigationService>().navigatorKey.currentContext!;

      if (!context.mounted) return;

      context.read<UserInfoBloc>().add(GetUserDataEvent());
    });
   }
}
