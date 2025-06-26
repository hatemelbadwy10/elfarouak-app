import 'package:elfarouk_app/features/transfers/presentation/controller/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../transfers/presentation/widgets/search_text_field.dart';

class CustomerTransferScreen extends StatefulWidget {
  const CustomerTransferScreen({super.key});

  @override
  State<CustomerTransferScreen> createState() => _CustomerTransferScreenState();
}

class _CustomerTransferScreenState extends State<CustomerTransferScreen> {
  final senderIdController = TextEditingController();
  final receiverIdController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  int? senderId;
  int? receiverId;

  bool isLoading = false;

  @override
  void dispose() {
    senderIdController.dispose();
    receiverIdController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (senderId != null && receiverId != null) {
      final amount = double.tryParse(amountController.text);
      if (amount == null) {
        Fluttertoast.showToast(msg: 'أدخل مبلغًا صحيحًا');
        return;
      }

      context.read<TransferBloc>().add(
        StoreCustomerTransferEvent(
          receiverId: receiverId!,
          senderId: senderId!,
          amount: amount,
        ),
      );
    } else {
      Fluttertoast.showToast(msg: 'يجب اختيار المستلم و المرسل');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحويل بين العملاء'),
      ),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          if (state is StoreCustomerTransferLoading) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }

          if (state is StoreCustomerTransferSuccess) {
            Fluttertoast.showToast(msg: 'تم التحويل بنجاح');
            Navigator.pop(context); // OR: navigate to home screen
          } else if (state is StoreCustomerTransferFailure) {
            // Error message already shown from BLoC
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchTextField(
                    label: 'المرسل',
                    textEditingController: senderIdController,
                    listType: "customer",
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        senderId = suggestion.id;
                        senderIdController.text = suggestion.label;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SearchTextField(
                    label: 'المستقبل',
                    textEditingController: receiverIdController,
                    listType: "customer",
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        receiverId = suggestion.id;
                        receiverIdController.text = suggestion.label;
                      });
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
                      onPressed: isLoading ? null : () => _onSubmit(context),
                      child: isLoading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('تنفيذ التحويل'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
