import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../../src/mock_customer_service_client.dart';
import '../../src/mock_navigator.dart';
import '../../src/mock_page_utils.dart';

class MockPinRegistrationCubit extends MockCubit<PinRegistrationState>
    implements PinRegistrationCubit {}

void main() {
  late IPrefsRepository prefs;
  late StackRouter mockNavigator;
  late PinRegistrationCubit pinRegistrationCubit;

  final Finder finderInputFirstPin =
      find.byKey(const Key(PinInputPage.keyInputPin));
  final Finder finderInputConfirmPin =
      find.byKey(const Key(PinInputPage.keyInputConfirmPin));
  final Finder finderLoadingIndicator =
      find.byKey(const Key(PinInputPage.keyLoadingIndicator));
  final Finder finderInstructionsInputPin =
      find.text(PinInputPage.textInstructionsPin);
  final Finder finderInstructionsConfirmPin =
      find.text(PinInputPage.textInstructionsConfirmPin);
  final Finder finderErrorPinMismatch =
      find.text(PinInputPage.textErrorPinMismatch);
  final Finder finderButtonSkip =
      find.byKey(const Key(PinInputPage.keyButtonSkip));

  /// Mock methods that will be tested for
  setUp(() {
    mockNavigator = MockStackRouter();

    pinRegistrationCubit = MockPinRegistrationCubit();
    when(() => pinRegistrationCubit.registerPin(any()))
        .thenAnswer((_) async {});

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    when(() => mockNavigator.push(any())).thenAnswer((_) async => null);
    when(() => mockNavigator.replaceAll(any())).thenAnswer((_) async => {});

    prefs = MockIPrefsRepository();
    if (getIt.isRegistered<IPrefsRepository>()) {
      getIt.unregister<IPrefsRepository>();
    }

    when(() => prefs.setIsOnBoarded(any())).thenAnswer((_) async => {});
    when(() => prefs.isOnBoarded()).thenAnswer((_) => true);

    getIt.registerSingleton<IPrefsRepository>(prefs);
  });

  group('PIN Input Page', () {
    testWidgets(
      'initially shows PIN input and no error messsage',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationInitial());

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
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
          const PinRegistrationLoading(),
        );

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
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
            .thenReturn(const PinRegistrationInitial());

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
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
            .thenReturn(const PinRegistrationInitial());

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
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
            .thenReturn(const PinRegistrationInitial());

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
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
      'and Request Location Access page',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationInitial());

        final successStream = Stream.fromIterable(
          [const PinRegistrationSuccess()],
        );

        whenListen(pinRegistrationCubit, successStream);
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationInitial());

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
            mockNavigator: mockNavigator,
          ),
        );

        final routes =
            verify(() => mockNavigator.replaceAll(captureAny())).captured;
        expect(routes.length, 1);

        final capturedRoutes = routes.first as List<PageRouteInfo>;
        expect(capturedRoutes.length, 2);
        expect(capturedRoutes[0], isA<MainRoute>());
        expect(capturedRoutes[1], isA<RequestLocationAccessRoute>());

        verify(() => prefs.setIsOnBoarded(true)).called(1);
      },
    );

    testWidgets(
      'when user chooses skip option, pop all routes and push route for Homepage '
      'and Request Location Access page',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationInitial());

        final stream = Stream.fromIterable([
          const PinRegistrationInitial(),
        ]);

        whenListen(pinRegistrationCubit, stream);
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationInitial());

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
            mockNavigator: mockNavigator,
          ),
        );

        await tester.tap(finderButtonSkip);
        await tester.pumpAndSettle();

        final routes =
            verify(() => mockNavigator.replaceAll(captureAny())).captured;
        expect(routes.length, 1);

        final capturedRoutes = routes.first as List<PageRouteInfo>;
        expect(capturedRoutes.length, 2);
        expect(capturedRoutes[0], isA<MainRoute>());
        expect(capturedRoutes[1], isA<RequestLocationAccessRoute>());

        verify(() => prefs.setIsOnBoarded(true)).called(1);
      },
    );

    testWidgets(
      'on receiving an error State, display a [DropezyBottomSheet] containing '
      'the error message',
      (WidgetTester tester) async {
        when(() => pinRegistrationCubit.state)
            .thenReturn(const PinRegistrationInitial());

        // Initialize stream with default State
        final controller = StreamController<PinRegistrationState>();
        controller.add(const PinRegistrationInitial());
        whenListen(pinRegistrationCubit, controller.stream);

        await tester.pumpWidget(
          buildMockOtpVerificationPage(
            pinRegistrationCubit: pinRegistrationCubit,
          ),
        );

        // Add error State and wait for the animation to finish
        const errMsg = 'Dummy Error';
        controller.add(const PinRegistrationError(errMsg));
        await tester.pumpAndSettle();

        // Expect the error Bottom Sheet
        expect(find.byType(DropezyBottomSheet), findsOneWidget);
        expect(find.text(errMsg), findsOneWidget);
      },
    );
  });
}

/// Bootstraps a [MaterialApp] instance containing a [PinInputPage] wrapped
/// by [BlocProvider]s for [PinRegistrationCubit] and [OnboardingCubit].
///
/// Do not pass [mockNavigator] to avoid mocking Navigator.
Widget buildMockOtpVerificationPage({
  required PinRegistrationCubit pinRegistrationCubit,
  StackRouter? mockNavigator,
}) =>
    buildMockPageWithMultiBlocProviderAndAutoRoute(
      [BlocProvider<PinRegistrationCubit>.value(value: pinRegistrationCubit)],
      const PinInputPage(),
      mockNavigator,
    );
