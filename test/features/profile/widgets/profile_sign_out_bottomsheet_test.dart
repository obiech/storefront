import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/domain/services/auth_service.dart';
import 'package:storefront_app/features/profile/widgets/widgets.dart';

import '../../../commons.dart';
import '../../../src/mock_navigator.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late StackRouter router;
  late AuthService service;

  setUp(() {
    router = MockStackRouter();
    service = MockAuthService();

    when(() => router.replaceAll(any())).thenAnswer((_) async => {});
    when(() => service.signOut()).thenAnswer((_) async {});

    if (GetIt.I.isRegistered<AuthService>()) {
      GetIt.I.unregister<AuthService>();
    }

    GetIt.instance.registerSingleton<AuthService>(service);
  });

  setUpAll(() {
    registerFallbackValue(FakePageRouteInfo());
    setUpLocaleInjection();
  });

  group('[ProfileSignOutBottomSheet]', () {
    testWidgets('should close when cancel button is tapped', (tester) async {
      final context = await tester.pumpSignOutSheet(router);

      await tester.tap(find.text(context.res.strings.cancel));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileSignOutBottomSheet), findsNothing);
    });
  });

  testWidgets(
      'should return to Onboarding page '
      "when 'Yes, sign out' button is tapped", (tester) async {
    final context = await tester.pumpSignOutSheet(router);

    await tester.tap(find.text(context.res.strings.yesSignOut));
    await tester.pump(const Duration(seconds: 1));

    verify(() => service.signOut()).called(1);

    // Expecting routes to replace
    final capturedRoutes =
        verify(() => router.replaceAll(captureAny())).captured;

    expect(capturedRoutes.length, 1);
    expect(capturedRoutes.first.first, isA<OnboardingRoute>());
  });
}

/// Helper functions specific to this test
extension WidgetTesterX on WidgetTester {
  Future<BuildContext> pumpSignOutSheet(StackRouter stackRouter) async {
    late BuildContext ctx;

    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return StackRouterScope(
              controller: stackRouter,
              stateHash: 0,
              child: const ProfileSignOutBottomSheet(),
            );
          },
        ),
      ),
    );

    return ctx;
  }
}
