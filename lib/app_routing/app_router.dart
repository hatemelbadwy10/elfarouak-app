import 'dart:io';

import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/app_routing/routing_data.dart';
import 'package:elfarouk_app/features/customers/presentation/controller/customers_bloc.dart';
import 'package:elfarouk_app/features/customers/presentation/view/add_customer_view.dart';
import 'package:elfarouk_app/features/customers/presentation/view/customers_view.dart';
import 'package:elfarouk_app/features/home_view/presentation/controller/home_bloc.dart';
import 'package:elfarouk_app/features/home_view/presentation/view/home_view.dart';
import 'package:elfarouk_app/features/login_screen/presentation/controller/login_bloc.dart';
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
import '../features/login_screen/presentation/view/login_screen.dart';
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
        return _getPageRoute(
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(getIt()), // optional initial event
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
          const AddTransferView(),
          settings,
        );
      case RouteNames.transfersView:
        return _getPageRoute(
          const TransfersView(),
          settings,
        );
      case RouteNames.singleTransferView:
        return _getPageRoute(
          const SingleTransferView(),
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
