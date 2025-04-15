import 'dart:io';

import 'package:elfarouk_app/app_routing/route_names.dart';
import 'package:elfarouk_app/app_routing/routing_data.dart';
import 'package:elfarouk_app/features/home_view/presentation/view/home_view.dart';
import 'package:flutter/cupertino.dart';

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
          const LoginScreen(),
          settings,
        );
        case RouteNames.homeView:
        return _getPageRoute(
          const HomeView(),
          settings,
        );

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

Map<String, dynamic> _getArguments(RouteSettings settings) {
  return settings.arguments is Map<String, dynamic>
      ? settings.arguments as Map<String, dynamic>
      : {};
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
