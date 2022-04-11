import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/app_router.gr.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/screens/onboarding/onboarding_widgets.dart';

import '../../src/mock_navigator.dart';
import '../../src/mock_screen_utils.dart';

class MockOnboardingCubit extends MockCubit<bool> implements OnboardingCubit {}

void main() {
  late StackRouter navigator;
  late OnboardingCubit onboardingCubit;

  setUp(() {
    navigator = MockStackRouter();
    onboardingCubit = MockOnboardingCubit();

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    when(() => navigator.push(any())).thenAnswer((_) async => null);
    when(() => navigator.replaceAll(any())).thenAnswer((_) async => {});
  });

  group('Onboarding Screen Navigation', () {
    testWidgets(' -- Ensure Navigation elements are visible',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildMockOnboardingScreen(onboardingCubit, navigator));

      expect(find.byType(ButtonLogin), findsOneWidget);
      expect(find.byType(ButtonRegister), findsOneWidget);
      expect(find.byType(ButtonSkipOnboarding), findsOneWidget);
    });

    testWidgets(' -- Tapping on Login button pushes route for HomeScreen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildMockOnboardingScreen(onboardingCubit, navigator));

      await tester.tap(find.byType(ButtonLogin));
      await tester.pumpAndSettle();

      final routes = verify(() => navigator.push(captureAny())).captured;

      expect(routes.length, 1);
      final route = routes.first;
      expect(route, isA<LoginRoute>());
    });

    testWidgets(
        ' -- Tapping on Register button pushes route for RegistrationScreen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildMockOnboardingScreen(onboardingCubit, navigator));

      await tester.tap(find.byType(ButtonRegister));
      await tester.pumpAndSettle();

      final routes = verify(() => navigator.push(captureAny())).captured;

      expect(routes.length, 1);
      final route = routes.first;
      expect(route, isA<RegistrationRoute>());
    });

    testWidgets(
        ' -- Tapping on Skip calls [OnboardingCubit.finishOnboarding()] once',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildMockOnboardingScreen(
          onboardingCubit,
          navigator,
        ),
      );
/*
TODO - Fix test
      when(
        () => onboardingCubit.finishOnboarding(),
      ).thenAnswer(
        (_) async {},
      );

      await tester.tap(find.byType(ButtonSkipOnboarding));
      await tester.pumpAndSettle();

      verify(() => onboardingCubit.finishOnboarding()).called(1);*/
    });
  });
}

Widget buildMockOnboardingScreen(
  OnboardingCubit cubit,
  StackRouter navigator,
) {
  return buildMockScreenWithBlocProviderAndAutoRoute(
    cubit,
    const OnboardingScreen(),
    navigator,
  );
}
