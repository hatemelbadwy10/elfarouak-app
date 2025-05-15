import 'package:equatable/equatable.dart';

class ApiFaliureModel extends Equatable {
  final bool status;
  final String message;
  final dynamic data;

  const ApiFaliureModel({
    required this.status,
    required this.message,
    required  this.data
  });

  factory ApiFaliureModel.fromJson(Map<String, dynamic> json) =>
      ApiFaliureModel(
        status: json["status"] ??false,
        message: json["message"] ?? "",
        data: json['data']??{}
      );

  @override
  List<Object> get props => [status, message];
}
