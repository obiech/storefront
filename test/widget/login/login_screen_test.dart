import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/screens/login/phone_not_registered_bottom_sheet.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/otp_success_action.dart';

import '../../src/mock_navigator.dart';
import '../../src/mock_screen_utils.dart';

class MockAccountAvailabilityCubit extends MockCubit<AccountAvailabilityState>
    implements AccountAvailabilityCubit {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'env/.env');

  late StackRouter navigator;
  late AccountAvailabilityCubit accountAvailabilityCubit;

  final finderInputPhoneNumber =
      find.byKey(const Key(LoginScreen.keyInputPhoneNumber));
  final verifyPhoneButtonFinder =
      find.byKey(const Key(LoginScreen.keyVerifyPhoneNumberButton));

  setUp(() {
    navigator = MockStackRouter();
    accountAvailabilityCubit = MockAccountAvailabilityCubit();

    when(
      () => accountAvailabilityCubit.checkPhoneNumberAvailability(
        any(),
      ),
    ).thenAnswer(
      (_) async {},
    );

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    when(() => navigator.push(any())).thenAnswer((_) async => null);
    when(() => navigator.replaceAll(any())).thenAnswer((_) async => {});
  });

  group('Login Screen', () {
    testWidgets(' -- Ensure important elements are visible',
        (WidgetTester tester) async {
      when(() => accountAvailabilityCubit.state)
          .thenReturn(const AccountAvailabilityState());
      await tester.pumpWidget(
        buildMockLoginScreen(
          accountAvailabilityCubit,
          navigator,
        ),
      );

      // Expect an empty PhoneTextField
      final emptyPhoneTextField = find.byWidgetPredicate(
        (widget) => widget is PhoneTextField && widget.controller.text.isEmpty,
      );

      expect(emptyPhoneTextField, findsOneWidget);
      expect(verifyPhoneButtonFinder, findsOneWidget);
      expect(find.byType(TextUserAgreement), findsOneWidget);
    });

    testWidgets(
      'should be pre-filled with phone number if [initialPhoneNumber] is not null',
      (WidgetTester tester) async {
        // Setup
        const initialPhoneNumber = '81234567890';

        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        // Build Widget
        await tester.pumpWidget(
          buildMockLoginScreen(
            accountAvailabilityCubit,
            navigator,
            initialPhoneNumber,
          ),
        );

        // Expect a pre-filled PhoneTextField
        final finderPreFilledPhoneTextField = find.byWidgetPredicate(
          (widget) =>
              widget is PhoneTextField &&
              widget.controller.text == initialPhoneNumber,
        );

        expect(finderPreFilledPhoneTextField, findsOneWidget);
      },
    );

    group('Test phone verification', () {
      testWidgets('''
        -- After entering phone number and tapping Submit button,
        [AccountAvailabilityCubit.verifyPhone] will be called with entered phone
        number in international format''', (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
          ]),
        );

        await tester.pumpWidget(
          buildMockLoginScreen(
            accountAvailabilityCubit,
            navigator,
          ),
        );

        const mockInput = '81234567890';
        const expectedPhoneNumber = '+6281234567890';

        await tester.enterText(find.byType(PhoneTextField), mockInput);
        await tester.tap(verifyPhoneButtonFinder);
        await tester.pumpAndSettle();

        verify(
          () => accountAvailabilityCubit
              .checkPhoneNumberAvailability(expectedPhoneNumber),
        ).called(1);
      });

      testWidgets('''
         -- After entering phone number prefixed with '08' and
         tapping Submit button, [AccountAvailabilityCubit.verifyPhone] will be
         called with entered phone number in international format''',
          (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
          ]),
        );

        await tester.pumpWidget(
          buildMockLoginScreen(
            accountAvailabilityCubit,
            navigator,
          ),
        );

        const mockInput = '081234567890';
        const expectedPhoneNumber = '+6281234567890';

        await tester.enterText(find.byType(PhoneTextField), mockInput);
        await tester.tap(verifyPhoneButtonFinder);
        await tester.pumpAndSettle();

        verify(
          () => accountAvailabilityCubit
              .checkPhoneNumberAvailability(expectedPhoneNumber),
        ).called(1);
      });
      testWidgets(
          '''-- If phone number is available, displays a [PhoneNotRegisteredBottomSheet]''',
          (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
              status: AccountAvailabilityStatus.phoneIsAvailable,
            )
          ]),
        );

        await tester.pumpWidget(buildMockLoginScreen(accountAvailabilityCubit));

        await tester.pumpAndSettle();

        expect(find.byType(PhoneNotRegisteredBottomSheet), findsOneWidget);
      });
      testWidgets(
        '-- If phone number is already registered, push a route to OTP '
        'verification screen with args of 1) intl phone number, 2) '
        'OtpSuccessAction.goToHome, 3) timeout for OTP',
        (WidgetTester tester) async {
          when(() => accountAvailabilityCubit.state)
              .thenReturn(const AccountAvailabilityState());

          final controller = StreamController<AccountAvailabilityState>();
          controller.add(const AccountAvailabilityState());

          whenListen(
            accountAvailabilityCubit,
            controller.stream,
          );

          await tester.pumpWidget(
            buildMockLoginScreen(accountAvailabilityCubit, navigator),
          );

          const mockInput = '81234567890';
          const mockPhoneNumber = '+62$mockInput';

          await tester.enterText(finderInputPhoneNumber, mockInput);

          controller.add(
            const AccountAvailabilityState(
              status: AccountAvailabilityStatus.phoneAlreadyRegistered,
            ),
          );

          await tester.pumpAndSettle();

          final routes = verify(() => navigator.push(captureAny())).captured;

          expect(routes.length, 1);
          var route = routes.first;
          expect(route, isA<OtpVerificationRoute>());
          route = route as OtpVerificationRoute;
          expect(route.args?.successAction, OtpSuccessAction.goToHomeScreen);
          expect(route.args?.phoneNumberIntlFormat, mockPhoneNumber);
        },
      );

      testWidgets(
          '-- If an exception occurs, display a [DropezyBottomSheet] containing the error message',
          (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        const errMsg = 'Test error';
        const errStatusCode = 1;

        const displayedMessage = '$errStatusCode, $errMsg';

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
              status: AccountAvailabilityStatus.error,
              errMsg: errMsg,
              errStatusCode: errStatusCode,
            )
          ]),
        );

        await tester.pumpWidget(buildMockLoginScreen(accountAvailabilityCubit));

        await tester.pumpAndSettle();

        expect(find.byType(DropezyBottomSheet), findsOneWidget);
        expect(find.text(displayedMessage), findsOneWidget);
      });
    });
  });
}

Widget buildMockLoginScreen(
  AccountAvailabilityCubit cubit, [
  StackRouter? navigator,
  String? initialPhoneNumber,
]) =>
    buildMockScreenWithBlocProviderAndAutoRoute<AccountAvailabilityCubit>(
      cubit,
      LoginScreen(initialPhoneNumber: initialPhoneNumber),
      navigator,
    );
