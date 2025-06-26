import 'dart:developer';

import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:elfarouk_app/features/users/domain/entity/user_entity.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCard extends StatelessWidget {
  final UserEntity userEntity;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final VoidCallback onLogout;

  const UserCard({
    super.key,
    required this.userEntity,
    required this.onDelete,
    required this.onUpdate,
    required this.onLogout, // add this
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      // make sure userId is unique
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar Circle
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Text(
                  userEntity.userName.characters.first,
                  style: const TextStyle(
                    fontSize: 22,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userEntity.userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEntity.userRole,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(userEntity.userPhone),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(userEntity.userCountry == 'LY' ? "ليبيا" : "مصر"),
                      ],
                    ),
                  ],
                ),
              ),

              // Popup Menu for actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  log("BlocProvider.of<UserInfoBloc>(context).state.user?.role == 'admin'${BlocProvider.of<UserInfoBloc>(context).state.user?.role == 'admin'}");
                  if (value == 'update') onUpdate();
                  if (value == 'delete') onDelete();
                  if (value == 'logout') onLogout(); // Add this line
                },
                itemBuilder: (context) {
                  final isAdmin =
                      BlocProvider.of<UserInfoBloc>(context).state.user?.role ==
                          'admin';

                  return [
                    const PopupMenuItem(
                      value: 'update',
                      child: Text('تحديث'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('حذف'),
                    ),
                    if (isAdmin)
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout,
                                color: Colors.redAccent, size: 20),
                            SizedBox(width: 8),
                            Text('تسجيل خروج'),
                          ],
                        ),
                      ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
