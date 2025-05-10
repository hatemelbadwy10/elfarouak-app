import 'package:elfarouk_app/features/users/presentation/controller/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/user_card.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../domain/entity/user_entity.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المستخدمين')),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // Show SnackBar based on success or failure of delete
          if (state is DeleteUserSuccess) {
            getIt<NavigationService>()
                .navigateToAndReplace(RouteNames.usersView);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حذف المستخدم بنجاح')),
            );
          } else if (state is DeleteUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('حدث خطأ أثناء حذف المستخدم')),
            );
          }
        },
        builder: (context, state) {
          if (state is GetUsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetUserFailure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          } else if (state is GetUsersSuccess) {
            final List<UserEntity> users = state.list;

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = users[index];

                return Dismissible(
                  key: Key(user.userId.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (_) {
                    context
                        .read<UserBloc>()
                        .add(DeleteUserEvent(id: user.userId));
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      getIt<NavigationService>()
                          .navigateTo(RouteNames.singleUsersView,arguments:{
                        'name': user.userName,
                        'user_phone': user.userPhone,
                        'user_Email': user.userEmail,
                        'user_name': user.userName,
                        'user_role': 'admin',
                        'user_country': user.userCountry,
                      } );
                    },
                    child: UserCard(
                      userEntity: user,
                      onDelete: () {
                        context
                            .read<UserBloc>()
                            .add(DeleteUserEvent(id: user.userId));
                      },
                      onUpdate: () {
                        getIt<NavigationService>().navigateTo(
                          RouteNames.addUserView,
                          arguments: {
                            'id': user.userId,
                            'name': user.userName,
                            'user_phone': user.userPhone,
                            'user_Email': user.userEmail,
                            'user_name': user.userName,
                            'user_role': 'admin',
                            'user_country': user.userCountry,
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox(); // fallback
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIt<NavigationService>().navigateTo(RouteNames.addUserView);
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة مستخدم',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
