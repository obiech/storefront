import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/screens/onboarding/onboarding_widgets.dart';
import 'package:storefront_app/features/auth/screens/screens.dart';

import '../../src/mock_navigator.dart';

class MockOnboardingCubit extends MockCubit<bool> implements OnboardingCubit {}

void main() {
  late MockNavigator navigator;
  late OnboardingCubit onboardingCubit;

  setUp(() {
    navigator = createStubbedMockNavigator();
    onboardingCubit = MockOnboardingCubit();
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

      verifyPushNamed(navigator, LoginScreen.routeName);
    });

    testWidgets(
        ' -- Tapping on Register button pushes route for RegistrationScreen',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildMockOnboardingScreen(onboardingCubit, navigator));

      await tester.tap(find.byType(ButtonRegister));
      await tester.pumpAndSettle();

      verifyPushNamed(navigator, RegistrationScreen.routeName);
    });

    testWidgets(
        ' -- Tapping on Skip calls [OnboardingCubit.finishOnboarding()] once',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(buildMockOnboardingScreen(onboardingCubit, navigator));

      await tester.tap(find.byType(ButtonSkipOnboarding));
      await tester.pumpAndSettle();

      verify(() => onboardingCubit.finishOnboarding()).called(1);
    });
  });
}

Widget buildMockOnboardingScreen(
  OnboardingCubit cubit,
  MockNavigator navigator,
) {
  return BlocProvider<OnboardingCubit>(
    create: (_) => cubit,
    child: MaterialApp(
      home: MockNavigatorProvider(
        navigator: navigator,
        child: const OnboardingScreen(),
      ),
    ),
  );
}
