part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class LogoutFailure extends HomeState{}
class LogoutSuccess extends HomeState{}