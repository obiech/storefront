import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/bloc/account_availability/account_availability.dart';
import 'package:storefront_app/ui/otp_verification/otp_success_action.dart';
import 'package:storefront_app/ui/otp_verification/otp_verification_screen.dart';
import 'package:storefront_app/ui/otp_verification/otp_verification_screen_args.dart';
import 'package:storefront_app/ui/registration/phone_already_registered_bottom_sheet.dart';
import 'package:storefront_app/ui/screens.dart';
import 'package:storefront_app/ui/widgets/bottom_sheet/dropezy_bottom_sheet.dart';
import 'package:storefront_app/ui/widgets/text_fields/phone_text_field.dart';
import 'package:storefront_app/ui/widgets/text_user_agreement.dart';

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
  });

  group('Registration Screen', () {
    testWidgets(' -- Ensure important elements are visible',
        (WidgetTester tester) async {
      when(() => accountAvailabilityCubit.state)
          .thenReturn(const AccountAvailabilityState());
      await tester.pumpWidget(
          buildMockRegistrationScreen(accountAvailabilityCubit, navigator));

      expect(find.byType(PhoneTextField), findsOneWidget);
      expect(verifyPhoneButtonFinder, findsOneWidget);
      expect(find.byType(TextUserAgreement), findsOneWidget);
    });

    group('Test phone verification', () {
      testWidgets(''' -- After entering phone number and tapping Submit button,
        [AccountAvailabilityCubit.verifyPhone] will be called with argument
        of +62 concatenated with user input''', (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
          ]),
        );

        await tester.pumpWidget(
            buildMockRegistrationScreen(accountAvailabilityCubit, navigator));

        const mockInput = "81234567890";
        const mockPhoneNumber = "+62$mockInput";

        await tester.enterText(find.byType(PhoneTextField), mockInput);
        await tester.tap(verifyPhoneButtonFinder);
        await tester.pumpAndSettle();

        verify(() => accountAvailabilityCubit
            .checkPhoneNumberAvailability(mockPhoneNumber)).called(1);
      });
      testWidgets(
          '-- If phone number is available, pushes a route to OTP screen '
          'with currently entered phone number and '
          '[OtpSuccessBehavior.goToPinScreen] as args',
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
            buildMockRegistrationScreen(accountAvailabilityCubit, navigator));

        const mockInput = "81234567890";
        const mockPhoneNumber = "+62$mockInput";

        await tester.enterText(find.byType(PhoneTextField), mockInput);
        await tester.pumpAndSettle();

        // Push state to trigger navigation
        controller.add(const AccountAvailabilityState(
            status: AccountAvailabilityStatus.phoneIsAvailable));

        await tester.pumpAndSettle();

        verifyRouteIsPushed(
          navigator,
          OtpVerificationScreen.routeName,
          arguments: const OtpVerificationScreenArgs(
            successAction: OtpSuccessAction.goToPinScreen,
            phoneNumberIntlFormat: mockPhoneNumber,
          ),
        );
      });
      testWidgets('''-- If phone number is not available, display a 
        [PhoneAlreadyRegisteredBottomSheet]''', (WidgetTester tester) async {
        when(() => accountAvailabilityCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          accountAvailabilityCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
                status: AccountAvailabilityStatus.phoneAlreadyRegistered)
          ]),
        );

        await tester.pumpWidget(
            buildMockRegistrationScreen(accountAvailabilityCubit, null));

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
            buildMockRegistrationScreen(accountAvailabilityCubit, null));

        await tester.pumpAndSettle();

        expect(find.byType(DropezyBottomSheet), findsOneWidget);
        expect(find.text(displayedMessage), findsOneWidget);
      });
    });
  });
}

Widget buildMockRegistrationScreen(
        AccountAvailabilityCubit cubit, MockNavigator? navigator) =>
    buildMockScreenWithBlocProvider<AccountAvailabilityCubit>(
        cubit, const RegistrationScreen(), navigator);
