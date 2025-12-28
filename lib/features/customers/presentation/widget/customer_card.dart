import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

import '../../../../core/services/services_locator.dart';
import '../view/customer_partial_update_view.dart';

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
        // Navigate to customer activities view
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerActivitiesView(
              customerId: customer.customerId,
              customerName: customer.customerName,
            ),
          ),
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
                "${customer.customerCountry} ${customer.customerBalance}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'update') onUpdate();
              if (value == 'delete') _showDeleteDialog(context);
              if (value == 'activities') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerActivitiesView(
                      customerId: customer.customerId,
                      customerName: customer.customerName,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'activities',
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 8),
                    Text('الأنشطة'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'update',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('تحديث'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('حذف', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('حذف العميل'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف ${customer.customerName}؟ لا يمكن التراجع عن هذا الإجراء.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'إلغاء',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              onDelete();
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
