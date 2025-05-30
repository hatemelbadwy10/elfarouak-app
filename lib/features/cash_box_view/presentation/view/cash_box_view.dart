import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../controller/cash_box_bloc.dart';
import '../widget/cash_box_card.dart';

class CashBoxView extends StatelessWidget {
  const CashBoxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصناديق النقدية')),
      body: BlocBuilder<CashBoxBloc, CashBoxState>(
        builder: (context, state) {
          if (state is CashBoxLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashBoxSuccess) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final cashBox = state.list[index];
                return CashBoxCard(
                  cashBox: cashBox,
                  onDelete: () {
                    context.read<CashBoxBloc>().add(DeleteCashBoxEvent(id: cashBox.id));
                  },
                  onUpdate: () {
                    getIt<NavigationService>().navigateTo(
                      RouteNames.addCashBoxView,
                      arguments: {
                        'id': cashBox.id,
                        'name': cashBox.name,
                        'country': cashBox.country,
                        'balance': cashBox.balance,
                        'note': cashBox.note,
                        'status': cashBox.status,
                      },
                    );
                  },
                );
              },
            );
          } else if (state is CashBoxFailure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: context.read<UserInfoBloc>().state.user?.role=="admin"?FloatingActionButton(
        onPressed: () {
          getIt<NavigationService>().navigateTo(RouteNames.addCashBoxView);
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة صندوق',
        child: const Icon(Icons.add, color: Colors.white),
      ):const SizedBox(),
    );
  }
}
