import 'dart:developer';

import 'package:flutter/material.dart';
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
                _buildItem("رقم الحواله",
                    transfer.id != null ? "${transfer.id}" : '—'),
                _buildItem(
                    '📅 التاريخ:',
                    transfer.transferCreatedAt != null
                        ? transfer.transferCreatedAt!
                        : '—'),
                _buildItem('👤 اسم المرسل:', transfer.senderName ?? '—'),
                _buildItem("اسم المندوب""👤", transfer.sellerSenderName ?? "_"),
                _buildItem(
                    "اسم العميل المستلم""👤", transfer.sellerSenderName ?? "_"),
                _buildItem('📦 الكمية المرسلة:', transfer.amountSent ?? '—'),
                _buildItem(
                    '💸 الكمية المستلمة:', transfer.amountReceived ?? '—'),
                _buildItem(
                    '🎯 سعر الصرف:', transfer.exchangeRateWithFee ?? '—'),
                _buildItem('🎯الفرع:',
                    transfer.cashBoxId == "1" ? "ليبيا" : "مصر" ?? '—'),
                _buildItem('🏢 اسم المستلم:', transfer.receiverName ?? '—'),
                _buildItem('🔁 نوع التحويل:', transfer.transferType ?? '—'),
                _buildItem('📞 الهاتف:', transfer.phone ?? '—'),
                _buildItem(
                    '📝 ملاحظات:',
                    transfer.note?.isNotEmpty == true
                        ? transfer.note!
                        : 'لا يوجد'),
                if (transfer.image != null && transfer.image!.isNotEmpty) ...[
                  SizedBox(
                    height: 250,
                    child: Image.network(
                      transfer.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('الصورة غير متوفرة'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  Container(
                    height: 250,
                    color: Colors.grey[100],
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('لا توجد صورة'),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                CustomButton(
                  text: 'تعديل',
                  onPressed: () {
                    // Navigate to AddTransferView with transfer data
                    getIt<NavigationService>().navigateTo(
                      RouteNames.addTransferView,
                      arguments: {
                        'transfer': transfer,
                        'id': transfer.id,
                        "exchange_fee": argument['exchange_fee']
                      },
                    );
                  },
                ),
              ],
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
