part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class GetUsersLoading extends UserState {}

final class GetUsersSuccess extends UserState {
  final List<UserEntity> list;

  GetUsersSuccess({required this.list});
}

final class GetUserFailure extends UserState {
  final String errMessage;

  GetUserFailure({required this.errMessage});
}

final class StoreUserLoading extends UserState {}

final class StoreUserSuccess extends UserState {
  final String message;

  StoreUserSuccess({required this.message});
}

final class StoreUserFailure extends UserState {
  final String errMessage;

  StoreUserFailure({required this.errMessage});
}
final class UpdateUserLoading extends UserState{}
final class UpdateUserSuccess extends UserState{
  final String message;

  UpdateUserSuccess({required this.message});
}
final class UpdateUserFailure extends UserState{
  final String errMessage;

  UpdateUserFailure({required this.errMessage});
}

final class DeleteUserLoading extends UserState {}

final class DeleteUserSuccess extends UserState {
  final String message;

  DeleteUserSuccess({required this.message});
}

final class DeleteUserFailure extends UserState {
  final String errMessage;

  DeleteUserFailure({required this.errMessage});
}
