import 'dart:io';

import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/components/custom/custom_button.dart';
import 'package:elfarouk_app/core/components/custom/custom_text_field.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/customers_bloc.dart';
import '../widget/image_picker_widget.dart';

class AddCustomerView extends StatefulWidget {
  final Map<String, dynamic>? argument;

  const AddCustomerView({super.key, this.argument});

  @override
  State<AddCustomerView> createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final genderController = TextEditingController();
  final countryController = TextEditingController();
  final balanceController = TextEditingController();
  final statusController = TextEditingController();
  final noteController = TextEditingController();
  File? _selectedImage;
  String? _existingImageUrl;

  final genders = ['ذكر', 'أنثى'];
  final countries = ['مصر', 'ليبيا'];
  final statuses = ['نشط', 'غير نشط'];

  @override
  void initState() {
    super.initState();
    if (widget.argument != null) {
      nameController.text = widget.argument!['name'] ?? '';
      phoneController.text = widget.argument!['phone'] ?? '';
      addressController.text = widget.argument!['address'] ?? '';
      genderController.text = _getGenderName(widget.argument!['gender'] ?? 'male');
      countryController.text = _getCountryName(widget.argument!['country'] ?? 'eg');
      balanceController.text = (widget.argument!['balance'] ?? '0').toString();
      statusController.text = _getStatusName(widget.argument!['status'] ?? 'active');
      noteController.text = widget.argument!['note'] ?? '';
      _existingImageUrl = widget.argument!['profile_image'];
    } else {
      genderController.text = 'ذكر';
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

  String _getGenderCode(String genderName) {
    switch (genderName) {
      case 'ذكر':
        return 'male';
      case 'أنثى':
        return 'female';
      default:
        return 'male';
    }
  }

  String _getGenderName(String genderCode) {
    switch (genderCode) {
      case 'male':
        return 'ذكر';
      case 'female':
        return 'أنثى';
      default:
        return 'ذكر';
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

  void _handleImagePicked(File? image) {
    setState(() {
      _selectedImage = image;
      if (image != null) _existingImageUrl = null;
    });
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(widget.argument == null ? 'إضافة عميل' : 'تعديل بيانات العميل'),
        ),
        body: BlocListener<CustomersBloc, CustomersState>(
          listener: (context, state) {
            if (state is StoreCustomerSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
              getIt<NavigationService>()
                  .navigateToAndReplace(RouteNames.customerView);
            }

            if (state is StoreCustomerFailure) {
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
          child: BlocBuilder<CustomersBloc, CustomersState>(
            builder: (context, state) {
              if (state is StoreCustomerLoading || state is UpdateCustomerLoading) {
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
                        const Text('بيانات العميل', style: Styles.text18SemiBold),
                        const SizedBox(height: 20),
                        // Show image picker only if it's the "Add" view or if it's the "Update" view without an existing image
                        widget.argument == null || _existingImageUrl == null
                            ? Center(
                          child: PickSingleImageWidget(
                            image: _selectedImage,
                            onImagePicked: (File value) {
                              setState(() {
                                _selectedImage = value;
                              });
                            },
                          ),
                        )

                            : Container(),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'اسم العميل',
                          controller: nameController,
                          validator: (value) =>
                          value!.isEmpty ? 'اسم العميل مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'رقم الهاتف',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                          value!.isEmpty ? 'رقم الهاتف مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'العنوان',
                          controller: addressController,
                          validator: (value) =>
                          value!.isEmpty ? 'العنوان مطلوب' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: genders.contains(genderController.text)
                                    ? genderController.text
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'الجنس',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: AppColors.border),
                                  ),
                                ),
                                items: genders
                                    .map((gender) => DropdownMenuItem(
                                    value: gender, child: Text(gender)))
                                    .toList(),
                                onChanged: (value) => genderController.text = value!,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DropdownButtonFormField<String>(
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'الرصيد',
                                controller: balanceController,
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
                              ? 'إضافة العميل'
                              : 'تحديث بيانات العميل',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final countryCode =
                              _getCountryCode(countryController.text);
                              final genderCode =
                              _getGenderCode(genderController.text);
                              final statusCode =
                              _getStatusCode(statusController.text);

                              if (widget.argument == null) {
                                context.read<CustomersBloc>().add(
                                  StoreCustomerEvent(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    address: addressController.text,
                                    gender: genderCode,
                                    country: countryCode,
                                    balance: balanceController.text,
                                    status: statusCode,
                                    note: noteController.text,
                                    profilePic: _selectedImage!,
                                  ),
                                );
                              } else {
                                context.read<CustomersBloc>().add(
                                  UpdateCustomerEvent(
                                    id: widget.argument!['id'],
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    address: addressController.text,
                                    gender: genderCode,
                                    country: countryCode,
                                    balance: balanceController.text,
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
