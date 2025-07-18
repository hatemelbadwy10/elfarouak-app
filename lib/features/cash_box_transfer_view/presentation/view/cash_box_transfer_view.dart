import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/domain/entity/cash_box_transfer_entity.dart';
import '../controller/cash_box_transfer_bloc.dart';
import '../controller/cash_box_transfer_event.dart';
import '../controller/cash_box_transfer_state.dart';

class CashBoxTransferView extends StatelessWidget {
  const CashBoxTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحويلات الصناديق')),
      body: BlocConsumer<CashBoxTransferBloc, CashBoxTransferState>(
        listener: (context, state) {
          if (state is CashBoxTransferCompleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ ${"تم تعديل الحواله بنجاح"}')),
            );
            // Reload the list
            context.read<CashBoxTransferBloc>().add(GetCashBoxTransferEvent());
          }

          if (state is CashBoxTransferCompleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is CashBoxTransferLoading ||
              state is CashBoxTransferCompleteLoading) {
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
                return _TransferCard(
                  transfer: transfer,
                  onComplete: () {
                    context.read<CashBoxTransferBloc>().add(
                          CompleteCashBoxTransferEvent(transfer.id),
                        );
                  },
                );
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
  final VoidCallback? onComplete;

  const _TransferCard({
    required this.transfer,
    this.onComplete,
  });

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'completed':
        return 'مكتمل';
      default:
        return status ?? 'قيد الانتظار';
    }
  }
  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (_) {
      return rawDate; // fallback in case of parsing error
    }
  }
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
            _infoRow(
                '💰 المبلغ:', '${transfer.amount} '),
            _infoRow('🔄 السعر المحول:', transfer.exchangeRate),
            _infoRow('💱 بعد التحويل:', "${transfer.convertedAmount} ${transfer.currency ?? ''}"),
            _infoRow('📌 الحالة:', _getStatusLabel(transfer.status)),

            if (transfer.note != null && transfer.note!.isNotEmpty)
              _infoRow('📝 ملاحظة:', transfer.note!),

            const Divider(height: 20),

            _infoRow('👤 أنشئ بواسطة:', transfer.creator),
            _infoRow('📅 تاريخ الإنشاء:', formatDate(transfer.transferCreatedAt)),

            // Action button only if status is pending
            if (transfer.status == 'قيد الانتظار') ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onComplete,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('إكمال التحويل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
