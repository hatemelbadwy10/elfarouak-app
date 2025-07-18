import 'package:elfarouk_app/features/cash_box_view/data/model/update_model.dart';
import 'package:elfarouk_app/features/cash_box_view/domain/entity/cash_box_entity.dart';
import 'package:elfarouk_app/user_info/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/components/custom/action_button.dart';
import '../../../../core/components/custom/custom_text_field.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../controller/cash_box_bloc.dart';
import '../widget/cash_box_card.dart';

class CashBoxView extends StatelessWidget {
  const CashBoxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الصناديق النقدية')),
      body: BlocBuilder<CashBoxBloc, CashBoxState>(
        builder: (context, state) {
          if (state is CashBoxLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashBoxSuccess) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final cashBox = state.list[index];
                return CashBoxCard(
                  cashBox: cashBox,
                  onChangeBalance: () {
                    final bloc = context.read<CashBoxBloc>();
                    showBalanceChangeBottomSheet(context, cashBox, bloc);
                  },
                  onUpdate: () {
                    getIt<NavigationService>().navigateTo(
                      RouteNames.addCashBoxView,
                      arguments: {
                        'id': cashBox.id,
                        'name': cashBox.name,
                        'country': cashBox.country,
                        'balance': cashBox.balance,
                        'note': cashBox.note,
                        'status': cashBox.status,
                      },
                    );
                  },
                );
              },
            );
          } else if (state is CashBoxFailure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton:
          context.read<UserInfoBloc>().state.user?.role == "admin"
              ? FloatingActionButton(
                  onPressed: () {
                    getIt<NavigationService>()
                        .navigateTo(RouteNames.addCashBoxView);
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: 'إضافة صندوق',
                  child: const Icon(Icons.add, color: Colors.white),
                )
              : const SizedBox(),
    );
  }

  void showBalanceChangeBottomSheet(
      BuildContext context,
      CashBoxEntity entity,
      CashBoxBloc bloc,
      ) {
    final balanceController = TextEditingController();
    final reasonController = TextEditingController();
    String actionType = 'add';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            right: 16,
            left: 16,
          ),
          child: BlocConsumer<CashBoxBloc, CashBoxState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is UpdateCashBoxBalanceSuccess) {
                Navigator.pop(context); // ✅ أغلق BottomSheet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMsg),
                    backgroundColor: Colors.green,
                  ),
                );
                bloc.add(GetCashBoxesEvent());
              } else if (state is UpdateCashBoxBalanceFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMsg),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is UpdateCashBoxBalanceLoading;

              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('تعديل الرصيد',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hintText: 'القيمة',
                      controller: balanceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'القيمة مطلوبة';
                        if (double.tryParse(value) == null) return 'القيمة غير صحيحة';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: actionType,
                      decoration: const InputDecoration(
                        labelText: 'الإجراء',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'add', child: Text('إضافة')),
                        DropdownMenuItem(value: 'subtract', child: Text('خصم')),
                      ],
                      onChanged: (value) {
                        if (value != null) actionType = value;
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      hintText: 'السبب',
                      controller: reasonController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'السبب مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    ActionButton(
                      text: 'تنفيذ',
                      isLoading: isLoading,
                      bgColor: Colors.blue,
                      textColor: Colors.white,
                      borderRadius: 10,
                      onPressed: isLoading
                          ? null
                          : () {
                        if (formKey.currentState!.validate()) {
                          final balance = double.parse(balanceController.text);
                          final reason = reasonController.text;

                          bloc.add(
                            UpdateCashBoxBalanceEvent(
                              id: entity.id,
                              updateModel: UpdateModel(
                                amount: balance,
                                operation: actionType,
                                reason: reason,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

}
