import 'dart:io';

import 'package:dio/dio.dart';

class StoreCustomerModel {
  final String name;
  final String phone;
  final String address;
  final String gender;
  final String country;
  final String balance;
  final String status;
  final String? note;
  final File? image;

  StoreCustomerModel({
    required this.name,
    required this.phone,
    required this.address,
    required this.gender,
    required this.country,
    required this.balance,
    required this.status,
    this.note,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'gender': gender,
      'country': country,
      'balance': balance,
      'status': status,
      'note': note,
      if (image != null)
        'profile_pic':  MultipartFile.fromFile(image!.path,
          filename: image!.path.split('/').last),      // You'll need to handle image upload separately (e.g., multipart/form-data)
    };
  }
}
