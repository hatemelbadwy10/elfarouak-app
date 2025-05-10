import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/add_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/drawer_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/quick_action_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/transfer_card.dart';
import 'package:flutter/material.dart';
import '../widgets/balance_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الفاروق',
              style: TextStyle(
                fontSize: 18, // Smaller font size to fit better
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text color for better contrast
              ),
            ),
            SizedBox(width: 6), // Reduced width for better fit
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سعر الدينار الليبي:',
                  style: TextStyle(
                    fontSize: 12, // Smaller font size
                    color: Colors.white70, // Light gray for a more elegant look
                  ),
                ),
                Text(
                  '9.3 EGP', // Static exchange rate value updated to 9.3 EGP
                  style: TextStyle(
                    fontSize: 14, // Slightly smaller font for emphasis
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent, // Green color for the exchange rate
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          AddWidget(), // Your action widget
        ],
      ),
      drawer: const Drawer(child: DrawerWidget()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ الرصيد
            const Row(
              children: [
                BalanceCardWidget(
                  label: "إجمالي الرصيد",
                  balance: "15,000 EGP",
                  color: Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ✅ Quick Actions
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuickActionWidget(
                  icon: Icons.compare_arrows,
                  label: "حوالة",
                  color: AppColors.primary,
                ),
                QuickActionWidget(
                  icon: Icons.account_balance_wallet,
                  label: "سحب أو إيداع",
                  color: Colors.green,
                ),
                QuickActionWidget(
                  icon: Icons.send_rounded,
                  label: "إرسال أموال",
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// ✅ التحويلات - تغيرت إلى حوالات
            const Text(
              'آخر الحوالات (5)',
              style: Styles.text18SemiBold,
            ),
            const SizedBox(height: 4),
            Text(
              'الإجمالي: 7500 جنيه',
              style: Styles.text13.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  getIt<NavigationService>().navigateTo(RouteNames.transfersView);
                },
                child: Text(
                  'عرض الكل',
                  style: Styles.sectionTitle.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: Styles.text13.color,
                    decorationThickness: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ✅ Expanded لازم يكون هنا علشان ListView
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return const TransferCard(
                    phone: "01207922143",
                    from: 'أحمد',
                    to: 'محمد',
                    amount: '1500 جنيه',
                    address: 'مصر',
                    isSender: true,
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
