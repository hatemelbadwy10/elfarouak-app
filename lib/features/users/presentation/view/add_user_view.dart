import 'package:flutter/material.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';

import '../../../../core/components/custom/custom_button.dart';
import '../../../../core/components/custom/custom_text_field.dart';

class AddUserView extends StatelessWidget {
  const AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();
    final countryController = TextEditingController();

    final roles = ['مدير', 'مشرف', 'موظف']; // قائمة الأدوار
    final countries = ['مصر', 'السعودية', 'الإمارات']; // قائمة البلدان

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('إضافة مستخدم'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'بيانات المستخدم',
                style: Styles.text18SemiBold,
              ),
              const SizedBox(height: 16),
              // اسم المستخدم
              CustomTextField(
                hintText: 'الاسم الكامل',
                controller: nameController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // رقم الهاتف
              CustomTextField(
                hintText: 'رقم الهاتف',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // كلمة المرور
              CustomTextField(
                hintText: 'كلمة المرور',
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // الدور
              DropdownButtonFormField<String>(
                value: roles.first,
                onChanged: (value) {
                  roleController.text = value ?? roles.first;
                },
                decoration: InputDecoration(
                  labelText: 'الدور',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                items: roles
                    .map((role) => DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // البلد
              DropdownButtonFormField<String>(
                value: countries.first,
                onChanged: (value) {
                  countryController.text = value ?? countries.first;
                },
                decoration: InputDecoration(
                  labelText: 'البلد',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
                items: countries
                    .map((country) => DropdownMenuItem<String>(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
              ),
              Spacer(),
              // زر الإضافة
              CustomButton(
                text: 'إضافة المستخدم',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
