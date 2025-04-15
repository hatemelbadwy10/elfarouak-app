import 'package:elfarouk_app/core/services/services_locator.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String _currentRouteName = '';
  static final List<PendingRoute> _pendingRoutes = [];

  Future<dynamic> navigateTo(String routeName, {Object? arguments}) async {
    _currentRouteName = routeName;
    if (navigatorKey.currentState == null) {
      _pendingRoutes
          .add(PendingRoute(routeName, arguments, NavigationType.push));
      return;
    }
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndReplace(String routeName,
      {Object? arguments}) async {
    _currentRouteName = routeName;
    if (navigatorKey.currentState == null) {
      _pendingRoutes
          .add(PendingRoute(routeName, arguments, NavigationType.replace));
      return;
    }
    return navigatorKey.currentState
        ?.pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndClearStack(String routeName,
      {Object? arguments}) async {
    _currentRouteName = routeName;
    if (navigatorKey.currentState == null) {
      _pendingRoutes
          .add(PendingRoute(routeName, arguments, NavigationType.clearStack));
      return;
    }
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  Future<dynamic> navigateToAndRemoveUntil(
    String routeName, {
    required RoutePredicate predicate,
    Object? arguments,
  }) async {
    _currentRouteName = routeName;
    if (navigatorKey.currentState == null) {
      _pendingRoutes
          .add(PendingRoute(routeName, arguments, NavigationType.removeUntil));
      return;
    }
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void goBackUntil(String routeName) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState
          ?.popUntil((route) => route.settings.name == routeName);
    }
  }

  void goBack() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      _currentRouteName = "";
      navigatorKey.currentState?.pop();
    }
  }

  void goBackWithData(dynamic data) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(data);
    }
  }

  String get currentRouteName => _currentRouteName;

  void processPendingRoutes() {
    final navigationService = getIt<NavigationService>();
    for (final pendingRoute in _pendingRoutes) {
      switch (pendingRoute.type) {
        case NavigationType.push:
          navigationService.navigateTo(
            pendingRoute.routeName,
            arguments: pendingRoute.arguments,
          );
          break;
        case NavigationType.replace:
          navigationService.navigateToAndReplace(
            pendingRoute.routeName,
            arguments: pendingRoute.arguments,
          );
          break;
        case NavigationType.clearStack:
          navigationService.navigateToAndClearStack(
            pendingRoute.routeName,
            arguments: pendingRoute.arguments,
          );
          break;
        case NavigationType.removeUntil:
          navigationService.navigateToAndRemoveUntil(
            pendingRoute.routeName,
            predicate: (route) => false, // Adjust predicate if needed
            arguments: pendingRoute.arguments,
          );
          break;
      }
    }
    _pendingRoutes.clear();
  }
}

class PendingRoute {
  final String routeName;
  final Object? arguments;
  final NavigationType type;

  PendingRoute(this.routeName, this.arguments, this.type);
}

enum NavigationType { push, replace, clearStack, removeUntil }
