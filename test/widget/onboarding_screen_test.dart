import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/app/app.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/ui/onboarding/onboarding_widgets.dart';
import 'package:storefront_app/ui/screens.dart';

class MockOnboardingCubit extends MockCubit<bool> implements OnboardingCubit {}

void main() {
  group('Hide / Show Onboarding Screen based on isOnboarded boolean', () {
    testWidgets(' -- Display Onboarding screen if User has not yet onboarded',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildMockOnboardingScreen());

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets(
        ' -- Instead, show Home screen if user has been onboarded (e.g. has logged in, registered, or skipped)',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildMockOnboardingScreen(true));

      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('Test Navigation', () {
    testWidgets(' -- Ensure Navigation elements are visible',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildMockOnboardingScreen());

      expect(find.byType(ButtonLogin), findsOneWidget);
      expect(find.byType(ButtonRegister), findsOneWidget);
      expect(find.byType(ButtonSkipOnboarding), findsOneWidget);
    });

    testWidgets(' -- Tapping on Login button takes User to Login screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildMockOnboardingScreen());

      await tester.tap(find.byType(ButtonLogin));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets(
        ' -- Tapping on Register button takes User to Registration screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildMockOnboardingScreen());

      await tester.tap(find.byType(ButtonRegister));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(RegistrationScreen), findsOneWidget);
    });

    testWidgets(' -- Tapping on Skip button takes user to Home screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildMockOnboardingScreen());

      await tester.tap(find.byType(ButtonSkipOnboarding));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}

Widget buildMockOnboardingScreen([bool isOnboarded = false]) {
  final cubit = MockOnboardingCubit();
  when(() => cubit.state).thenReturn(isOnboarded);

  return BlocProvider<OnboardingCubit>(
    create: (_) => cubit,
    child: const MyApp(),
  );
}
