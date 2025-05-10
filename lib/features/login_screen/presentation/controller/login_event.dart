part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}
class UserLoginEvent extends LoginEvent{
  final String email,password;

  UserLoginEvent({required this.email, required this.password});
}
