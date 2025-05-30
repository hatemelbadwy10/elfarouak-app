import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/quick_action_widget.dart';
import 'package:elfarouk_app/features/transfers/domain/entity/transfer_entity.dart';
import 'package:elfarouk_app/features/transfers/presentation/controller/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/image_picker.dart';

class TransferCard extends StatefulWidget {
  final bool isSender;
  final TransferEntity transfer;
  final double exchangeFee;
  final bool? isHome;
  final void Function()? onPress;

  const TransferCard({
    super.key,
    required this.isSender,
    required this.transfer,
    required this.exchangeFee,
    this.isHome,
    this.onPress
  });

  @override
  State<TransferCard> createState() => _TransferCardState();
}

class _TransferCardState extends State<TransferCard> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.transfer.status ?? '';
  }

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
                getIt<NavigationService>().navigateTo(
                  RouteNames.singleTransferView,
                  arguments: {
                    "transfer": widget.transfer,
                    "exchange_fee": widget.exchangeFee
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attachment),
              title: const Text('تأكيد وإضافة مرفق'),
              onTap: () async {
                final imagePickerService = ImagePickerService();
                final File? pickedImage =
                    await imagePickerService.pickImageFromGallery();

                if (pickedImage != null) {
                  context.read<TransferBloc>().add(
                      UpdateImage(id: widget.transfer.id!, image: pickedImage));
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل حوالة'),
              onTap: () {
                getIt<NavigationService>().navigateTo(
                  RouteNames.addTransferView,
                  arguments: {
                    "transfer": widget.transfer,
                    "exchange_fee": widget.exchangeFee,
                    "id": widget.transfer.id
                  },
                );
              },
            ),
            ListTile(
              title: const Text('حذف الحواله'),
              onTap: () {
                context
                    .read<TransferBloc>()
                    .add(DeleteTransferEvent(id: widget.transfer.id!));
              },
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    log('Trying to call: $phoneUri');
    log('canLaunchUrl ${await canLaunchUrl(phoneUri)}');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      log('Cannot launch phone call to $phoneUri');
    }
  }

  void _updateStatus(String newStatus) {
    setState(() {
      status = newStatus;
    });

    context.read<TransferBloc>().add(
      UpdateStatus(status: newStatus, id: widget.transfer.id!),
    );

    if (widget.isHome == true && widget.onPress != null) {
      widget.onPress!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.isSender
        ? const Icon(Icons.arrow_upward, color: Colors.red)
        : const Icon(Icons.arrow_downward, color: Colors.green);

    return GestureDetector(
      onTap: () {
        getIt<NavigationService>().navigateTo(
          RouteNames.singleTransferView,
          arguments: {
            "transfer": widget.transfer,
            "exchange_fee": widget.exchangeFee
          },
        );
      },
      child: Slidable(
        key: ValueKey(widget.transfer.id),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _updateStatus('completed'),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'تأكيد',
            ),
            SlidableAction(
              onPressed: (_) => _updateStatus('cancelled'),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.close,
              label: 'إلغاء',
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isSender ? Colors.red[50] : Colors.green[50],
                    shape: BoxShape.circle,
                  ),
                  child: icon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('رقم الحواله: ${widget.transfer.id}',
                          style: Styles.text18),
                      Text('اسم المرسل: ${widget.transfer.senderName}',
                          style: Styles.text18),
                      const SizedBox(height: 4),
                      Text('اسم المستلم: ${widget.transfer.receiverName}',
                          style: Styles.text18),
                      const SizedBox(height: 6),
                      Text("المبلغ: ${widget.transfer.amountReceived}",
                          style: Styles.text18Accent),
                      const SizedBox(height: 6),
                      Text(
                          "الفرع: ${widget.transfer.cashBoxId == "1" ? "ليبيا" : "مصر"}",
                          style: Styles.text18Accent),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (widget.transfer.tagName != null &&
                              widget.transfer.tagName!.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.transfer.tagName!,
                                style: Styles.text13.copyWith(
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          if ((widget.transfer.tagName?.isNotEmpty ?? false) &&
                              status.isNotEmpty)
                            const SizedBox(width: 8),
                          if (status.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                status,
                                style:
                                    Styles.text13.copyWith(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone),
                      onPressed: () {
                        _makePhoneCall(widget.transfer.phone ?? "");
                      },
                      tooltip: 'اتصال',
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _showOptions(context),
                      tooltip: 'خيارات',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'تم':
        return Colors.green;
      case 'pending':
      case 'قيد الانتظار':
        return Colors.orange;
      case 'cancelled':
      case 'ملغاة':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
