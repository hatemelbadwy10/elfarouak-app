import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/components/packages/toast/message_handlers.dart';
import '../../../../core/services/local_storage_services.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/storage_keys.dart';
import '../../../../user_info/user_info_bloc.dart';
import '../../domain/repo/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepo _homeRepo;
  HomeBloc(this._homeRepo) : super(HomeInitial()) {
   on<LogoutEvent>(_onLogoutEvent);
  }
   _onLogoutEvent(LogoutEvent event, Emitter<HomeState> emit) async {
    final result = await _homeRepo.logout();
    result.fold(
          (l) {
        ShowToastMessages.showMessage(l.message);
        emit(LogoutFailure());
      },
          (r) {
        ShowToastMessages.showMessage(r);
        getIt<SharedPrefServices>().clearLocalStorage();
        getIt<SharedPrefServices>().saveBoolean(StorageKeys.isLoggedIn, false);
        var context = getIt<NavigationService>().navigatorKey.currentContext!;
        context.read<UserInfoBloc>().add(RemoveUserDataEvent());
        getIt<NavigationService>()
            .navigateToAndClearStack(RouteNames.loginScreen);
        emit(LogoutSuccess());
      },
    );
  }

}
