class LoginParameteres {
  String? email;
  String? password;
  int? deviceId;
  String? deviceToken;

  LoginParameteres({
    this.email,
    this.password,
    this.deviceId,
    this.deviceToken,
  });

  LoginParameteres.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['device_id'] = deviceId;
    data['device_token'] = deviceToken;
    return data;
  }
}
