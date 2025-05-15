import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

import '../../../../core/services/services_locator.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    required this.onDelete,
    required this.onUpdate,
  });

  final CustomerEntity customer;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    String profileImageUrl = customer.customerProfilePicture ?? '';

    // Check if the URL is valid (e.g., starts with 'http' or 'https')
    bool isValidUrl = Uri.tryParse(profileImageUrl)?.hasScheme ?? false;

    return GestureDetector(
      onTap: () {
        getIt<NavigationService>().navigateTo(
          RouteNames.singleCustomerView,
          arguments: {
            'customer': customer,
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: isValidUrl
                ? NetworkImage(profileImageUrl) // Load from the network
                : const AssetImage('assets/images/default_profile.png') as ImageProvider, // Fallback to a default asset
          ),
          title: Text(
            customer.customerName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customer.customerPhone),
              const SizedBox(height: 4),
              Text(
                "EGP ${customer.customerBalance}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'update') onUpdate();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'update',
                child: Text('تحديث'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('حذف'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}
