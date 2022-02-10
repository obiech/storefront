import 'package:mockingjay/mockingjay.dart';
import 'package:flutter/material.dart';

/// Creates a stubbed [NavigatorState] that can receive route pushes
/// but does nothing
MockNavigator createStubbedMockNavigator() {
  final navigator = MockNavigator();
  when(() => navigator.pushNamed(any())).thenAnswer((_) async {
    return null;
  });
  when(() => navigator.pushReplacementNamed(any())).thenAnswer((_) async {
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
void verifyRouteIsPushed(MockNavigator navigator, String routeName,
    {Object? arguments, int callCount = 1}) {
  verify(() => navigator.pushNamed(routeName)).called(callCount);
}
