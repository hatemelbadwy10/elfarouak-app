import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../transfers/presentation/controller/transfer_bloc.dart';
class SendMoneySheet extends StatefulWidget {
  const SendMoneySheet({super.key});

  @override
  State<SendMoneySheet> createState() => _SendMoneySheetState();
}

class _SendMoneySheetState extends State<SendMoneySheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int? toCashBoxId;
  int? fromCashBoxId;
  String? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferBloc, TransferState>(
      listener: (context, state) {
        if (state is SendMoneySuccess) {
          Navigator.of(context).pop(); // Close bottom sheet
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is SendMoneyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "الفرع المستقبل"),
              items: const [
                DropdownMenuItem(value: 'مصر', child: Text('مصر')),
                DropdownMenuItem(value: 'ليبيا', child: Text('ليبيا')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedBranch = value;
                  toCashBoxId = value == 'ليبيا' ? 1 : 2;
                  fromCashBoxId = value == 'ليبيا' ? 2 : 1; // opposite
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'ملاحظة'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (fromCashBoxId == null || toCashBoxId == null) {
                  Fluttertoast.showToast(msg: "يرجى اختيار الفرع");
                  return;
                }

                final double? amount = double.tryParse(_amountController.text);
                if (amount == null || amount <= 0) {
                  Fluttertoast.showToast(msg: "يرجى إدخال مبلغ صالح");
                  return;
                }

                context.read<TransferBloc>().add(
                  SendMoneyEvent(
                    fromCashBoxId: fromCashBoxId!,
                    toCashBoxId: toCashBoxId!,
                    amount: amount,
                    note: _noteController.text,
                  ),
                );
              },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }
}
