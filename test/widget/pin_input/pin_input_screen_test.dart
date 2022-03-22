import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/bloc/pin/pin_registration.dart';
import 'package:storefront_app/ui/home/home_screen.dart';
import 'package:storefront_app/ui/pin_input/pin_input_screen.dart';
import 'package:storefront_app/ui/widgets/bottom_sheet/dropezy_bottom_sheet.dart';

import '../../src/mock_navigator.dart';
import '../../src/mock_screen_utils.dart';

class MockPinRegistrationCubit extends MockCubit<PinRegistrationState>
    implements PinRegistrationCubit {}

class MockOnboardingCubit extends MockCubit<bool> implements OnboardingCubit {}

void main() {
  late MockNavigator mockNavigator;
  late PinRegistrationCubit pinRegistrationCubit;
  late OnboardingCubit onboardingCubit;

  final Finder finderInputFirstPin =
      find.byKey(const Key(PinInputScreen.keyInputPin));
  final Finder finderInputConfirmPin =
      find.byKey(const Key(PinInputScreen.keyInputConfirmPin));
  final Finder finderLoadingIndicator =
      find.byKey(const Key(PinInputScreen.keyLoadingIndicator));
  final Finder finderInstructionsInputPin =
      find.text(PinInputScreen.textInstructionsPin);
  final Finder finderInstructionsConfirmPin =
      find.text(PinInputScreen.textInstructionsConfirmPin);
  final Finder finderErrorPinMismatch =
      find.text(PinInputScreen.textErrorPinMismatch);
  final Finder finderButtonSkip =
      find.byKey(const Key(PinInputScreen.keyButtonSkip));

  /// Mock methods that will be tested for
  setUpAll(() {
    mockNavigator = createStubbedMockNavigator();

    pinRegistrationCubit = MockPinRegistrationCubit();
    when(() => pinRegistrationCubit.registerPin(any()))
        .thenAnswer((_) async {});

    onboardingCubit = MockOnboardingCubit();
    when(() => onboardingCubit.finishOnboarding()).thenAnswer((_) {});
  });

  group('PIN Input Screen', () {
    testWidgets(
      'initially shows PIN input and no error messsage',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        expect(finderInstructionsInputPin, findsOneWidget);
        expect(finderInputFirstPin, findsOneWidget);

        expect(finderInstructionsConfirmPin, findsNothing);
        expect(finderInputConfirmPin, findsNothing);
        expect(finderErrorPinMismatch, findsNothing);
      },
    );

    testWidgets(
      'should display a loading indicator and hide PIN inputs when current '
      'State is loading',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state).thenReturn(
          const PinRegistrationState(status: PinRegistrationStatus.loading),
        );

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        expect(finderLoadingIndicator, findsOneWidget);
        expect(finderInputFirstPin, findsNothing);
        expect(finderInputConfirmPin, findsNothing);
        expect(finderErrorPinMismatch, findsNothing);
      },
    );

    testWidgets(
      'upon 6 letters are entered should switch to Confirm Pin, '
      'and upon another 6 letters are entered should call '
      '[PinRegistrationCubit.registerPin] with entered PIN as args',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        // Initial state
        expect(finderInputFirstPin, findsOneWidget);
        expect(finderInputConfirmPin, findsNothing);

        // Enter text for first PIN
        await tester.enterText(finderInputFirstPin, '123456');
        await tester.pumpAndSettle();

        // At this point, registerPin should not be called
        verifyNever(() => pinRegistrationCubit.registerPin('123456'));

        // Should switch to Confirm PIN input
        expect(finderInputFirstPin, findsNothing);
        expect(finderInputConfirmPin, findsOneWidget);

        // Enter text for Confirm PIN
        await tester.enterText(finderInputConfirmPin, '123456');
        await tester.pumpAndSettle();

        // At this point, registerPin should be called
        verify(() => pinRegistrationCubit.registerPin('123456')).called(1);
      },
    );

    // On pin mismatch
    testWidgets(
      'when PIN and Confirm PIN are different, should show a PIN mismatch error '
      'and prompt user to re-enter PIN',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        // Initial state
        expect(finderInputFirstPin, findsOneWidget);
        expect(finderErrorPinMismatch, findsNothing);
        expect(finderInputConfirmPin, findsNothing);

        // Enter text for first PIN
        await tester.enterText(finderInputFirstPin, '123456');
        await tester.pumpAndSettle();

        // Enter text for Confirm PIN
        await tester.enterText(finderInputConfirmPin, '000000');
        await tester.pumpAndSettle();

        // Expected state on PIN mismatch
        expect(finderInputFirstPin, findsOneWidget);
        expect(finderErrorPinMismatch, findsOneWidget);
        expect(finderInputConfirmPin, findsNothing);
      },
    );

    testWidgets(
      'when PIN and Confirm PIN are different, should show a PIN mismatch error '
      'and prompt user to re-enter PIN',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        // Initial state
        expect(finderInputFirstPin, findsOneWidget);
        expect(finderErrorPinMismatch, findsNothing);
        expect(finderInputConfirmPin, findsNothing);

        // Enter text for first PIN
        await tester.enterText(finderInputFirstPin, '123456');
        await tester.pumpAndSettle();

        // Enter text for Confirm PIN
        await tester.enterText(finderInputConfirmPin, '000000');
        await tester.pumpAndSettle();

        // Expected state on PIN mismatch
        expect(finderInputFirstPin, findsOneWidget);
        expect(finderErrorPinMismatch, findsOneWidget);
        expect(finderInputConfirmPin, findsNothing);
      },
    );

    testWidgets(
      'on receiving a success State, pop all routes and push route for Homepage '
      'and call [OnboardingCubit.finishOnboarding()]',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        final successStream = Stream.fromIterable(
          [const PinRegistrationState(status: PinRegistrationStatus.success)],
        );

        whenListen(pinRegistrationCubit, successStream);
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        verify(() => onboardingCubit.finishOnboarding()).called(1);
        verifyPushNamedAndRemoveUntil(mockNavigator, HomeScreen.routeName);
      },
    );

    testWidgets(
      'when user chooses skip option, pop all routes and push route for Homepage '
      'and call [OnboardingCubit.finishOnboarding()]',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        final stream = Stream.fromIterable([
          const PinRegistrationState(),
        ]);

        whenListen(pinRegistrationCubit, stream);
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
            mockNavigator: mockNavigator,
          ),
        );

        await tester.tap(finderButtonSkip);
        await tester.pumpAndSettle();

        verify(() => onboardingCubit.finishOnboarding()).called(1);
        verifyPushNamedAndRemoveUntil(mockNavigator, HomeScreen.routeName);
      },
    );

    testWidgets(
      'on receiving an error State, display a [DropezyBottomSheet] containing '
      'the error message',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationState());

        // Initialize stream with default State
        final controller = StreamController<PinRegistrationState>();
        controller.add(const PinRegistrationState());
        whenListen(pinRegistrationCubit, controller.stream);

        await tester.pumpWidget(
          buildMockOtpVerificationScreen(
            pinRegistrationCubit: pinRegistrationCubit,
            onboardingCubit: onboardingCubit,
          ),
        );

        // Add error State and wait for the animation to finish
        const errMsg = 'Dummy Error';
        controller.add(
          const PinRegistrationState(
            status: PinRegistrationStatus.error,
            errMsg: errMsg,
          ),
        );
        await tester.pumpAndSettle();

        // Expect the error Bottom Sheet
        expect(find.byType(DropezyBottomSheet), findsOneWidget);
        expect(find.text(errMsg), findsOneWidget);
      },
    );
  });
}

/// Bootstraps a [MaterialApp] instance containing a [PinInputScreen] wrapped
/// by [BlocProvider]s for [PinRegistrationCubit] and [OnboardingCubit].
///
/// Do not pass [mockNavigator] to avoid mocking Navigator.
Widget buildMockOtpVerificationScreen({
  required PinRegistrationCubit pinRegistrationCubit,
  required OnboardingCubit onboardingCubit,
  MockNavigator? mockNavigator,
}) =>
    buildMockScreenWithMultiBlocProvider(
      [
        BlocProvider<PinRegistrationCubit>.value(value: pinRegistrationCubit),
        BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
      ],
      const PinInputScreen(),
      mockNavigator,
    );
