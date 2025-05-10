import 'package:flutter/material.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../../../core/components/custom/custom_text_field.dart';

class AddTransferView extends StatefulWidget {
  const AddTransferView({super.key});

  @override
  State<AddTransferView> createState() => _AddTransferViewState();
}

class _AddTransferViewState extends State<AddTransferView> {
  final _formKey = GlobalKey<FormState>();

  final _clientNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _branchController = TextEditingController();
  final _tagController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _notesController = TextEditingController();

  String _transactionType = 'debit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            snap: true,
            title: Text("إضافة تحويل"),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(hintText: 'اسم العميل', controller: _clientNameController),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'المبلغ', controller: _amountController),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'الفرع', controller: _branchController),
                    const SizedBox(height: 16),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text("نوع العملية"),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'debit',
                          groupValue: _transactionType,
                          onChanged: (value) {
                            setState(() {
                              _transactionType = value!;
                            });
                          },
                        ),
                        const Text('خصم من حسابه'),
                        const SizedBox(width: 16),
                        Radio<String>(
                          value: 'credit',
                          groupValue: _transactionType,
                          onChanged: (value) {
                            setState(() {
                              _transactionType = value!;
                            });
                          },
                        ),
                        const Text('نقدي'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'المرسل إليه', controller: _tagController),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'العنوان التفصيلي (اختياري)', controller: _addressController),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'الحساب البنكي (اختياري)', controller: _bankAccountController),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'تاج (ملاحظات مختصرة)', controller: _tagController),
                    const SizedBox(height: 16),
                    CustomTextField(hintText: 'ملاحظات', controller: _notesController),
                    const SizedBox(height: 24),

                    CustomButton(
                      text: "حفظ التحويل",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("تم إرسال البيانات");
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
