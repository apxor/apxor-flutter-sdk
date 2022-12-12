// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:apxor_flutter/apxor_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'auth.dart';
import 'routing.dart';
import 'screens/navigator.dart';

class Bookstore extends StatefulWidget {
  const Bookstore({Key? key}) : super(key: key);

  @override
  _BookstoreState createState() => _BookstoreState();
}

class _BookstoreState extends State<Bookstore> {
  final _auth = BookstoreAuth();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final RouteState _routeState;
  late final SimpleRouterDelegate _routerDelegate;
  late final TemplateRouteParser _routeParser;

  @override
  void initState() {
    /// Configure the parser with all of the app's allowed path templates.
    _routeParser = TemplateRouteParser(
      allowedPaths: [
        '/signin',
        '/authors',
        '/settings',
        '/books/new',
        '/books/all',
        '/books/popular',
        '/book/:bookId',
        '/author/:authorId',
      ],
      guard: _guard,
      initialRoute: '/books/all',
    );

    _routeState = RouteState(_routeParser);

    _routerDelegate = SimpleRouterDelegate(
      routeState: _routeState,
      navigatorKey: _navigatorKey,
      builder: (context) => BookstoreNavigator(
        navigatorKey: _navigatorKey,
      ),
    );

    // Listen for when the user logs out and display the signin screen.
    _auth.addListener(_handleAuthStateChanged);

    super.initState();

    ApxorFlutter.logAppEvent('AppOpen');
    ApxorFlutter.logAppEvent('AppEventWithAttributes',
        attributes: {"prop1": "A", "prop2": "B"});

    ApxorFlutter.setUserAttributes({
      'A': 1,
      'B': 2,
      'C': 3,
      'D': 4,
    });
    ApxorFlutter.setSessionAttributes({
      'Session-A': 1,
      'Session-B': 2,
      'Session-C': 3,
      'Session-D': 4,
    });
    ApxorFlutter.logClientEvent("DummyClientEvent",
        attributes: {"prop1": "A", "prop2": "B"});
    ApxorFlutter.setUserIdentifier("DummyCustomUserId");
    ApxorFlutter.setPushRegistrationToken("DummyPushToken");

    Future.delayed(const Duration(seconds: 10), () async {
      var attributes = await ApxorFlutter.getAttributes(['A', 'B', 'C']);
      print(attributes);

      var apxorId = await ApxorFlutter.getDeviceId();
      print(apxorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = RouteStateScope(
      notifier: _routeState,
      child: BookstoreAuthScope(
        notifier: _auth,
        child: MaterialApp.router(
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeParser,
          // Revert back to pre-Flutter-2.5 transition behavior:
          // https://github.com/flutter/flutter/issues/82053
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
              },
            ),
          ),
        ),
      ),
    );

    ApxorFlutter.setDeeplinkListener((url) async {
      print("url: $url");
      if (url == null) {
        return;
      }

      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        _routeState.go(url);
      }
    });

    return x;
  }

  Future<ParsedRoute> _guard(ParsedRoute from) async {
    final signedIn = _auth.signedIn;
    final signInRoute = ParsedRoute('/signin', '/signin', {}, {});

    // Go to /signin if the user is not signed in
    if (!signedIn && from != signInRoute) {
      return signInRoute;
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn && from == signInRoute) {
      return ParsedRoute('/books/popular', '/books/popular', {}, {});
    }
    return from;
  }

  void _handleAuthStateChanged() {
    if (!_auth.signedIn) {
      _routeState.go('/signin');
    }
  }

  @override
  void dispose() {
    _auth.removeListener(_handleAuthStateChanged);
    _routeState.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }
}
