import 'package:apxor_flutter/apxor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ScreenNameExtractor = String? Function(Route route);

String? defaultNameExtractor(Route route) {
  String? name = route.settings.name;
  if (name != null) {
    return name;
  }

  if (route.settings is Page) {
    final page = route.settings as Page;
    if (page.name != null) {
      return page.name;
    }

    final key = page.key;
    if (key != null && key is ValueKey) {
      return key.value;
    }
  }

  return null;
}

class ApxNavigationObserver extends NavigatorObserver {
  final ScreenNameExtractor nameExtractor;

  ApxNavigationObserver({
    this.nameExtractor = defaultNameExtractor,
  });

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _trackScreenIfPossible(previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _trackScreenIfPossible(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _trackScreenIfPossible(newRoute);
  }

  void _trackScreenIfPossible(Route? route) {
    if (route != null && route is PageRoute) {
      String? name = nameExtractor(route);
      if (name != null && route.navigator?.context != null) {
        ApxorFlutter.internalTrackScreen(name, route.navigator!.context, true);
      }
    }
  }
}
