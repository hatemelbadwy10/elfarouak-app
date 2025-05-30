import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:elfarouk_app/features/users/data/models/store_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repo/user_repo.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepo _userRepo;

  UserBloc(this._userRepo) : super(UserInitial()) {
    on<GetUserEvent>(_getUsers);
    on<StoreUserEvent>(_storeUser);
    on<DeleteUserEvent>(_deleteUser);
    on<UpdateUserEvent>(_updateUser);
    on<LogoutUserEvent>(_logoutUser);
  }

  void _getUsers(GetUserEvent event, Emitter<UserState> emit) async {
    emit(GetUsersLoading());
    final result = await _userRepo.getUsers();
    log('result $result');
    result.fold((l) {
      log('l ${l.message}');
      emit(GetUserFailure(errMessage: l.message));
    }, (r) {
      emit(GetUsersSuccess(list: r));
    });
  }

  void _storeUser(StoreUserEvent event, Emitter<UserState> emit) async {
    emit(StoreUserLoading());

    final result = await _userRepo.storeUser(StoreUserModel(
      name: event.name,
      userName: event.userName,
      phone: event.phone,
      email: event.email,
      role: event.role,
      countryCode: event.countryCode,
      status: event.status,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    ));

    result.fold(
      (failure) {
        log('Store user failed: ${failure.message}');
        emit(StoreUserFailure(errMessage: failure.message));
      },
      (successMessage) {
        log('Store user success');
        emit(StoreUserSuccess(message: successMessage));
      },
    );
  }

  void _updateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UpdateUserLoading());
    final result = await _userRepo.updateUser(
        StoreUserModel(
            name: event.name,
            phone: event.phone,
            role: 'admin',
            countryCode: event.countryCode,
            status: 'active',
            email: event.email,
            userName: event.userName),
        event.id);
    result.fold((l) {
      emit(UpdateUserFailure(errMessage: l.message));
      Fluttertoast.showToast(msg: l.message);
    }, (r) {
      emit(UpdateUserSuccess(message: r));
      Fluttertoast.showToast(msg: r);
      getIt<NavigationService>().navigateToAndRemoveUntil(
        RouteNames.usersView,
        predicate: (Route<dynamic> route) =>
            route.settings.name == RouteNames.homeView,
      );
    });
  }

  void _deleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(DeleteUserLoading());
    final result = await _userRepo.deleteUser(event.id);
    result.fold((l) {
      emit(DeleteUserFailure(errMessage: l.message));
    }, (r) {
      emit(DeleteUserSuccess(message: r));
    });
  }
  void _logoutUser(LogoutUserEvent event, Emitter<UserState> emit) async {
    emit(LogoutUserLoading());

    final result = await _userRepo.userLogout(event.userId);

    result.fold(
          (l) {
        Fluttertoast.showToast(msg: l.message); // show error
      },
          (r) {
        emit(LogoutUserSuccess(message: r));
        Fluttertoast.showToast(msg: r); // show success
      },
    );
  }
}
