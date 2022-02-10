import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/bloc/account_availability/account_availability.dart';
import 'package:storefront_app/ui/login/phone_not_registered_bottom_sheet.dart';
import 'package:storefront_app/ui/pin_input/pin_input_screen.dart';
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
  late AccountAvailabilityCubit phoneVerificationCubit;

  final verifyPhoneButtonFinder =
      find.byKey(const Key(LoginScreen.keyVerifyPhoneNumberButton));

  setUp(() {
    navigator = createStubbedMockNavigator();
    phoneVerificationCubit = MockAccountAvailabilityCubit();
  });

  group('Login Screen', () {
    testWidgets(' -- Ensure important elements are visible',
        (WidgetTester tester) async {
      when(() => phoneVerificationCubit.state)
          .thenReturn(const AccountAvailabilityState());
      await tester
          .pumpWidget(buildMockLoginScreen(phoneVerificationCubit, navigator));

      expect(find.byType(PhoneTextField), findsOneWidget);
      expect(verifyPhoneButtonFinder, findsOneWidget);
      expect(find.byType(TextUserAgreement), findsOneWidget);
    });

    group('Test phone verification', () {
      testWidgets(''' -- After entering phone number and tapping Submit button,
        [AccountAvailabilityCubit.verifyPhone] will be called with argument
        of +62 concatenated with user input''', (WidgetTester tester) async {
        when(() => phoneVerificationCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          phoneVerificationCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
          ]),
        );

        await tester.pumpWidget(
            buildMockLoginScreen(phoneVerificationCubit, navigator));

        const mockInput = "81234567890";
        const mockPhoneNumber = "+62$mockInput";

        await tester.enterText(find.byType(PhoneTextField), mockInput);
        await tester.tap(verifyPhoneButtonFinder);
        await tester.pumpAndSettle();

        verify(() => phoneVerificationCubit
            .checkPhoneNumberAvailability(mockPhoneNumber)).called(1);
      });
      testWidgets(
          '''-- If phone number is available, displays a [PhoneNotRegisteredBottomSheet]''',
          (WidgetTester tester) async {
        when(() => phoneVerificationCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          phoneVerificationCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
                status: AccountAvailabilityStatus.phoneIsAvailable)
          ]),
        );

        await tester.pumpWidget(buildMockLoginScreen(phoneVerificationCubit));

        await tester.pumpAndSettle();

        expect(find.byType(PhoneNotRegisteredBottomSheet), findsOneWidget);
      });
      testWidgets(
          '''-- If phone number is already registered, push a route to PIN input screen''',
          (WidgetTester tester) async {
        when(() => phoneVerificationCubit.state)
            .thenReturn(const AccountAvailabilityState());

        whenListen(
          phoneVerificationCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
                status: AccountAvailabilityStatus.phoneAlreadyRegistered)
          ]),
        );

        await tester.pumpWidget(
            buildMockLoginScreen(phoneVerificationCubit, navigator));

        await tester.pumpAndSettle();
        verifyRouteIsPushed(navigator, PinInputScreen.routeName);
      });

      testWidgets(
          '-- If an exception occurs, display a [DropezyBottomSheet] containing the error message',
          (WidgetTester tester) async {
        when(() => phoneVerificationCubit.state)
            .thenReturn(const AccountAvailabilityState());

        const errMsg = 'Test error';
        const errStatusCode = 1;

        const displayedMessage = '$errStatusCode, $errMsg';

        whenListen(
          phoneVerificationCubit,
          Stream.fromIterable([
            const AccountAvailabilityState(),
            const AccountAvailabilityState(
              status: AccountAvailabilityStatus.error,
              errMsg: errMsg,
              errStatusCode: errStatusCode,
            )
          ]),
        );

        await tester
            .pumpWidget(buildMockLoginScreen(phoneVerificationCubit, null));

        await tester.pumpAndSettle();

        expect(find.byType(DropezyBottomSheet), findsOneWidget);
        expect(find.text(displayedMessage), findsOneWidget);
      });
    });
  });
}

Widget buildMockLoginScreen(AccountAvailabilityCubit cubit,
        [MockNavigator? navigator]) =>
    buildMockScreenWithBlocProvider<AccountAvailabilityCubit>(
        cubit, const LoginScreen(), navigator);
