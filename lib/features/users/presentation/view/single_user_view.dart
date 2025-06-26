import 'package:flutter/material.dart';
import '../../../../core/utils/styles.dart';

class SingleUserView extends StatelessWidget {
  final Map<String, dynamic>? argument;

  const SingleUserView({super.key, this.argument});

  @override
  Widget build(BuildContext context) {
    final name = argument?['name'] ?? 'الاسم غير متوفر';
    final role = argument?['user_role'] ?? 'الدور غير متوفر';
    final address = argument?['user_address'] ?? 'العنوان غير متوفر';
    final phone = argument?['user_phone'] ?? 'غير متوفر';
    final country = _getCountryName(argument?['user_country'] ?? 'EG');

    return Scaffold(
      appBar: AppBar(title: const Text('بيانات المستخدم')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItem(label: 'الاسم', value: name, icon: Icons.person),
                const SizedBox(height: 12),
                _buildItem(label: 'الدور', value: role, icon: Icons.badge),
                const SizedBox(height: 12),
                _buildItem(label: 'رقم الهاتف', value: phone, icon: Icons.phone),
                const SizedBox(height: 12),
                _buildItem(label: 'العنوان', value: address, icon: Icons.location_on),
                const SizedBox(height: 12),
                _buildItem(label: 'الدولة', value: country, icon: Icons.flag),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({required String label, required String value, required IconData icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Styles.text14Medium.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value, style: Styles.text16SemiBold),
            ],
          ),
        ),
      ],
    );
  }

  String _getCountryName(String code) {
    switch (code) {
      case 'eg':
        return 'مصر';
      case 'ly':
        return 'ليبيا';
      default:
        return 'غير معروف';
    }
  }
}
