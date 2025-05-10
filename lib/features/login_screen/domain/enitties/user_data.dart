class UserData {
  final User user;
  final String token;

  const UserData({
    required this.user,
    required this.token,
  });

  UserData copyWith({
    User? user,
    String? token,
  }) =>
      UserData(
        user: user ?? this.user,
        token: token ?? this.token,
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String role;
  final String countryCode;


  const User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.countryCode
  });

  User copyWith({
    int? id,
    String? name,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? role,
    bool? isSuspended,
    bool? notifiable,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,

        phone: phone ?? this.phone,
        email: email ?? this.email,
        role: role ?? this.role,
      countryCode: countryCode
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,

        "phone": phone,
        "email": email,
        "role": role,
       "country_code":countryCode
      };
}
