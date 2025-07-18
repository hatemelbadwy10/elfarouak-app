import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../controller/customers_bloc.dart';
import '../widget/customer_card.dart';
import '../../domain/entity/customer_entity.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key});

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  final ScrollController _scrollController = ScrollController();
  final List<CustomerEntity> _allCustomers = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers(); // Load the first page
    _scrollController.addListener(_onScroll);
  }

  void _loadCustomers() {
    context.read<CustomersBloc>().add(GetCustomersEvent(page: _currentPage));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        _currentPage++;
        _loadCustomers();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العملاء')),
      body: BlocConsumer<CustomersBloc, CustomersState>(
        listener: (context, state) {
          if (state is CustomerSuccess) {
            if (_currentPage == 1) {
              _allCustomers.clear();
            }
            _allCustomers.addAll(state.list);
            _isLoadingMore = false;
          }
        },
        builder: (context, state) {
          if (state is CustomerLoading && _currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerFailure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: _allCustomers.length + 1, // +1 for loading indicator
            itemBuilder: (context, index) {
              if (index == _allCustomers.length) {
                return _isLoadingMore
                    ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const SizedBox();
              }

              final customer = _allCustomers[index];
              log('id: ${customer.customerId}');

              return CustomerCard(
                onDelete: () {
                  context
                      .read<CustomersBloc>()
                      .add(DeleteCustomerEvent(id: customer.customerId));
                },
                onUpdate: () {
                  getIt<NavigationService>().navigateTo(
                    RouteNames.addCustomerView,
                    arguments: {
                      'id': customer.customerId,
                      'name': customer.customerName,
                      'phone': customer.customerPhone,
                      'address': customer.customerAddress,
                      'country': customer.customerCountry,
                      'balance': customer.customerBalance,
                      'status': 'active',
                      'note': customer.customerNote,
                      'profile_image': customer.customerProfilePicture,
                    },
                  );
                },
                customer: customer,
              );
            },
          );
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
