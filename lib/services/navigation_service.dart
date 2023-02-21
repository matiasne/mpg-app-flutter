import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String? lastRoute;

  Future<dynamic>? navigateTo(
    String routeName, {
    dynamic args,
    Map<String, String>? queryParams,
  }) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }
    if (scaffoldKey.currentState != null) {
      scaffoldKey.currentState?.openEndDrawer();
    }
    Future<dynamic>? result;
    if (lastRoute != routeName) {
      result = navigatorKey.currentState!
          .pushReplacementNamed(routeName, arguments: args);
    }
    lastRoute = routeName;
    return result;
  }

  Future<dynamic>? popAndPushNamed(
    String routeName, {
    dynamic args,
    Map<String, String>? queryParams,
  }) {
    if (queryParams != null) {
      routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    }
    Future<dynamic>? result;
    if (lastRoute != routeName) {
      result = navigatorKey.currentState!
          .popAndPushNamed(routeName, arguments: args);
    }
    lastRoute = routeName;
    return result;
  }

  void pop() {
    navigatorKey.currentState!.pop();
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }
}
