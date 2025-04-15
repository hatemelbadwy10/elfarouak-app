
import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../../../core/utils/app_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('تسجيل الدخول', style: Styles.text18SemiBold),
            const SizedBox(height: 32),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور',
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'تسجيل الدخول',
              onPressed: () {
                getIt<NavigationService>().navigateTo(RouteNames.homeView);
              },
            ),
          ],
        ),
      ),
    );
  }
}
