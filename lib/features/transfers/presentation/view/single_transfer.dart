import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../domain/entity/transfer_entity.dart';

class SingleTransferScreen extends StatelessWidget {
  final Map<String, dynamic> argument;

  const SingleTransferScreen({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    final TransferEntity transfer = argument['transfer'] as TransferEntity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التحويل'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildItem('📅 التاريخ:', transfer.date != null
                    ? DateFormat('yyyy-MM-dd').format(transfer.date!)
                    : '—'),
                _buildItem('👤 اسم المرسل:', transfer.senderName ?? '—'),
                _buildItem('📦 الكمية المرسلة:', transfer.amountSent ?? '—'),
                _buildItem('💸 الكمية المستلمة:', transfer.amountReceived ?? '—'),
                _buildItem('🏢 اسم المستلم:', transfer.receiverName ?? '—'),
                _buildItem('🔁 نوع التحويل:', transfer.transferType ?? '—'),
                _buildItem('🎯 الفائدة:', transfer.transferTag ?? '—'),
                _buildItem('📞 الهاتف:', transfer.phone ?? '—'),
                _buildItem('📍 العنوان:', transfer.address ?? '—'),
                _buildItem('📝 ملاحظات:', transfer.note?.isNotEmpty == true ? transfer.note! : 'لا يوجد'),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'تعديل',
                  onPressed: () {
                    // Navigate to AddTransferView with transfer data
                    getIt<NavigationService>().navigateTo(
                      RouteNames.addTransferView,
                      arguments: {'transfer': transfer, 'id': transfer.id},
                    );

                  },
                ),              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Styles.text13.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: Styles.text13),
          ),
        ],
      ),
    );
  }
}
