import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:elfarouk_app/core/components/custom/custom_button.dart';
import 'package:elfarouk_app/core/components/custom/custom_text_field.dart';
import '../controller/user_bloc.dart';

class AddUserView extends StatefulWidget {
  final Map<String, dynamic>? argument;

  const AddUserView({super.key, this.argument});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final accountController = TextEditingController();
  final roleController = TextEditingController();
  final countryController = TextEditingController();

  final roles = ['مدير', 'مشرف', 'موظف'];
  final countries = ['مصر', 'ليبيا'];

  // Map Arabic role names to backend role keys
  final Map<String, String> roleMap = {
    'مدير': 'admin',
    'مشرف': 'user',
    'موظف': 'employee',
  };

  @override
  void initState() {
    super.initState();
    if (widget.argument != null) {
      nameController.text = widget.argument!['name'];
      phoneController.text = widget.argument!['user_phone'];
      emailController.text = widget.argument!['user_Email'];
      accountController.text = widget.argument!['user_name'];
      // Convert backend role to Arabic role name for display
      roleController.text = roleMap.entries
          .firstWhere(
            (entry) => entry.value == widget.argument!['user_role'],
        orElse: () => const MapEntry('مدير', 'admin'),
      )
          .key;
      countryController.text =
          _getCountryName(widget.argument!['user_country']);
    } else {
      roleController.text = 'مدير';
      countryController.text = 'مصر';
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
    switch (countryCode) {
      case 'eg':
        return 'مصر';
      case 'ly':
        return 'ليبيا';
      default:
        return 'مصر';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.argument == null ? 'إضافة مستخدم' : 'تعديل مستخدم'),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is StoreUserSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            getIt<NavigationService>()
                .navigateToAndReplace(RouteNames.usersView);
          }

          if (state is StoreUserFailure) {
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
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is StoreUserLoading || state is UpdateUserLoading) {
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
                      const Text('بيانات المستخدم',
                          style: Styles.text18SemiBold),
                      const SizedBox(height: 20),

                      CustomTextField(
                        hintText: 'الاسم الكامل',
                        controller: nameController,
                        validator: (value) =>
                        value!.isEmpty ? 'الاسم مطلوب' : null,
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
                        hintText: 'اسم المستخدم',
                        controller: accountController,
                        validator: (value) =>
                        value!.isEmpty ? 'اسم المستخدم مطلوب' : null,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        hintText: 'البريد الإلكتروني',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'البريد الإلكتروني مطلوب';
                          if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'بريد إلكتروني غير صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      if (widget.argument == null) ...[
                        CustomTextField(
                          hintText: 'كلمة المرور',
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) return 'كلمة المرور مطلوبة';
                            if (value.length < 6) {
                              return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'تأكيد كلمة المرور',
                          controller: confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value != passwordController.text) {
                              return 'كلمات المرور غير متطابقة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      DropdownButtonFormField<String>(
                        value: roles.contains(roleController.text)
                            ? roleController.text
                            : null,
                        decoration: InputDecoration(
                          labelText: 'الدور',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: AppColors.border),
                          ),
                        ),
                        items: roles
                            .map((role) =>
                            DropdownMenuItem(value: role, child: Text(role)))
                            .toList(),
                        onChanged: (value) => setState(() {
                          roleController.text = value!;
                        }),
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
                            .map((country) =>
                            DropdownMenuItem(value: country, child: Text(country)))
                            .toList(),
                        onChanged: (value) => setState(() {
                          countryController.text = value!;
                        }),
                      ),
                      const SizedBox(height: 30),

                      CustomButton(
                        text: widget.argument == null
                            ? 'إضافة المستخدم'
                            : 'تحديث المستخدم',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final countryCode =
                            _getCountryCode(countryController.text);

                            if (widget.argument == null) {
                              context.read<UserBloc>().add(
                                StoreUserEvent(
                                  name: nameController.text,
                                  userName: accountController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  role: roleMap[roleController.text] ?? 'user',
                                  countryCode: countryCode,
                                  status: 'active',
                                  password: passwordController.text,
                                  passwordConfirmation:
                                  confirmPasswordController.text,
                                ),
                              );
                            } else {
                              context.read<UserBloc>().add(
                                UpdateUserEvent(
                                  id: widget.argument!['id'],
                                  name: nameController.text,
                                  userName: accountController.text,
                                  phone: phoneController.text,
                                  email: emailController.text,
                                  role: roleMap[roleController.text] ?? 'user',
                                  countryCode: countryCode,
                                  status: '',
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
