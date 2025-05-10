import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/features/home_view/presentation/controller/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: AppColors.primary, // نفس لون AppBar
          ),
          child: Text(
            'القائمة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: const Text('المستخدمين'),
          onTap: () {
            getIt<NavigationService>().navigateTo(RouteNames.usersView);
          },
        ),
        ListTile(
          title: const Text('العملاء'),
          onTap: () {
            getIt<NavigationService>().navigateTo(RouteNames.customerView);
          },
        ),
        ListTile(
          title: const Text('التحويلات'),
          onTap: () {
            // ضع هنا ما تريد أن يحدث عند الضغط على العنصر
          },
        ),
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return ListTile(
              title: const Text('تسجيل الخروج'),
              onTap: () {
                context.read<HomeBloc>().add(LogoutEvent());
                // ضع هنا ما تريد أن يحدث عند الضغط على العنصر
              },
            );
          },
        ),
      ],
    );
  }
}
