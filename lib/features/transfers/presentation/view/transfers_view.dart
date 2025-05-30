import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_routing/route_names.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/services/services_locator.dart';
import '../../../home_view/presentation/widgets/transfer_card.dart';
import '../../domain/entity/transfer_entity.dart';
import '../controller/transfer_bloc.dart';
import '../widgets/filter_widget.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key, required this.argument});

  final Map<String, dynamic> argument;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if we're near the bottom of the list (within 200 pixels)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<TransferBloc>().state;
      if (state is GetTransfersSuccess &&
          !state.hasReachedEnd &&
          !state.isLoadingMore) {
        log('state ${state.status}');
        log('state ${state.dateRange}');
        log('state ${state.search}');
        log('state ${state.transferType}');

        // Get current filters (you might need to store these in your widget state)
        context.read<TransferBloc>().add(
              LoadMoreTransfersEvent(
                  status: state.status,
                dateRange: state.dateRange,
                search: state.search,
                transferType: state.transferType

              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحويلات'),
        actions: [
          IconButton(onPressed: (){
            context.read<TransferBloc>().add(GetTransfersEvent());
          }, icon: const Icon(Icons.lock_reset)),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (dialogContext) => BlocProvider.value(
                  value: BlocProvider.of<TransferBloc>(context),
                  child: const FilterDialog(),
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
            getIt<NavigationService>()
                .navigateToAndReplace(RouteNames.transfersView);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم إضافة التحويل بنجاح')),
            );
          } else if (state is StoreTransferFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('حدث خطأ أثناء إضافة التحويل: ${state.errMessage}')),
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

            if (transfers.isEmpty) {
              return const Center(child: Text('لا توجد تحويلات'));
            }

            return RefreshIndicator(
              onRefresh: () async{
                context.read<TransferBloc>().add(GetTransfersEvent());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: transfers.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == transfers.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final transfer = transfers[index];

                  return GestureDetector(
                    onTap: () {
                      getIt<NavigationService>()
                          .navigateTo(RouteNames.singleTransferView, arguments: {
                        "transfer": state.list[index],
                        'sender_name': transfer.senderName,
                        'receiver_name': transfer.receiverName,
                        'amount': transfer.amountReceived,
                        'status': 'pending',
                        "exchange_fee": state.rate
                      });
                    },
                    child: TransferCard(
                      exchangeFee: state.rate,
                      isSender: true,
                      transfer: transfer,
                    ),
                  );
                },
              ),
            );
          } else {
            return const SizedBox(); // fallback if no state
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('exchange_fee${widget.argument['exchange_fee']}');
          getIt<NavigationService>().navigateTo(RouteNames.addTransferView,
              arguments: {"exchange_fee": widget.argument['exchange_fee']});
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة تحويل',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
