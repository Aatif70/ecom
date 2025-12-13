import 'package:flutter/material.dart';
import '../utils/fancy_logger.dart';

class AppRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      FancyLogger.navigation('Pushed to ${route.settings.name} ${route.settings.arguments != null ? "args: ${route.settings.arguments}" : ""}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.settings.name != null) {
      FancyLogger.navigation('Popped back to ${previousRoute?.settings.name}');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name != null) {
      FancyLogger.navigation('Replaced with ${newRoute?.settings.name}');
    }
  }
}
