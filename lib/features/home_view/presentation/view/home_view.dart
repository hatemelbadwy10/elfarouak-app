import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/add_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/drawer_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/quick_action_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/transfer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom/custom_button.dart';
import '../../../transfers/presentation/controller/transfer_bloc.dart';
import '../../../transfers/presentation/widgets/search_text_field.dart';
import '../widgets/CustomerTransferBottomSheet.dart';
import '../widgets/balance_card_widget.dart';
import '../widgets/send_money_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  // Store initial data separately to prevent changes during pagination
  double? _initialRate;
  dynamic _initialTotalBalance;
  dynamic _initialTotalTransfers;
  dynamic _initialTotalAmount;
  bool _hasLoadedInitialData = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
    _loadInitialData();
  }

  void _loadInitialData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    final dateRange =
        '${formatter.format(yesterday)} - ${formatter.format(today)}';

    context.read<TransferBloc>().add(GetTransfersEvent(
        status: "pending", dateRange: dateRange, isHome: true));
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        // Load more when user reaches 80% of the scroll
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        final dateRange =
            '${formatter.format(yesterday)} - ${formatter.format(today)}';
        final state = context.read<TransferBloc>().state;
        if (state is GetTransfersSuccess && !state.hasReachedEnd) {
          context.read<TransferBloc>().add(LoadMoreTransfersEvent(
                status: "pending",
                dateRange: dateRange,
              ));
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildNoDataWidget(double rate) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد حوالات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي حوالات حتى الآن',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              getIt<NavigationService>().navigateTo(RouteNames.addTransferView,
                  arguments: {"exchange_fee": rate});
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('إضافة حوالة جديدة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransfersList(GetTransfersSuccess state) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          // Reset initial data flags on refresh
          _hasLoadedInitialData = false;
          _initialRate = null;
          _initialTotalBalance = null;
          _initialTotalTransfers = null;
          _initialTotalAmount = null;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));

          final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
          final dateRange =
              '${formatter.format(yesterday)} - ${formatter.format(today)}';
          context.read<TransferBloc>().add(GetTransfersEvent(
              status: "pending", dateRange: dateRange, isHome: true));
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: state.list.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            // Show loading indicator at the end when loading more
            if (index == state.list.length) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }

            return TransferCard(
              exchangeFee: _initialRate ?? state.rate,
              isSender: true,
              isHome: true,
              transfer: state.list[index],
              onPress: () {
                log('transfer done');
                _hasLoadedInitialData = false;
                _initialRate = null;
                _initialTotalBalance = null;
                _initialTotalTransfers = null;
                _initialTotalAmount = null;

                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final yesterday = today.subtract(const Duration(days: 1));
                final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
                final dateRange =
                    '${formatter.format(yesterday)} - ${formatter.format(today)}';

                context.read<TransferBloc>().add(
                      GetTransfersEvent(
                        status: "pending",
                        dateRange: dateRange,
                      ),
                    );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        // Store initial data only on first successful load
        if (state is GetTransfersSuccess && !_hasLoadedInitialData) {
          _initialRate = state.rate;
          _initialTotalBalance = state.totalBalanceEgp;
          _initialTotalTransfers = state.totalTransfers;
          _initialTotalAmount = state.totalAmountReceived;
          _hasLoadedInitialData = true;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الفاروق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'سعر الدينار الليبي:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      _hasLoadedInitialData && _initialRate != null
                          ? '$_initialRate جنيه مصري'
                          : state is GetTransfersSuccess
                              ? '${state.rate} جنيه مصري'
                              : 'جاري التحديث...',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              AddWidget(
                rate: state is GetTransfersSuccess ? state.rate : 9,
              )
            ],
          ),
          drawer: Drawer(
              child: DrawerWidget(
            exchangeFee: _hasLoadedInitialData && _initialRate != null
                ? _initialRate!
                : state is GetTransfersSuccess
                    ? state.rate
                    : 0.0,
          )),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BlocBuilder<TransferBloc, TransferState>(
                      builder: (context, state) {
                        String balanceText;
                        if (_hasLoadedInitialData &&
                            _initialTotalBalance != null) {
                          balanceText = "$_initialTotalBalance";
                        } else if (state is GetTransfersLoading) {
                          balanceText = 'يتم التحميل';
                        } else if (state is GetTransfersSuccess) {
                          balanceText = "${state.totalBalanceEgp}";
                        } else {
                          balanceText = 'فشل';
                        }

                        return state is GetTransfersSuccess
                            ? state.showBox
                                ? BalanceCardWidget(
                                    label: "  إجمالي رصيد الفروع ",
                                    balance: balanceText,
                                    color: Colors.blue,
                                  )
                                : const SizedBox()
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuickActionWidget(
                      icon: Icons.compare_arrows,
                      label: "حوالة",
                      color: AppColors.primary,
                      onPress: () {
                        getIt<NavigationService>()
                            .navigateTo(RouteNames.addTransferView, arguments: {
                          "exchange_fee":
                              state is GetTransfersSuccess ? state.rate : "9.14"
                        });
                      },
                    ),
                    QuickActionWidget(
                      icon: Icons.account_balance_wallet,
                      label: "سحب أو إيداع",
                      color: Colors.green,
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String? selectedAction;
                            final TextEditingController balanceController =
                                TextEditingController();
                            final TextEditingController senderIdController =
                                TextEditingController();
                            int senderId = 1;
                            return BlocProvider(
                              create: (context) => TransferBloc(getIt()),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  bool isLoading = false;

                                  String? mapArabicActionToApiValue(
                                      String? value) {
                                    switch (value) {
                                      case 'إضافة':
                                        return 'add';
                                      case 'خصم':
                                        return 'subtract';
                                      case 'تعيين':
                                        return 'set';
                                      default:
                                        return null;
                                    }
                                  }

                                  return BlocListener<TransferBloc,
                                      TransferState>(
                                    listener: (context, state) {
                                      if (state
                                          is PartialUpdateCustomerLoading) {
                                        setState(() => isLoading = true);
                                      } else {
                                        setState(() => isLoading = false);
                                      }

                                      if (state
                                          is PartialUpdateCustomerSuccess) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(state.message)),
                                        );
                                        Navigator.of(context)
                                            .pop(); // Close dialog on success
                                      } else if (state
                                          is PartialUpdateCustomerFailure) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(state.errMessage)),
                                        );
                                        // Stay in dialog on failure
                                      }
                                    },
                                    child: AlertDialog(
                                      title: const Text('إضافة عملية'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SearchTextField(
                                              label: 'المرسل',
                                              textEditingController:
                                                  senderIdController,
                                              listType: "customer",
                                              onSuggestionSelected:
                                                  (suggestion) {
                                                senderId = suggestion.id;
                                                log("senderId${suggestion.id}");
                                                log("senderId$senderId");
                                                senderIdController.text =
                                                    suggestion.label;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                  labelText: 'نوع العملية'),
                                              value: selectedAction,
                                              items: const [
                                                DropdownMenuItem(
                                                    value: 'إضافة',
                                                    child: Text('إضافة')),
                                                DropdownMenuItem(
                                                    value: 'خصم',
                                                    child: Text('خصم')),
                                                DropdownMenuItem(
                                                    value: 'تعيين',
                                                    child: Text('تعيين')),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedAction = value;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: balanceController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  labelText: 'الرصيد'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        CustomButton(
                                          isLoading: isLoading,
                                          text: 'تنفيذ',
                                          onPressed: () {
                                            final balance = double.tryParse(
                                                balanceController.text);

                                            if (selectedAction == null ||
                                                balance == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'يرجى إدخال كل البيانات: المرسل، نوع العملية، الرصيد'),
                                                ),
                                              );
                                              return;
                                            }

                                            final apiTransferType =
                                                mapArabicActionToApiValue(
                                                    selectedAction);

                                            if (apiTransferType == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'نوع العملية غير صحيح'),
                                                ),
                                              );
                                              return;
                                            }
                                            log('senderId$senderId');
                                            context.read<TransferBloc>().add(
                                                  PartialUpdateCustomerEvent(
                                                    customerId: senderId,
                                                    balance: balance,
                                                    transferType:
                                                        apiTransferType,
                                                  ),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    QuickActionWidget(
                      icon: Icons.send_rounded,
                      label: "إرسال أموال",
                      color: Colors.orange,
                      onPress: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => BlocProvider(
                            create: (context) => TransferBloc(getIt()),
                            child: const SendMoneySheet(),
                          ),
                        );
                      },
                    ),
                    QuickActionWidget(
                      icon: Icons.person,
                      label: "تحويل بين العملاء",
                      color: AppColors.primary,
                      onPress: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => BlocProvider(
                            create: (context) => TransferBloc(getIt()),
                            child: const CustomerTransferBottomSheet(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'آخر الحوالات (${_hasLoadedInitialData && _initialTotalTransfers != null ? _initialTotalTransfers : state is GetTransfersSuccess ? state.totalTransfers : 0})',
                          style: Styles.text18SemiBold,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'الإجمالي: ${_hasLoadedInitialData && _initialTotalAmount != null ? _initialTotalAmount : state is GetTransfersSuccess ? state.totalAmountReceived : 0} جنيه',
                          style: Styles.text13.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          final rate =
                              _hasLoadedInitialData && _initialRate != null
                                  ? _initialRate!
                                  : state is GetTransfersSuccess
                                      ? state.rate
                                      : 0.0;

                          getIt<NavigationService>()
                              .navigateTo(RouteNames.transfersView, arguments: {
                            "exchange_fee": rate,
                          });
                        },
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _hasLoadedInitialData = false;
                                  _initialRate = null;
                                  _initialTotalBalance = null;
                                  _initialTotalTransfers = null;
                                  _initialTotalAmount = null;

                                  final now = DateTime.now();
                                  final today =
                                      DateTime(now.year, now.month, now.day);
                                  final yesterday =
                                      today.subtract(const Duration(days: 1));

                                  final formatter =
                                      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
                                  final dateRange =
                                      '${formatter.format(yesterday)} - ${formatter.format(today)}';
                                  context
                                      .read<TransferBloc>()
                                      .add(GetTransfersEvent(
                                        status: "pending",
                                        dateRange: dateRange,
                                      ));
                                },
                                icon: const Icon(Icons.refresh)),
                            Text(
                              'عرض الكل',
                              style: Styles.sectionTitle.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Styles.text13.color,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Transfers section with states handling
                if (state is GetTransfersLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is GetTransfersSuccess)
                  state.list.isEmpty
                      ? Expanded(child: _buildNoDataWidget(state.rate))
                      : _buildTransfersList(state)
                else if (state is GetTransfersFailure)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'حدث خطأ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.errMessage,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Reset initial data flags on retry
                              _hasLoadedInitialData = false;
                              _initialRate = null;
                              _initialTotalBalance = null;
                              _initialTotalTransfers = null;
                              _initialTotalAmount = null;

                              final now = DateTime.now();
                              final today =
                                  DateTime(now.year, now.month, now.day);
                              final yesterday =
                                  today.subtract(const Duration(days: 1));

                              final formatter =
                                  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
                              final dateRange =
                                  '${formatter.format(yesterday)} - ${formatter.format(today)}';
                              context
                                  .read<TransferBloc>()
                                  .add(GetTransfersEvent(
                                    status: "pending",
                                    dateRange: dateRange,
                                    isHome: true,
                                  ));
                            },
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
