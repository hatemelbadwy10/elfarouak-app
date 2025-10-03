import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/services_locator.dart';

class AllReportsView extends StatelessWidget {
  const AllReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جميع التقارير"),
      ),
      body: ListView(
        children:  [
          ReportItemWidget(
            title: "تقارير العملاء",
            icon: Icons.people,
            onTap: (){
              getIt<NavigationService>().navigateTo(RouteNames.customersReport);

            },
          ),
          ReportItemWidget(
            title: "تقارير الفروع",
            icon: Icons.location_city,
            onTap: (){
              getIt<NavigationService>().navigateTo(RouteNames.cashBoxesReport);
            },
          ),
          ReportItemWidget(
            title: "تقارير التحويلات",
            icon: Icons.location_city,
            onTap: (){
              getIt<NavigationService>().navigateTo(RouteNames.transfersReport);
            },
          ),


        ],
      ),
    );
  }
}

class ReportItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
final void Function()? onTap;
  const ReportItemWidget({
    super.key,
    required this.title,
    required this.icon,
  required  this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(fontSize: 18),
      ),
      leading: Icon(icon),
      trailing: const Icon(Icons.arrow_back_ios),
      onTap: onTap,
    );
  }
}
