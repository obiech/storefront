import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/app_router.gr.dart';
import 'package:storefront_app/core/services/prefs/i_prefs_repository.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../../../test_commons/finders/onboarding_screen_finders.dart';
import '../../src/mock_navigator.dart';

class MockPrefsRepository extends Mock implements IPrefsRepository {}

void main() {
  late StackRouter router;
  late IPrefsRepository prefsRepository;

  setUp(() {
    router = MockStackRouter();
    prefsRepository = MockPrefsRepository();

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    when(() => router.push(any())).thenAnswer((_) async => null);
    when(() => router.replaceAll(any())).thenAnswer((_) async => {});

    if (getIt.isRegistered<IPrefsRepository>()) {
      getIt.unregister<IPrefsRepository>();
    }

    // PrefsRepository stubs
    when(() => prefsRepository.setIsOnBoarded(any()))
        .thenAnswer((_) async => {});

    // OnboardingView has a reference to GetIt
    getIt.registerSingleton<IPrefsRepository>(prefsRepository);
  });

  Future<void> pumpOnboardingScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StackRouterScope(
          controller: router,
          stateHash: 0,
          child: const OnboardingScreen(),
        ),
      ),
    );
  }

  group(
    'OnboardingScreen',
    () {
      testWidgets(
        'should show important navigation elements',
        (WidgetTester tester) async {
          await pumpOnboardingScreen(tester);

          expect(finderButtonLogin, findsOneWidget);
          expect(finderButtonRegister, findsOneWidget);
          expect(finderButtonSkipOnboarding, findsOneWidget);
        },
      );

      testWidgets(
        "pushes a route for LoginPage when Button 'Login' is tapped",
        (WidgetTester tester) async {
          await pumpOnboardingScreen(tester);

          await tester.tap(finderButtonLogin);
          await tester.pumpAndSettle();

          final routes = verify(() => router.push(captureAny())).captured;

          expect(routes.length, 1);
          final route = routes.first;
          expect(route, isA<LoginRoute>());
        },
      );

      testWidgets(
        "pushes a route for LoginPage when Button 'Register' is tapped",
        (WidgetTester tester) async {
          await pumpOnboardingScreen(tester);

          await tester.tap(finderButtonRegister);
          await tester.pumpAndSettle();

          final routes = verify(() => router.push(captureAny())).captured;

          expect(routes.length, 1);
          final route = routes.first;
          expect(route, isA<RegistrationRoute>());
        },
      );

      testWidgets(
        "replaces route stack with MainScreen when 'Skip Onboarding' is tapped "
        'and sets onboarding boolean value to true',
        (WidgetTester tester) async {
          await pumpOnboardingScreen(tester);

          await tester.tap(finderButtonSkipOnboarding);
          await tester.pumpAndSettle();

          final routeStack = verify(() => router.replaceAll(captureAny()))
              .captured
              .first as List<PageRouteInfo>;

          expect(routeStack.length, 1);
          expect(routeStack.first, isA<MainRoute>());

          verify(() => prefsRepository.setIsOnBoarded(true)).called(1);
        },
      );
    },
  );
}
