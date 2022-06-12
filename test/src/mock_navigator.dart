import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

/// AutoRoute Mocks
class MockStackRouter extends Mock implements StackRouter {}

// ignore: avoid_implementing_value_types
class FakePageRouteInfo extends Fake implements PageRouteInfo {}

extension StackRouterX on Widget {
  /// Returns [this] wrapped in a [StackRouterScope]
  /// if [stackRouter] is not null.
  /// Otherwise returns [this].
  ///
  /// Use this when verifying navigation is required in a test case.
  ///
  /// ```
  /// MaterialApp(
  ///   home: Scaffold(
  ///     body: WidgetToPump(),
  ///   ),
  /// ).withRouterScope(stackRouter);
  /// ```
  Widget withRouterScope(StackRouter? stackRouter) {
    return stackRouter != null
        ? StackRouterScope(
            controller: stackRouter,
            stateHash: 0,
            child: this,
          )
        : this;
  }
}
