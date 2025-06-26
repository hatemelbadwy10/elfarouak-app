
import 'package:flutter/material.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/transfer_card.dart';
import '../../../transfers/domain/entity/transfer_entity.dart';

class TransferListWidget extends StatelessWidget {
  final List<TransferEntity> transfers;
  final bool isLoadingMore;
  final double rate;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final void Function()? onCardPress;

  const TransferListWidget({
    super.key,
    required this.transfers,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onRefresh,
    required this.rate,
    required this.onCardPress,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        itemCount: transfers.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == transfers.length && isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final transfer = transfers[index];
          return TransferCard(
            exchangeFee: rate,
            isSender: true,
            isHome: true,
            transfer: transfer,
            onPress: onCardPress,
          );
        },
      ),
    );
  }
}
