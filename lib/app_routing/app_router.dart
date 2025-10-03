import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/app_routing/routing_data.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/presentation/controller/cash_box_transfer_bloc.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/presentation/controller/cash_box_transfer_event.dart';
import 'package:elfarouk_app/features/cash_box_transfer_view/presentation/view/cash_box_transfer_view.dart';
import 'package:elfarouk_app/features/cash_box_view/presentation/controller/cash_box_bloc.dart';
import 'package:elfarouk_app/features/cash_box_view/presentation/view/add_cash_box_view.dart';
import 'package:elfarouk_app/features/cash_box_view/presentation/view/cash_box_view.dart';
import 'package:elfarouk_app/features/customers/presentation/controller/customers_bloc.dart';
import 'package:elfarouk_app/features/customers/presentation/view/add_customer_view.dart';
import 'package:elfarouk_app/features/customers/presentation/view/customers_view.dart';
import 'package:elfarouk_app/features/expense/presentation/controller/expense_bloc.dart';
import 'package:elfarouk_app/features/expense/presentation/view/add_expense_view.dart';
import 'package:elfarouk_app/features/expense/presentation/view/expense_view.dart';
import 'package:elfarouk_app/features/expense/presentation/view/single_expense_view.dart';
import 'package:elfarouk_app/features/home_view/presentation/controller/home_bloc.dart';
import 'package:elfarouk_app/features/home_view/presentation/view/home_view.dart';
import 'package:elfarouk_app/features/login_screen/presentation/controller/login_bloc.dart';
import 'package:elfarouk_app/features/reports/presentation/controller/transfer_report_bloc.dart';
import 'package:elfarouk_app/features/reports/presentation/view/all_reports_view.dart';
import 'package:elfarouk_app/features/reports/presentation/view/customers_report_view.dart';
import 'package:elfarouk_app/features/transfers/presentation/controller/transfer_bloc.dart';
import 'package:elfarouk_app/features/transfers/presentation/view/add_transfer_view.dart';
import 'package:elfarouk_app/features/transfers/presentation/view/single_transfer.dart';
import 'package:elfarouk_app/features/transfers/presentation/view/transfers_view.dart';
import 'package:elfarouk_app/features/users/presentation/controller/user_bloc.dart';
import 'package:elfarouk_app/features/users/presentation/view/add_user_view.dart';
import 'package:elfarouk_app/features/users/presentation/view/single_user_view.dart';
import 'package:elfarouk_app/features/users/presentation/view/users_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/services_locator.dart';
import '../features/customers/presentation/view/single_customer_view.dart';
import '../features/debtor_customers/presentation/controller/debtor_customer_bloc.dart';
import '../features/debtor_customers/presentation/view/debtor_customer_view.dart';
import '../features/home_view/presentation/widgets/CustomerTransferBottomSheet.dart';
import '../features/login_screen/presentation/view/login_screen.dart';
import '../features/reports/presentation/view/cash_box_reports_report.dart';
import '../features/reports/presentation/view/transfers_report_view.dart';
import '../features/splahs_screen/view/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var uriData = Uri.parse(settings.name!);

    var routingData = RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );

    Map<String, dynamic> parameters = {};

    if (settings.arguments != null) {
      parameters = settings.arguments as Map<String, dynamic>;
    }

    switch (routingData.route) {
      case RouteNames.splashScreen:
        return _getPageRoute(const SplashScreen(), settings);

      case RouteNames.loginScreen:
        return _getPageRoute(
          BlocProvider(
              create: (_) => LoginBloc(getIt()), child: const LoginScreen()),
          settings,
        );
      case RouteNames.homeView:
        final now = DateTime.now();
        final today =
            DateTime(now.year, now.month, now.day); // today at 00:00:00
        final yesterday = today.subtract(const Duration(days: 1)); // day before

        final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        final todayRange =
            '${formatter.format(yesterday)} - ${formatter.format(today)}';

        log('todayRange $todayRange');

        return _getPageRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(
                create: (_) => HomeBloc(getIt()), // Initialize HomeBloc
              ),
              BlocProvider<TransferBloc>(
                create: (_) => TransferBloc(getIt())
                  ..add(GetTransfersEvent(
                      status: "pending",
                      dateRange: todayRange,
                      isHome: true)), // Use today
              ),
            ],
            child: const HomeView(),
          ),
          settings,
        );

      case RouteNames.addUserView:
        return _getPageRoute(
          BlocProvider(
            create: (_) => UserBloc(getIt()),
            child: AddUserView(argument: _getArguments(settings)),
          ),
          settings,
        );

      case RouteNames.addTransferView:
        return _getPageRoute(
          BlocProvider(
              create: (_) => TransferBloc(getIt()),
              child: AddTransferView(
                argument: _getArguments(settings),
              )),
          settings,
        );
        case RouteNames.transfersReport:
        return _getPageRoute(
            BlocProvider(
              create: (_) => TransferReportBloc(getIt()),
              child: const TransferReportScreen(),
            ),
            settings);

      case RouteNames.cashBoxesReport:
        return _getPageRoute(
            BlocProvider(
              create: (_) => TransferReportBloc(getIt()),
              child: const CashboxReportView(),
            ),
            settings);
      case RouteNames.reportsView:
        return _getPageRoute(
          const AllReportsView(),
          settings
        );
      case RouteNames.customersReport:
        return _getPageRoute(
            BlocProvider(
              create: (_) => TransferReportBloc(getIt()),
              child: const CustomersReportView(),
            ),
            settings);

      case RouteNames.transfersView:
        return _getPageRoute(
          BlocProvider(
              create: (context) =>
                  TransferBloc(getIt())..add(GetTransfersEvent()),
              child: TransferScreen(
                argument: _getArguments(settings) ?? {},
              )),
          settings,
        );
      case RouteNames.singleTransferView:
        return _getPageRoute(
          BlocProvider(
            create: (context) => TransferBloc(getIt()),
            child: SingleTransferScreen(argument: _getArguments(settings)!),
          ),
          settings,
        );
      case RouteNames.usersView:
        return _getPageRoute(
          BlocProvider(
            create: (context) => UserBloc(getIt())..add(GetUserEvent()),
            child: const UsersView(),
          ),
          settings,
        );
      case RouteNames.singleUsersView:
        return _getPageRoute(
          SingleUserView(
            argument: _getArguments(settings),
          ),
          settings,
        );
      case RouteNames.customerView:
        return _getPageRoute(
            BlocProvider(
                create: (context) =>
                    CustomersBloc(getIt())..add(GetCustomersEvent()),
                child: const CustomersView()),
            settings);
      case RouteNames.addCustomerView:
        return _getPageRoute(
            BlocProvider(
              create: (context) => CustomersBloc(getIt()),
              child: AddCustomerView(
                argument: _getArguments(settings),
              ),
            ),
            settings);
      case RouteNames.singleCustomerView:
        return _getPageRoute(
            BlocProvider(
              create: (context) => CustomersBloc(getIt()),
              child: SingleCustomerScreen(
                argument: _getArguments(settings)!,
              ),
            ),
            settings);
      case RouteNames.cashBoxView:
        return _getPageRoute(
            BlocProvider(
                create: (context) =>
                    CashBoxBloc(getIt())..add(GetCashBoxesEvent()),
                child: const CashBoxView()),
            settings);
      case RouteNames.customerTransfersView:
        return _getPageRoute(
            BlocProvider(
              create: (context) => TransferBloc(getIt()),
              child: const CustomerTransferScreen(),
            ),
            settings);
      case RouteNames.addCashBoxView:
        return _getPageRoute(
            BlocProvider(
              create: (context) => CashBoxBloc(getIt()),
              child: AddCashBoxView(
                argument: _getArguments(settings),
              ),
            ),
            settings);
      case RouteNames.expenseView:
        return _getPageRoute(
            BlocProvider(
              create: (context) =>
                  ExpenseBloc(getIt())..add(GetExpensesEvent()),
              child: const ExpenseView(),
            ),
            settings);
      case RouteNames.singleExpenseView:
        return _getPageRoute(
            SingleExpenseView(argument: _getArguments(settings)!), settings);
      case RouteNames.addExpenseView:
        return _getPageRoute(
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ExpenseBloc(getIt()),
                ),
                BlocProvider(
                  create: (context) => TransferBloc(getIt()),
                ),
              ],
              child: AddExpenseView(
                arguments: _getArguments(settings),
              ),
            ),
            settings);
      case RouteNames.debtorsView:
        return _getPageRoute(
            BlocProvider(
              create: (context) =>
                  DebtorCustomerBloc(getIt())..add(GetDebtorsEvent()),
              child: const DebtorCustomersView(),
            ),
            settings);
      case RouteNames.cashBoxTransferView:
        return _getPageRoute(
            BlocProvider(
              create: (context) =>
                  CashBoxTransferBloc(getIt())..add(GetCashBoxTransferEvent()),
              child: const CashBoxTransferView(),
            ),
            settings);
      default:
        return _getPageRoute(Container(), settings);
    }
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  if (Platform.isIOS) {
    return CupertinoPageRoute(
      builder: (context) => child,
      settings: settings,
    );
  } else {
    return _FadeRoute(child: child, routeName: settings.name);
  }
}

class _FadeRoute extends PageRouteBuilder {
  final Widget? child;
  final String? routeName;

  _FadeRoute({this.child, this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child!,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

Map<String, dynamic>? _getArguments(RouteSettings settings) {
  return settings.arguments as Map<String, dynamic>?;
}

Route animationSwitch(Widget destination, String routeName) {
  return PageRouteBuilder(
    settings: RouteSettings(name: routeName),
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        destination,
    transitionDuration: const Duration(milliseconds: 1200),
    reverseTransitionDuration: const Duration(milliseconds: 1200),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCirc,
          reverseCurve: Curves.easeOutCirc.flipped,
        ),
        child: child,
      );
    },
  );
}
