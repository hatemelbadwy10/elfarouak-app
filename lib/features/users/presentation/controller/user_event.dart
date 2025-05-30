part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class GetUserEvent extends UserEvent {}

class StoreUserEvent extends UserEvent {
  final String name;
  final String userName;
  final String phone;
  final String email;
  final String role;
  final String countryCode;
  final String status;
  final String password;
  final String passwordConfirmation;

  StoreUserEvent({
    required this.name,
    required this.userName,
    required this.phone,
    required this.email,
    required this.role,
    required this.countryCode,
    required this.status,
    required this.password,
    required this.passwordConfirmation,
  });
}
class DeleteUserEvent extends UserEvent{
  final int id;

  DeleteUserEvent({required this.id});
}
class UpdateUserEvent extends UserEvent {
  final String name;
  final String userName;
  final String phone;
  final String email;
  final String role;
  final String countryCode;
  final String status;

  final int id;

  UpdateUserEvent({
    required this.name,
    required this.userName,
    required this.phone,
    required this.email,
    required this.role,
    required this.countryCode,
    required this.status,

    required this.id
  });
}
class LogoutUserEvent extends UserEvent {
  final int userId;

  LogoutUserEvent(this.userId);
}