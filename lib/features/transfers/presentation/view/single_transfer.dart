import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/styles.dart';

class SingleTransferView extends StatelessWidget {
  const SingleTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل التحويل')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildItem(
                    icon: Icons.calendar_today,
                    label: 'التاريخ',
                    value: DateFormat('yyyy-MM-dd').format(DateTime.now())),
                _buildItem(
                    icon: Icons.person,
                    label: 'اسم المستخدم',
                    value: 'أحمد محمد'),
                _buildItem(
                    icon: Icons.inventory_2, label: 'الكمية', value: '25'),
                _buildItem(
                    icon: Icons.attach_money, label: 'السعر', value: '150'),
                _buildItem(icon: Icons.send, label: 'إلى', value: 'شركة X'),
                _buildItem(
                    icon: Icons.compare_arrows,
                    label: 'نوع العملية',
                    value: 'خصم'),
                _buildItem(
                    icon: Icons.emoji_events,
                    label: 'الفائدة',
                    value: 'مكافأة'),
                _buildItem(
                    icon: Icons.phone,
                    label: 'رقم الهاتف',
                    value: '01012345678'),
                _buildItem(
                    icon: Icons.location_on,
                    label: 'العنوان',
                    value: 'القاهرة - مصر'),
                _buildItem(
                    icon: Icons.note,
                    label: 'ملاحظات',
                    value: 'تم التسليم بنجاح.'),
                const SizedBox(height: 20),
                CustomButton(text: 'تعديل', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Styles.text13.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text(value, style: Styles.text18SemiBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
