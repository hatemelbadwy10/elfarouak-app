import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/domain/entity/cash_box_transfer_entity.dart';

import '../controller/cash_box_transfer_bloc.dart';
import '../controller/cash_box_transfer_state.dart';


class CashBoxTransferView extends StatelessWidget {
  const CashBoxTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحويلات الصناديق')),
      body: BlocBuilder<CashBoxTransferBloc, CashBoxTransferState>(
        builder: (context, state) {
          if (state is CashBoxTransferLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CashBoxTransferError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          } else if (state is CashBoxTransferLoaded) {
            if (state.transfers.isEmpty) {
              return const Center(child: Text('لا توجد تحويلات حالياً.'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.transfers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final transfer = state.transfers[index];
                return _TransferCard(transfer: transfer);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TransferCard extends StatelessWidget {
  final CashBoxTransferEntity transfer;

  const _TransferCard({required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('🟢 من:', transfer.fromCashBoxId),
            _infoRow('🔵 إلى:', transfer.toCashBoxId),
            _infoRow('💰 المبلغ:', '${transfer.amount} ج.م'),
            if (transfer.note != null && transfer.note!.isNotEmpty)
              _infoRow('📝 ملاحظة:', transfer.note!),
            const Divider(height: 20),
            _infoRow('👤 أنشئ بواسطة:', transfer.creator),
            _infoRow('📅 تاريخ الإنشاء:', transfer.transferCreatedAt),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
