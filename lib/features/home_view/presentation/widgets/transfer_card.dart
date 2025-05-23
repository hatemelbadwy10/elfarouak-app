import 'package:elfarouk_app/features/transfers/domain/entity/transfer_entity.dart';
import 'package:flutter/material.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app_routing/route_names.dart';

class TransferCard extends StatelessWidget {

  final bool isSender;
  final TransferEntity transfer;

  const TransferCard({
    super.key,

    required this.isSender,
    required this.transfer
  });

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('عرض'),
              onTap: () {
                Navigator.pop(context);
                getIt<NavigationService>().navigateTo(RouteNames.singleTransferView);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('إلغاء'),
              onTap: () {
                Navigator.pop(context);
                // تنفيذ إلغاء
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('تأكيد'),
              onTap: () {
                Navigator.pop(context);
                // تنفيذ تأكيد
              },
            ),
            ListTile(
              leading: const Icon(Icons.attachment),
              title: const Text('تأكيد وإضافة مرفق'),
              onTap: () {
                Navigator.pop(context);
                // تنفيذ تأكيد + مرفق
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل حوالة'),
              onTap: () {
                Navigator.pop(context);
                // تنفيذ تعديل
              },
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    // Ensure the phone number is formatted correctly
    final phoneUrl = 'tel:$phoneNumber';

    if (await  canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber)); // Launch the phone dialer
      print("Calling $phoneNumber");
    } else {
      print("Could not initiate call to $phoneNumber");
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final icon = isSender
        ? const Icon(Icons.arrow_upward, color: Colors.red)
        : const Icon(Icons.arrow_downward, color: Colors.green);

    return GestureDetector(
      onTap: (){
        getIt<NavigationService>().navigateTo(RouteNames.singleTransferView, arguments: {
          //'transfer_id': transfer.,
          "transfer":transfer,

        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSender ? Colors.red[50] : Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: icon,
              ),
              const SizedBox(width: 12),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اسم المرسل: ${transfer.senderName}',
                      style: Styles.text18,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اسم المستلم: ${transfer.receiverName}',
                      style: Styles.text18,
                    ),
                    const SizedBox(height: 6),
                    Text("المبلغ: ${transfer.amountReceived}", style: Styles.text18Accent),
                    const SizedBox(height: 6),
                    Text("العنوان: ${transfer.address}", style: Styles.text15),
                  ],
                ),
              ),

              // Action buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () => _makePhoneCall(transfer.phone ?? ""),
                    tooltip: 'اتصال',
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showOptions(context),
                    tooltip: 'خيارات',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
