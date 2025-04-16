import 'package:flutter/material.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';

class UserCard extends StatelessWidget {
  final String role;
  final String name;
  final String address;
  final String phone;
  final String country;

  const UserCard({
    super.key,
    required this.role,
    required this.name,
    required this.address,
    required this.phone,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(role,
                style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 4),
            Text(name, style: const TextStyle(fontSize: 15)),
            Text(address, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(phone, style: const TextStyle(fontSize: 14)),
            Text(country, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
