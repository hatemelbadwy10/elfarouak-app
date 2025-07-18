import 'package:flutter/material.dart';
import 'package:elfarouk_app/features/customers/domain/entity/customer_entity.dart';

class SingleCustomerScreen extends StatelessWidget {
  final Map<String, dynamic> argument;

  const SingleCustomerScreen({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    // 👇 Extract and cast the customer from the argument map
    final customer = argument['customer'] as CustomerEntity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل العميل'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(customer.customerProfilePicture),
                ),
                const SizedBox(height: 16),
                Text(
                  customer.customerName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _infoRow('📱 الهاتف:', customer.customerPhone),
                _infoRow('🏠 العنوان:', customer.customerAddress),
                customer.customerCountry != null
                    ? _infoRow('🌍 الدولة:', customer.customerCountry!)
                    : const SizedBox(),

                // _infoRow('👤 النوع:', customer.customerGender),
                _infoRow(
                    '📝 الملاحظات:',
                    customer.customerNote.isNotEmpty
                        ? customer.customerNote
                        : 'لا يوجد'),
                _infoRow('💰 الرصيد:', ' ${customer.customerBalance}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
