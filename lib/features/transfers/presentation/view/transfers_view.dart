import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:flutter/material.dart';
import '../../../home_view/presentation/widgets/transfer_card.dart';

class TransfersView extends StatelessWidget {
  const TransfersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحويلات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                getIt<NavigationService>().navigateTo(RouteNames.singleTransferView);
              },
              child: const TransferCard(
                phone: "012079143",
                from: 'أحمد',
                to: 'محمد',
                amount: '1500 جنيه',
                address: 'مصر',
                isSender: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
