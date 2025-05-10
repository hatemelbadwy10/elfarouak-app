part of 'user_info_bloc.dart';

class UserInfoState extends Equatable {
  const UserInfoState({this.user});
  final UserModel? user;
  @override
  List<Object?> get props => [user];
}
