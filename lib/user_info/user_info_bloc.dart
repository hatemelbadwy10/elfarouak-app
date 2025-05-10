import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/local_storage_services.dart';
import '../core/services/services_locator.dart';
import '../core/utils/storage_keys.dart';
import '../features/login_screen/data/models/user_data_model.dart';

part 'user_info_event.dart';

part 'user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc() : super(const UserInfoState()) {
    on<GetUserDataEvent>(_onGetUserEvent);
    on<RemoveUserDataEvent>(_onRemoveUserDataEvent);
  }

  _onGetUserEvent(GetUserDataEvent event, Emitter<UserInfoState> emit) async {
    final data =
        await getIt<SharedPrefServices>().getString(StorageKeys.userData);
    if (data != null) {
      emit(UserInfoState(user: UserModel.fromJson(jsonDecode(data))));
    }
  }

  _onRemoveUserDataEvent(
      RemoveUserDataEvent event, Emitter<UserInfoState> emit) {
    emit(const UserInfoState(user: null));
  }
}
