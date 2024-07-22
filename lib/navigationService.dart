

import 'package:flutter/cupertino.dart';

class NavigationService {
  static final NavigationService instance = NavigationService._internal();
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  NavigationService._internal();

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return navigationKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!isCurrentRoute(routeName)) {
      return pushNamed(routeName, arguments: arguments);
    }
    return Future.value(null);
  }

bool isCurrentRoute(String routeName) {
  bool isCurrent = false;
  navigationKey.currentState!.popUntil((route) {
    if (route.settings.name == routeName) {
      isCurrent = true;
    }
    return true;
  });
  return isCurrent;
}
}