import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../../home_view/presentation/widgets/transfer_card.dart';
import '../../domain/entity/transfer_entity.dart';
import '../controller/transfer_bloc.dart';
import '../widgets/filter_widget.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحويلات'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (dialogContext) => BlocProvider.value(
                    value: BlocProvider.of<TransferBloc>(context),
                    child:  const FilterDialog(),
                  ),
                );
              },
            )
          ],
          ),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
          // Handle success or failure of transfer actions
          if (state is StoreTransferSuccess) {
            getIt<NavigationService>().navigateToAndReplace(RouteNames.transfersView);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة التحويل بنجاح')),
            );
          } else if (state is StoreTransferFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ أثناء إضافة التحويل: ${state.errMessage}')),
            );
          }
        },
        builder: (context, state) {
          if (state is GetTransfersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetTransfersFailure) {
            return Center(child: Text('حدث خطأ: ${state.errMessage}'));
          } else if (state is GetTransfersSuccess) {
            final List<TransferEntity> transfers = state.list;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transfers.length,
              itemBuilder: (context, index) {
                final transfer = transfers[index];

                return GestureDetector(
                  onTap: () {
                    getIt<NavigationService>().navigateTo(RouteNames.singleTransferView, arguments: {
                      //'transfer_id': transfer.,
                      "transfer":state.list[index],
                      'sender_name': transfer.senderName,
                      'receiver_name': transfer.receiverName,
                      'amount': transfer.amountReceived,
                      'status': 'pending',
                    });
                  },
                  child: TransferCard(
                    isSender: true,
                   transfer:transfer,
                  ),
                );
              },
            );
          } else {
            return const SizedBox(); // fallback if no state
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getIt<NavigationService>().navigateTo(RouteNames.addTransferView);
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة تحويل',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
