import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/app_router.gr.dart';
import 'package:storefront_app/features/auth/widgets/auth_bottom_sheet.dart';

import '../../../commons.dart';
import '../../../src/mock_navigator.dart';

void main() {
  late StackRouter stackRouter;

  setUp(() {
    stackRouter = MockStackRouter();

    when(() => stackRouter.push(any())).thenAnswer((_) async => null);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  testWidgets(
    'should navigate to LoginRoute '
    'when login button is pressed',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StackRouterScope(
            controller: stackRouter,
            stateHash: 0,
            child: const AuthBottomSheet(),
          ),
        ),
      );

      await tester.tap(find.byKey(AuthBottomSheetKeys.loginButton));
      await tester.pumpAndSettle();

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      // there should only be one route that's being pushed
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<LoginRoute>());
    },
  );

  testWidgets(
    'should navigate to RegistrationRoute '
    'when register button is pressed',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StackRouterScope(
            controller: stackRouter,
            stateHash: 0,
            child: const AuthBottomSheet(),
          ),
        ),
      );

      await tester.tap(find.byKey(AuthBottomSheetKeys.registerButton));
      await tester.pumpAndSettle();

      final capturedRoutes =
          verify(() => stackRouter.push(captureAny())).captured;

      // there should only be one route that's being pushed
      expect(capturedRoutes.length, 1);

      final routeInfo = capturedRoutes.first as PageRouteInfo;

      // expecting the right route being pushed
      expect(routeInfo, isA<RegistrationRoute>());
    },
  );
}
