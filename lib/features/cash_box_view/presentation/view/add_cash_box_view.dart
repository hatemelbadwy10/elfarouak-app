import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/components/custom/custom_button.dart';
import 'package:elfarouk_app/core/components/custom/custom_text_field.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/cash_box_bloc.dart';

class AddCashBoxView extends StatefulWidget {
  final Map<String, dynamic>? argument;

  const AddCashBoxView({super.key, this.argument});

  @override
  State<AddCashBoxView> createState() => _AddCashBoxViewState();
}

class _AddCashBoxViewState extends State<AddCashBoxView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final balanceController = TextEditingController();
  final statusController = TextEditingController();
  final noteController = TextEditingController();

  final countries = ['مصر', 'ليبيا'];
  final statuses = ['نشط', 'غير نشط'];

  @override
  void initState() {
    super.initState();
    if (widget.argument != null) {
      nameController.text = widget.argument!['name'] ?? '';
      countryController.text = _getCountryName(widget.argument!['country'] ?? 'eg');
      balanceController.text = (widget.argument!['balance'] ?? '0').toString();
      statusController.text = _getStatusName(widget.argument!['status'] ?? 'active');
      noteController.text = widget.argument!['note'] ?? '';
    } else {
      countryController.text = 'مصر';
      statusController.text = 'نشط';
      balanceController.text = '0';
    }
  }

  String _getCountryCode(String countryName) {
    switch (countryName) {
      case 'مصر':
        return 'EG';
      case 'ليبيا':
        return 'LY';
      default:
        return 'EG';
    }
  }

  String _getCountryName(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'EG':
        return 'مصر';
      case 'LY':
        return 'ليبيا';
      default:
        return 'مصر';
    }
  }

  String _getStatusCode(String statusName) {
    switch (statusName) {
      case 'نشط':
        return 'active';
      case 'غير نشط':
        return 'inactive';
      default:
        return 'active';
    }
  }

  String _getStatusName(String statusCode) {
    switch (statusCode) {
      case 'active':
        return 'نشط';
      case 'inactive':
        return 'غير نشط';
      default:
        return 'نشط';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.argument == null ? 'إضافة صندوق' : 'تعديل بيانات الصندوق'),
      ),
      body: BlocListener<CashBoxBloc, CashBoxState>(
        listener: (context, state) {
          if (state is StoreCashBoxSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            getIt<NavigationService>()
                .navigateToAndReplace(RouteNames.cashBoxView);
          }

          if (state is StoreCashBoxFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: BlocBuilder<CashBoxBloc, CashBoxState>(
          builder: (context, state) {
            if (state is StoreCashBoxLoading || state is UpdateCashBoxLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('بيانات الصندوق', style: Styles.text18SemiBold),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'اسم الصندوق',
                        controller: nameController,
                        validator: (value) =>
                        value!.isEmpty ? 'اسم الصندوق مطلوب' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: countries.contains(countryController.text)
                            ? countryController.text
                            : null,
                        decoration: InputDecoration(
                          labelText: 'البلد',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: AppColors.border),
                          ),
                        ),
                        items: countries
                            .map((country) => DropdownMenuItem(
                            value: country, child: Text(country)))
                            .toList(),
                        onChanged: (value) => countryController.text = value!,
                        validator: (value) =>
                        value == null ? 'البلد مطلوب' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              hintText: 'الرصيد',
                              controller: balanceController,
                              enable: widget.argument==null?true:false,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) return 'الرصيد مطلوب';
                                if (double.tryParse(value) == null) {
                                  return 'يرجى إدخال رقم صحيح';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: statuses.contains(statusController.text)
                                  ? statusController.text
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'الحالة',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: AppColors.border),
                                ),
                              ),
                              items: statuses
                                  .map((status) => DropdownMenuItem(
                                  value: status, child: Text(status)))
                                  .toList(),
                              onChanged: (value) => statusController.text = value!,
                              validator: (value) =>
                              value == null ? 'الحالة مطلوبة' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: 'ملاحظات',
                        controller: noteController,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: widget.argument == null
                            ? 'إضافة الصندوق'
                            : 'تحديث بيانات الصندوق',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final countryCode =
                            _getCountryCode(countryController.text);
                            final statusCode =
                            _getStatusCode(statusController.text);

                            if (widget.argument == null) {
                              context.read<CashBoxBloc>().add(
                                StoreCashBoxEvent(
                                  name: nameController.text,
                                  country: countryCode,
                                  balance: double.parse(balanceController.text),
                                  status: statusCode,
                                  note: noteController.text,
                                ),
                              );
                            } else {
                              context.read<CashBoxBloc>().add(
                                UpdateCashBoxEvent(
                                  id: widget.argument!['id'],
                                  name: nameController.text,
                                  country: countryCode,
                                  balance: double.parse(balanceController.text),
                                  status: statusCode,
                                  note: noteController.text,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}