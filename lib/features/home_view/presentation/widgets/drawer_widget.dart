import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/features/home_view/presentation/controller/home_bloc.dart';
import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.exchangeFee});

  final double exchangeFee;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            color: AppColors.primary, // نفس لون AppBar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "مرحبًا بك، ${context.read<UserInfoBloc>().state.user?.name ?? ''}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "الدور: ${context.read<UserInfoBloc>().state.user?.role ?? ''}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const Text(
                'القائمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (context.read<UserInfoBloc>().state.user?.role !="user")  ListTile(
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
            getIt<NavigationService>().navigateTo(RouteNames.transfersView,
                arguments: {"exchange_fee": exchangeFee});
          },
        ),
       if (context.read<UserInfoBloc>().state.user?.role !="user") ListTile(
          title: const Text('الصناديق النقدية'),
          onTap: () {
            getIt<NavigationService>().navigateTo(RouteNames.cashBoxView);
          },
        ),
        ListTile(
          title: const Text('المصروفات'),
          onTap: () {
            getIt<NavigationService>().navigateTo(RouteNames.expenseView);
          },
        ),
        ListTile(
          title: const Text('المدنين'),
          onTap: () {
            getIt<NavigationService>().navigateTo(RouteNames.debtorsView);
          },
        ),
        if (context.read<UserInfoBloc>().state.user?.role !="user") ListTile(
          title: const Text('تحويلات الفروع'),
          onTap: () {
            getIt<NavigationService>()
                .navigateTo(RouteNames.cashBoxTransferView);
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
