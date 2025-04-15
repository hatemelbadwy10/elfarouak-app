import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/add_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary, // اللون الأزرق
        title: const Text('الفاروق'), // اسم التطبيق
        actions: const [AddWidget()],
      ),
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      body: const Center(
        child: Text('مرحبًا بك في تطبيق الفاروق'),
      ),
    );
  }
}
