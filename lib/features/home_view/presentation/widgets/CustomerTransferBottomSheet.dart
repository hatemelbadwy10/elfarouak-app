import 'dart:developer';
import 'package:flutter/material.dart';

import '../../../transfers/presentation/widgets/search_text_field.dart';

class CustomerTransferBottomSheet extends StatelessWidget {
  const CustomerTransferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final senderIdController = TextEditingController();
    final receiverIdController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    String? senderId;
    String? receiverId;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchTextField(
              label: 'المرسل',
              textEditingController: senderIdController,
              listType: "customer",
              onSuggestionSelected: (suggestion) {
                senderId = suggestion.id.toString();
                senderIdController.text = suggestion.label;
                log("senderId: ${suggestion.id}");
              },
            ),
            const SizedBox(height: 12),
            SearchTextField(
              label: 'المستقبل',
              textEditingController: receiverIdController,
              listType: "customer",
              onSuggestionSelected: (suggestion) {
                receiverId = suggestion.id.toString();
                receiverIdController.text = suggestion.label;
                log("receiverId: ${suggestion.id}");
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: notesController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  log("مرسل ID: $senderId");
                  log("مستقبل ID: $receiverId");
                  log("المبلغ: ${amountController.text}");
                  log("ملاحظات: ${notesController.text}");

                  Navigator.pop(context);
                },
                child: const Text('تنفيذ التحويل'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
