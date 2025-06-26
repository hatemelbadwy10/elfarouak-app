import 'package:flutter/material.dart';

class AddCustomerForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final ValueNotifier<String?> countryCodeNotifier;

  const AddCustomerForm({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.countryCodeNotifier,
  });

  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final Map<String, String> countries = {
    'مصر': 'EG',
    'ليبيا': 'LY',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: 'اسم العميل',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
          value == null || value.isEmpty ? 'الرجاء إدخال الاسم' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'رقم الهاتف',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
          value == null || value.isEmpty ? 'الرجاء إدخال رقم الهاتف' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: widget.countryCodeNotifier.value,
          decoration: const InputDecoration(
            labelText: 'الدولة',
            border: OutlineInputBorder(),
          ),
          items: countries.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList(),
          onChanged: (value) {
            widget.countryCodeNotifier.value = value;
          },
          validator: (value) =>
          value == null ? 'الرجاء اختيار الدولة' : null,
        ),
      ],
    );
  }
}
