import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return   ListView(
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
            // ضع هنا ما تريد أن يحدث عند الضغط على العنصر
          },
        ),
        ListTile(
          title: const Text('التحويلات'),
          onTap: () {
            // ضع هنا ما تريد أن يحدث عند الضغط على العنصر
          },
        ),
        ListTile(
          title: const Text('تسجيل الخروج'),
          onTap: () {
            // ضع هنا ما تريد أن يحدث عند الضغط على العنصر
          },
        ),
      ],
    );
  }
}
