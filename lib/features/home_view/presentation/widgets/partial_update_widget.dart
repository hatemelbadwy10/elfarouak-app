import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../../../core/services/services_locator.dart';
import '../../../transfers/presentation/controller/transfer_bloc.dart';
import '../../../transfers/presentation/widgets/search_text_field.dart';

class PartialUpdateDialog extends StatelessWidget {
  const PartialUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedAction;
    final balanceController = TextEditingController();
    final senderIdController = TextEditingController();
    int senderId = 1;
    bool isLoading = false; // Moved outside StatefulBuilder

    String? mapArabicActionToApiValue(String? value) {
      switch (value) {
        case 'إضافة':
          return 'add';
        case 'خصم':
          return 'subtract';
        case 'تعيين':
          return 'set';
        default:
          return null;
      }
    }

    return BlocProvider(
      create: (context) => TransferBloc(getIt()),
      child: StatefulBuilder(
        builder: (context, setState) {
          return BlocListener<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is PartialUpdateCustomerLoading) {
                setState(() => isLoading = true);
              } else {
                setState(() => isLoading = false);
              }

              if (state is PartialUpdateCustomerSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.of(context).pop();
              } else if (state is PartialUpdateCustomerFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errMessage)),
                );
              }
            },
            child: AlertDialog(
              title: const Text('إضافة عملية'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SearchTextField(
                      label: 'المرسل',
                      textEditingController: senderIdController,
                      listType: "customer",
                      onSuggestionSelected: (suggestion) {
                        senderId = suggestion.id;
                        senderIdController.text = suggestion.label;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'نوع العملية'),
                      value: selectedAction,
                      items: const [
                        DropdownMenuItem(value: 'إضافة', child: Text('إضافة')),
                        DropdownMenuItem(value: 'خصم', child: Text('خصم')),
                        DropdownMenuItem(value: 'تعيين', child: Text('تعيين')),
                      ],
                      onChanged: (value) {
                        setState(() => selectedAction = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: balanceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'الرصيد'),
                    ),
                  ],
                ),
              ),
              actions: [
                CustomButton(
                  isLoading: isLoading,
                  text: 'تنفيذ',
                  onPressed: () {
                    // Prevent multiple submissions
                    if (isLoading) return;

                    final balance = double.tryParse(balanceController.text);
                    if (selectedAction == null || balance == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى إدخال كل البيانات: المرسل، نوع العملية، الرصيد'),
                        ),
                      );
                      return;
                    }

                    final apiTransferType = mapArabicActionToApiValue(selectedAction);
                    if (apiTransferType == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('نوع العملية غير صحيح')),
                      );
                      return;
                    }

                    context.read<TransferBloc>().add(
                      PartialUpdateCustomerEvent(
                        customerId: senderId,
                        balance: balance,
                        transferType: apiTransferType,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}