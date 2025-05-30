
import 'dart:developer';

import '../../domain/enitties/user_data.dart';

class UserDataModel extends UserData {
  UserDataModel({required super.user, required super.token});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    log('token ${json['token']}');
    log('json ${json}');
  return  UserDataModel(
      user: UserModel.fromJson(json["user"]),
      token: json["token"],
    );
  }
}

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.name,

      required super.phone,
      required super.email,
      required super.role,
        required super.countryCode
      });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"] ?? "",
        email: json["email"],
        role: json["role"],
        countryCode: json['country_code']??''
      );
}
