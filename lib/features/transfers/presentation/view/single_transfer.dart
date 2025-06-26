import 'package:elfarouk_app/features/transfers/presentation/controller/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/styles.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../domain/entity/transfer_entity.dart';

class SingleTransferScreen extends StatefulWidget {
  final Map<String, dynamic> argument;

  const SingleTransferScreen({super.key, required this.argument});

  @override
  State<SingleTransferScreen> createState() => _SingleTransferScreenState();
}

class _SingleTransferScreenState extends State<SingleTransferScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<TransferBloc>()
        .add(GetSingleTransferEvent(id: widget.argument['id']));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التحويل'),
      ),
      body: BlocBuilder<TransferBloc, TransferState>(
        builder: (context, state) {
          if (state is GetSingleTransferLoading) {
            return const TransferShimmer();
          } else if (state is GetSingleTransferSuccess) {
            final TransferEntity transfer =
          state.transferEntity;
            return SingleChildScrollView(
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
                      _buildItem(
                          "اسم المندوب" "👤", transfer.sellerSenderName ?? "_"),
                      _buildItem("اسم العميل المستلم" "👤",
                          transfer.sellerSenderName ?? "_"),
                      _buildItem(
                          '📦 الكمية المرسلة:', transfer.amountSent ?? '—'),
                      _buildItem('💸 الكمية المستلمة:',
                          transfer.amountReceived ?? '—'),
                      _buildItem(
                          '🎯 سعر الصرف:', transfer.exchangeRateWithFee ?? '—'),
                      _buildItem('🎯الفرع:',
                          transfer.cashBoxId == "1" ? "ليبيا" : "مصر" ?? '—'),
                      _buildItem(
                          '🏢 اسم المستلم:', transfer.receiverName ?? '—'),
                      _buildItem(
                          '🔁 نوع التحويل:', transfer.transferType ?? '—'),
                      _buildItem('📞 الهاتف:', transfer.phone ?? '—'),
                      _buildItem(
                          '📝 ملاحظات:',
                          transfer.note?.isNotEmpty == true
                              ? transfer.note!
                              : 'لا يوجد'),
                      if (transfer.image != null &&
                          transfer.image!.isNotEmpty) ...[
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
                                    Icon(Icons.broken_image,
                                        size: 50, color: Colors.grey),
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
                              Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey),
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
                              "exchange_fee": widget.argument['exchange_fee']
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is GetSingleTransferFailure) {
            return Text(state.errMessage);
          } else {
            return const SizedBox();
          }
        },
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

class TransferShimmer extends StatelessWidget {
  const TransferShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(10, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              })
                ..add(const SizedBox(height: 24))
                ..add(Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.white,
                )),
            ),
          ),
        ),
      ),
    );
  }
}
