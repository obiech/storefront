import 'package:flutter/material.dart';
import 'package:mockingjay/mockingjay.dart';

/// Creates a stubbed [NavigatorState] that can receive route pushes
/// but does nothing
MockNavigator createStubbedMockNavigator() {
  final navigator = MockNavigator();
  when(() => navigator.pushNamed(
        any(),
        arguments: any(named: 'arguments'),
      )).thenAnswer((_) async {
    return null;
  });
  when(() => navigator.pushReplacementNamed(
        any(),
        arguments: any(named: 'arguments'),
      )).thenAnswer((_) async {
    return null;
  });
  when(() => navigator.pushNamedAndRemoveUntil(any(), any()))
      .thenAnswer((_) async {
    return null;
  });

  return navigator;
}

/// Convenience function for testing route pushes
///
/// [navigator] - [MockNavigator] object from mockingjay package
/// [routeName] - name of route that is expected to be pushed
/// [arguments] - (optional) arguments for the route
/// [callCount] - (optional) expected number of calls. Default is 1.
void verifyPushNamed(
  MockNavigator navigator,
  String routeName, {
  Object? arguments,
  int callCount = 1,
}) {
  verify(() => navigator.pushNamed(routeName, arguments: arguments))
      .called(callCount);
}

/// Convenience function for testing route pushes
///
/// [navigator] - [MockNavigator] object from mockingjay package
/// [routeName] - name of route that is expected to be replaced
/// [arguments] - (optional) arguments for the route
/// [callCount] - (optional) expected number of calls. Default is 1.
void verifyPushReplacementNamed(MockNavigator navigator, String routeName,
    {Object? arguments, int callCount = 1}) {
  verify(() => navigator.pushReplacementNamed(routeName, arguments: arguments))
      .called(callCount);
}

/// Convenience function for verifying [Navigator.pushNamedAndRemoveUntil] calls
///
/// - [navigator] - [MockNavigator] object from mockingjay package
/// - [routeName] - name of route that is expected to be pushed
/// - [predicate] - will stop popping routes when [predicate] returns true.
/// By default, it's set to always return false so it will pop all routes.
/// - [arguments] - (optional) arguments for the route
/// - [callCount] - (optional) expected number of calls. Default is 1.
void verifyPushNamedAndRemoveUntil(
  MockNavigator navigator,
  String routeName, {
  bool Function(Route<dynamic>)? predicate,
  Object? arguments,
  int callCount = 1,
}) {
  verify(
    () => navigator.pushNamedAndRemoveUntil(
      routeName,
      predicate ?? any(),
      arguments: arguments,
    ),
  ).called(callCount);
}
