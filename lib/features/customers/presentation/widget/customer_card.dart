import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer});
final CustomerEntity customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            "https://library.asr3-languages.com/storage/${customer.customerProfilePicture}",
          ),
        ),
        title: Text(
          customer.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(customer.customerPhone),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EGP ${customer.customerBalance}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            //   decoration: BoxDecoration(
            //     color: customer['status'] == 'active' ? Colors.green : Colors.grey,
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Text(
            //     customer['status'] ?? '',
            //     style: const TextStyle(color: Colors.white, fontSize: 10),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
