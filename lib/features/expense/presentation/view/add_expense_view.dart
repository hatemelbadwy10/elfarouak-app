import 'dart:developer';

import 'package:elfarouk_app/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/expense/presentation/controller/expense_bloc.dart';
import 'package:http/http.dart';
import '../../../transfers/presentation/controller/transfer_bloc.dart';
import '../../../transfers/presentation/widgets/add_tag_widget.dart';
import '../controller/expense_state.dart';

class AddExpenseView extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const AddExpenseView({super.key, this.arguments});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final _tagController = TextEditingController();

  int? _branchId;
  int? _tagId;
  List<dynamic> _tags = [];

  @override
  void initState() {
    super.initState();

    // Fetch tags when the screen loads
    context.read<TransferBloc>().add(GetTagsEvent(type: "expenses_tags"));

    final expense = widget.arguments?['expense'];
    log('expense ${expense != null}');
    if (expense != null) {
      _branchId = expense.expanseBranch == 'فرع مصر' ? 1 : 2;
      amountController.text = expense.expanseAmount ?? '';
      _tagController.text = expense.expanseTag ?? '';
      noteController.text = expense.expanseDescription ?? '';
      _tagId = int.parse(expense.tagId);
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.arguments?['expense'] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل المصروف' : 'إضافة مصروف'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ExpenseBloc, ExpenseState>(
            listener: (context, state) {
              if (state.requestStatus == RequestStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('تم الحفظ بنجاح'),
                      backgroundColor: Colors.green),
                );
                Navigator.of(context).pop();
              } else if (state.requestStatus == RequestStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.errMessage),
                      backgroundColor: Colors.red),
                );
              }
            },
          ),
          BlocListener<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is GetTagsSuccess) {
                setState(() {
                  _tags = state
                      .list; // Make sure this matches your state property name
                });
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('بيانات المصروف',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),

                  // Branch dropdown
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'الفرع'),
                    value: _branchId,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('فرع ليبيا')),
                      DropdownMenuItem(value: 2, child: Text('فرع مصر')),
                    ],
                    onChanged: (value) {
                      setState(() => _branchId = value);
                    },
                    validator: (value) => value == null ? 'الفرع مطلوب' : null,
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'المبلغ'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'المبلغ مطلوب';
                      if (double.tryParse(value) == null)
                        return 'يرجى إدخال رقم صحيح';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tag dropdown with loading state
                  BlocBuilder<TransferBloc, TransferState>(
                    builder: (context, state) {
                      if (state is GetTagsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                labelText: 'تاج (ملاحظات مختصرة)',
                                border: OutlineInputBorder(),
                              ),
                              value: _tagId,
                              items: _tags.map((tag) {
                                return DropdownMenuItem(
                                  value: tag.id,
                                  child: Text(tag.label),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null && _tags.isNotEmpty) {
                                  final selectedTag = _tags
                                      .firstWhere((tag) => tag.id == value);
                                  setState(() {
                                    _tagId = selectedTag.id;
                                    _tagController.text = selectedTag.label;
                                  });
                                }
                              },
                              validator: (value) =>
                                  value == null ? 'التاج مطلوب' : null,
                            ),
                          ),
                          AddTagButton(
                            onTagCreated: (int newTagId, String label) {
                              setState(() {
                                _tagId = newTagId;
                                _tagController.text = label;

                                // Optional: fetch updated tags list again
                                context
                                    .read<TransferBloc>()
                                    .add(GetTagsEvent(type: "expenses_tags"));
                              });
                            },
                            type: 'expenses_tags',
                            contextBloc: context,
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'ملاحظات'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'الملاحظات مطلوبه';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit button
                  BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      final isLoading =
                          state.requestStatus == RequestStatus.loading;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final amount =
                                        double.parse(amountController.text);
                                    final description = noteController.text;

                                    if (isEditing) {
                                      final id = widget
                                          .arguments!['expense'].expenseId;
                                      context
                                          .read<ExpenseBloc>()
                                          .add(UpdateExpenseEvent(
                                            id: id,
                                            tagId: _tagId!,
                                            amount: amount,
                                            branchId: _branchId!,
                                            description: description,
                                          ));
                                    } else {
                                      context
                                          .read<ExpenseBloc>()
                                          .add(StoreExpenseEvent(
                                            tagId: _tagId!,
                                            amount: amount,
                                            branchId: _branchId!,
                                            description: description,
                                          ));
                                    }
                                  }
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(isEditing
                                  ? 'تحديث المصروف'
                                  : 'إضافة المصروف'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
