import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/add_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/drawer_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/transfer_card.dart';
import 'package:flutter/material.dart';
import '../widgets/user_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('الفاروق'),
        actions: const [AddWidget()],
      ),
      drawer: const Drawer(child: DrawerWidget()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المستخدمين', style: Styles.text18SemiBold),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: UserCard(
                      role: 'مدير',
                      name: 'أحمد محمد',
                      address: 'شارع الثورة',
                      phone: '01012345678',
                      country: 'مصر',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('آخر التحويلات', style: Styles.text18SemiBold),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const TransferCard(
                    from: 'أحمد',
                    to: 'محمد',
                    amount: '1500 جنيه',
                    country: 'مصر',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
