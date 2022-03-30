import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/shared_widgets/widgets.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/otp_success_action.dart';
import 'package:storefront_app/features/auth/screens/registration/phone_already_registered_bottom_sheet.dart';

import '../../src/mock_navigator.dart';
import '../../src/mock_screen_utils.dart';

class MockAccountAvailabilityCubit extends MockCubit<AccountAvailabilityState>
    implements AccountAvailabilityCubit {}

void main() {
  late MockNavigator navigator;
  late AccountAvailabilityCubit accountAvailabilityCubit;

  final verifyPhoneButtonFinder =
      find.byKey(const Key(RegistrationScreen.keyVerifyPhoneNumberButton));

  setUp(() {
    navigator = createStubbedMockNavigator();
    accountAvailabilityCubit = MockAccountAvailabilityCubit();
    when(
      () => accountAvailabilityCubit.checkPhoneNumberAvailability(
        any(),
      ),
    ).thenAnswer(
      (_) async {},
    );
  });

  group('Registration Screen', () {
    testWidgets(' -- Ensure important elements are visible',
        (WidgetTester tester) async {
      when(() => accountAvailabilityCubit.state)
          .thenReturn(const AccountAvailabilityState());
      await tester.pumpWidget(
        buildMockRegistrationScreen(accountAvailabilityCubit, navigator),
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
          buildMockRegistrationScreen(
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
          buildMockRegistrationScreen(
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
          buildMockRegistrationScreen(
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
          '-- If phone number is available, pushes a route to OTP screen '
          'with currently entered phone number and '
          '[OtpSuccessBehavior.goToOtpVerificationScreen] as args',
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
          buildMockRegistrationScreen(accountAvailabilityCubit, navigator),
        );

        const mockInput = '81234567890';
        const mockPhoneNumber = '+62$mockInput';

        await tester.enterText(find.byType(PhoneTextField), mockInput);
        await tester.pumpAndSettle();

        // Push state to trigger navigation
        controller.add(
          const AccountAvailabilityState(
            status: AccountAvailabilityStatus.phoneIsAvailable,
          ),
        );

        await tester.pumpAndSettle();

        verifyPushNamed(
          navigator,
          OtpVerificationScreen.routeName,
          arguments: const OtpVerificationScreenArgs(
            successAction: OtpSuccessAction.goToPinScreen,
            phoneNumberIntlFormat: mockPhoneNumber,
            registerAccountAfterSuccessfulOtp: true,
          ),
        );
      });
      testWidgets('''
        -- If phone number is not available, display a 
        [PhoneAlreadyRegisteredBottomSheet]''', (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
              status: AccountAvailabilityStatus.phoneAlreadyRegistered,
            )
          ]),
        );

        await tester.pumpWidget(
          buildMockRegistrationScreen(accountAvailabilityCubit),
        );

        await tester.pumpAndSettle();

        expect(find.byType(PhoneAlreadyRegisteredBottomSheet), findsOneWidget);
      });

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

        await tester.pumpWidget(
          buildMockRegistrationScreen(accountAvailabilityCubit),
        );

        await tester.pumpAndSettle();

        expect(find.byType(DropezyBottomSheet), findsOneWidget);
        expect(find.text(displayedMessage), findsOneWidget);
      });
    });
  });
}

Widget buildMockRegistrationScreen(
  AccountAvailabilityCubit cubit, [
  MockNavigator? navigator,
  String? initialPhoneNumber,
]) =>
    buildMockScreenWithBlocProvider<AccountAvailabilityCubit>(
      cubit,
      RegistrationScreen(initialPhoneNumber: initialPhoneNumber),
      navigator,
    );
