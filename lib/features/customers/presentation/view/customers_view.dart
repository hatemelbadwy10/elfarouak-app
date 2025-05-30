import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../controller/customers_bloc.dart';
import '../widget/customer_card.dart';

class CustomersView extends StatelessWidget {
  const CustomersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العملاء')),
      body: BlocBuilder<CustomersBloc, CustomersState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerSuccess) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                log('id: state.list[index].customerId ${state.list[index].customerId}');
                return CustomerCard(
                  onDelete: (){
                    context.read<CustomersBloc>().add(DeleteCustomerEvent(id: state.list[index].customerId));
                  },
                  onUpdate: (){
                    final customer = state.list[index];
                    getIt<NavigationService>().navigateTo(
                      RouteNames.addCustomerView,
                      arguments: {
                        'id': customer.customerId,
                        'name': customer.customerName,
                        'phone': customer.customerPhone,
                        'address': customer.customerAddress,
                        'gender': customer.customerGender,
                        'country': customer.customerCountry,
                        'balance': customer.customerBalance,
                        'status': 'active',
                        'note': customer.customerNote,
                        'profile_image': customer.customerProfilePicture,
                      },
                    );
                  },
                  customer: state.list[index],
                );
              },
            );
          } else if (state is CustomerFailure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIt<NavigationService>().navigateTo(RouteNames.addCustomerView);
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة مستخدم',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
