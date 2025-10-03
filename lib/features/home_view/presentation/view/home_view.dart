import 'dart:developer';
import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/core/services/navigation_service.dart';
import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:elfarouk_app/core/utils/app_colors.dart';
import 'package:elfarouk_app/core/utils/extentios.dart';
import 'package:elfarouk_app/core/utils/styles.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/add_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/drawer_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/no_data_widget.dart';
import 'package:elfarouk_app/features/home_view/presentation/widgets/quick_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../user_info/user_info_bloc.dart';
import '../../../transfers/presentation/controller/transfer_bloc.dart';
import '../../../transfers/presentation/widgets/branch_balance_widget.dart';
import '../widgets/balance_card_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/partial_update_widget.dart';
import '../widgets/send_money_sheet.dart';
import '../widgets/transfer_list_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  dynamic? _initialRate;
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
    final dateRange = DateTime.now().yesterdayToTodayRange();
    context.read<TransferBloc>().add(GetTransfersEvent(
        status: "pending", dateRange: dateRange, isHome: true));
  }

  void _setupScrollController() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        final dateRange = DateTime.now().yesterdayToTodayRange();
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

  void _refreshTransfers() {
    log('transfer refresh');
    _hasLoadedInitialData = false;
    _initialRate = null;
    _initialTotalBalance = null;
    _initialTotalTransfers = null;
    _initialTotalAmount = null;

    final dateRange = DateTime.now().yesterdayToTodayRange();

    context.read<TransferBloc>().add(
          GetTransfersEvent(
            status: "pending",
            dateRange: dateRange,
            isHome: true,
          ),
        );
  }

  Future<void> _onRefreshTransfers() async {
    _refreshTransfers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildBranchBalanceSection() {
    return BlocBuilder<TransferBloc, TransferState>(
      builder: (context, state) {
        if (state is GetTransfersLoading) {
          return Container(
            height: 80,
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text(
                  'يتم التحميل...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is GetTransfersSuccess && state.showBox) {
          final totalBalanceText = "${state.totalBalanceEgp ?? '0'}";
          final cashBoxes = state.cashBoxes;
          final isAdmin =
              context.read<UserInfoBloc>().state.user?.role == "admin";

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'أرصدة الفروع',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // إجمالي الرصيد - للمشرف فقط
                if (isAdmin) ...[
                  BalanceCardWidget(
                    label: "💰 إجمالي رصيد الفروع",
                    balance: totalBalanceText,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                ],

                // بطاقات الفروع الفردية
                if (cashBoxes.isNotEmpty) ...[
                  if (isAdmin) const Divider(height: 1, color: Colors.grey),
                  if (isAdmin) const SizedBox(height: 12),

                  // Responsive wrap layout using LayoutBuilder
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.maxWidth - 24) / 2;

                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: cashBoxes.map((box) {
                          return SizedBox(
                            width: cardWidth,
                            child: BranchBalanceCard(
                              totalBalance: box.totalBalance,
                              expense: box.expenses,
                              name: box.name,
                              branchBalance: box.balance.toString(),
                              customerBalance: box.customersBalance.toString(),
                              currency: box.currency,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ] else ...[
                  // No branches message
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'لا توجد فروع',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildQuickActionsSection(TransferState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make responsive: 2 actions per row on mobile, 4 on tablets
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth > 600;

        if (isTablet) {
          // Single row for tablets
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: QuickActionWidget(
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
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QuickActionWidget(
                  icon: Icons.account_balance_wallet,
                  label: "سحب أو إيداع",
                  color: Colors.green,
                  onPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => BlocProvider(
                        create: (context) => TransferBloc(getIt()),
                        child: const PartialUpdateDialog(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QuickActionWidget(
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
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QuickActionWidget(
                  icon: Icons.person,
                  label: "تحويل بين العملاء",
                  color: AppColors.primary,
                  onPress: () {
                    getIt<NavigationService>()
                        .navigateTo(RouteNames.customerTransfersView);
                  },
                ),
              ),
            ],
          );
        } else {
          // Two rows for mobile
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: QuickActionWidget(
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
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: QuickActionWidget(
                      icon: Icons.account_balance_wallet,
                      label: "سحب أو إيداع",
                      color: Colors.green,
                      onPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider(
                            create: (context) => TransferBloc(getIt()),
                            child: const PartialUpdateDialog(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (context.read<UserInfoBloc>().state.user?.role != "user")
                    Expanded(
                      child: QuickActionWidget(
                        icon: Icons.send_rounded,
                        label: "إرسال أموال",
                        color: Colors.orange,
                        onPress: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (_) => BlocProvider(
                              create: (context) => TransferBloc(getIt()),
                              child: const SendMoneySheet(),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: QuickActionWidget(
                      icon: Icons.person,
                      label: "تحويل بين العملاء",
                      color: AppColors.primary,
                      onPress: () {
                        getIt<NavigationService>()
                            .navigateTo(RouteNames.customerTransfersView);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
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
          appBar: CustomMainAppBar(
            rate: state is GetTransfersSuccess ? state.rate : null,
            hasLoadedInitialData: _hasLoadedInitialData,
            initialRate: _initialRate,
            transferBloc: context.read<TransferBloc>(), onRefresh: _onRefreshTransfers,

          ),
          drawer: Drawer(
            child: DrawerWidget(
              exchangeFee: _hasLoadedInitialData && _initialRate != null
                  ? _initialRate!
                  : state is GetTransfersSuccess
                      ? state.rate
                      : 0.0,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Branch Balance Section - Made responsive
                  _buildBranchBalanceSection(),

                  const SizedBox(height: 20),

                  // Quick Actions Section - Made responsive
                  _buildQuickActionsSection(state),

                  const SizedBox(height: 24),

                  // Transfers Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _hasLoadedInitialData = false;
                              _initialRate = null;
                              _initialTotalBalance = null;
                              _initialTotalTransfers = null;
                              _initialTotalAmount = null;
                              final dateRange =
                                  DateTime.now().yesterdayToTodayRange();
                              context.read<TransferBloc>().add(
                                  GetTransfersEvent(
                                      status: "pending",
                                      dateRange: dateRange,
                                      isHome: true));
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          GestureDetector(
                            onTap: () {
                              final rate =
                                  _hasLoadedInitialData && _initialRate != null
                                      ? _initialRate!
                                      : state is GetTransfersSuccess
                                          ? state.rate
                                          : 0.0;

                              getIt<NavigationService>().navigateTo(
                                  RouteNames.transfersView,
                                  arguments: {
                                    "exchange_fee": rate,
                                  });
                            },
                            child: Text(
                              'عرض الكل',
                              style: Styles.sectionTitle.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: Styles.text13.color,
                                decorationThickness: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Transfers List - Made with fixed height to prevent overflow
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.4, // 40% of screen height
                    child: _buildTransfersContent(state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransfersContent(TransferState state) {
    if (state is GetTransfersLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is GetTransfersSuccess) {
      if (state.list.isEmpty) {
        return NoDataWidget(rate: state.rate);
      } else {
        return TransferListWidget(
          transfers: state.list,
          isLoadingMore: state.isLoadingMore,
          rate: _initialRate ?? state.rate,
          scrollController: _scrollController,
          onRefresh: _onRefreshTransfers,
          onCardPress: _refreshTransfers,
        );
      }
    } else if (state is GetTransfersFailure) {
      return Center(
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
                _hasLoadedInitialData = false;
                _initialRate = null;
                _initialTotalBalance = null;
                _initialTotalTransfers = null;
                _initialTotalAmount = null;

                final dateRange = DateTime.now().yesterdayToTodayRange();
                context.read<TransferBloc>().add(GetTransfersEvent(
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
      );
    }
    return const SizedBox();
  }
}
