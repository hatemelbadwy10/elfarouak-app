import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
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

        context.read<TransferBloc>().add(
              LoadMoreTransfersEvent(
                status: state.status,
                dateRange: state.dateRange,
                search: state.search,
                transferType: state.transferType,
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
          IconButton(
            onPressed: () {
              context.read<TransferBloc>().add(GetTransfersEvent());
            },
            icon: const Icon(Icons.lock_reset),
          ),
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
          ),
        ],
      ),
      body: BlocConsumer<TransferBloc, TransferState>(
        listener: (context, state) {
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
                    Text('حدث خطأ أثناء إضافة التحويل: ${state.errMessage}'),
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<TransferBloc>().add(GetTransfersEvent());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                              final isNumeric =
                                  RegExp(r'^\d+$').hasMatch(value.trim());
                              if (isNumeric) {
                                context
                                    .read<TransferBloc>()
                                    .add(GetTransfersEvent(search: value));
                              } else {
                                if (_searchController.text.length > 2) {
                                  context
                                      .read<TransferBloc>()
                                      .add(GetTransfersEvent(search: value));
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'ابحث عن تحويل',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_searchController.text.isNotEmpty) {
                              context
                                  .read<TransferBloc>()
                                  .add(GetTransfersEvent());
                              _searchController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          },
                          icon: const FaIcon(FontAwesomeIcons.eraser),
                        )
                      ],
                    ),
                  ),
                ),
                if (state is GetTransfersLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is GetTransfersFailure)
                  SliverFillRemaining(
                    child: Center(child: Text('حدث خطأ: ${state.errMessage}')),
                  )
                else if (state is GetTransfersSuccess)
                  state.list.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(child: Text('لا توجد تحويلات')),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == state.list.length &&
                                  state.isLoadingMore) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              final transfer = state.list[index];

                              return GestureDetector(
                                onTap: () {
                                  getIt<NavigationService>().navigateTo(
                                    RouteNames.singleTransferView,
                                    arguments: {
                                      "transfer": transfer,
                                      'sender_name': transfer.senderName,
                                      'receiver_name': transfer.receiverName,
                                      'amount': transfer.amountReceived,
                                      'status': 'pending',
                                      "exchange_fee": state.rate,
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TransferCard(
                                    exchangeFee: state.rate,
                                    isSender: true,
                                    transfer: transfer,
                                  ),
                                ),
                              );
                            },
                            childCount: state.list.length +
                                (state.isLoadingMore ? 1 : 0),
                          ),
                        )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          log('exchange_fee${widget.argument['exchange_fee']}');
          getIt<NavigationService>().navigateTo(
            RouteNames.addTransferView,
            arguments: {"exchange_fee": widget.argument['exchange_fee']},
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'إضافة تحويل',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTransferList(TransferState state) {
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
        onRefresh: () async {
          context.read<TransferBloc>().add(GetTransfersEvent());
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                getIt<NavigationService>().navigateTo(
                  RouteNames.singleTransferView,
                  arguments: {
                    "transfer": state.list[index],
                    'sender_name': transfer.senderName,
                    'receiver_name': transfer.receiverName,
                    'amount': transfer.amountReceived,
                    'status': 'pending',
                    "exchange_fee": state.rate,
                  },
                );
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
      return const SizedBox();
    }
  }
}
