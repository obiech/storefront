import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../../../test_commons/finders/onboarding_page_finders.dart';
import '../../commons.dart';
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

    when(() => prefsRepository.getDeviceLocale())
        .thenAnswer((_) => const Locale('en', 'EN'));

    // OnboardingView has a reference to GetIt
    getIt.registerSingleton<IPrefsRepository>(prefsRepository);
  });

  setUpAll(() {
    setUpLocaleInjection();
  });

  group(
    'OnboardingPage',
    () {
      testWidgets(
        'should show important navigation elements',
        (WidgetTester tester) async {
          await tester.pumpOnboardingPage();

          expect(finderButtonLogin, findsOneWidget);
          expect(finderButtonRegister, findsOneWidget);
        },
      );

      testWidgets(
        "pushes a route for LoginPage when Button 'Login' is tapped",
        (WidgetTester tester) async {
          await tester.pumpOnboardingPage(stackRouter: router);

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
          await tester.pumpOnboardingPage(stackRouter: router);

          await tester.tap(finderButtonRegister);
          await tester.pumpAndSettle();

          final routes = verify(() => router.push(captureAny())).captured;

          expect(routes.length, 1);
          final route = routes.first;
          expect(route, isA<RegistrationRoute>());
        },
      );

      testWidgets(
        'should not show toast when isUserSignOut is false',
        (WidgetTester tester) async {
          final context = await tester.pumpOnboardingPage(isUserSignOut: false);

          expect(
            find.text(context.res.strings.youveLogoutSuccesfully),
            findsNothing,
          );
        },
      );

      testWidgets(
        'should show toast when isUserSignOut is true',
        (WidgetTester tester) async {
          final context = await tester.pumpOnboardingPage(isUserSignOut: true);

          await tester.pumpAndSettle();

          expect(
            find.text(context.res.strings.youveLogoutSuccesfully),
            findsOneWidget,
          );
        },
      );
    },
  );
}

extension WidgetX on WidgetTester {
  Future<BuildContext> pumpOnboardingPage({
    bool? isUserSignOut,
    StackRouter? stackRouter,
  }) async {
    late BuildContext ctx;
    await pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ctx = context;
            return Scaffold(
              body: OnboardingPage(
                isUserSignOut: isUserSignOut ?? false,
              ).withRouterScope(stackRouter),
            );
          },
        ),
      ),
    );
    return ctx;
  }
}
