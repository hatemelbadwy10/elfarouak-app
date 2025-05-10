class StoreUserModel {
  final String name;
  final String phone;
  final String role;
  final String countryCode;
  final String? status;
  final String? password;
  final String? passwordConfirmation;
  final String email;
  final String userName;

  StoreUserModel({
    required this.name,
    required this.phone,
    required this.role,
    required this.countryCode,
    required this.status,
     this.password,
     this.passwordConfirmation,
    required this.email,
    required this.userName,
  });


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'role': role,
      'country_code': countryCode,
      'status': status,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'email': email,
      'user_name': userName,
    };
  }
}
