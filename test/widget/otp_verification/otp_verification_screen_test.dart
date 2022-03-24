import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/shared_widgets/widgets.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/otp_input_field.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/otp_success_action.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/resend_otp_timer.dart';
import 'package:storefront_app/features/auth/screens/screens.dart';
import 'package:storefront_app/features/home/index.dart';

import '../../src/mock_navigator.dart';
import '../../src/mock_screen_utils.dart';

class MockAccountVerificationCubit extends MockCubit<AccountVerificationState>
    implements AccountVerificationCubit {}

void main() {
  late MockNavigator navigator;
  late AccountVerificationCubit accountVerificationCubit;

  const mockPhoneNumberIntl = '+6281234567890';
  final mockPhoneNumberLocal = mockPhoneNumberIntl.replaceAll('+62', '0');

  setUp(() {
    navigator = createStubbedMockNavigator();
    accountVerificationCubit = MockAccountVerificationCubit();
  });

  group('OTP Verification Screen', () {
    // Test important elements are visible
    // Test navigation for Login
    // Test navigation for Registration
    // Test error handling
    testWidgets('should display important Widgets when opened',
        (WidgetTester tester) async {
      when(() => accountVerificationCubit.state)
          .thenReturn(const AccountVerificationState());

      await tester.pumpWidget(
        buildMockOtpVerificationScreen(
          cubit: accountVerificationCubit,
          args: argsForLogin(mockPhoneNumberIntl),
        ),
      );

      expect(find.text('Verifikasi Ponsel Kamu'), findsOneWidget);
      expect(
        find.text('Kode OTP telah dikirimkan ke nomor $mockPhoneNumberLocal'),
        findsOneWidget,
      );
      expect(find.byType(OtpInputField), findsOneWidget);
      expect(find.byType(ResendOtpTimer), findsOneWidget);
    });

    group('on successful OTP verification should navigate to', () {
      testWidgets(
        '[HomeScreen] if [successBehavior] is set to [goToHome]',
        (WidgetTester tester) async {
          when(() => accountVerificationCubit.state)
              .thenReturn(const AccountVerificationState());

          whenListen(
            accountVerificationCubit,
            Stream.fromIterable([
              const AccountVerificationState(),
              const AccountVerificationState(
                status: AccountVerificationStatus.success,
              ),
            ]),
          );

          await tester.pumpWidget(
            buildMockOtpVerificationScreen(
              cubit: accountVerificationCubit,
              navigator: navigator,
              args: argsForLogin(mockPhoneNumberIntl),
            ),
          );

          verifyPushNamedAndRemoveUntil(
            navigator,
            HomeScreen.routeName,
          );
        },
      );

      testWidgets(
        '[PinInputScreen] if [successBehavior] is set to [goToPinScreen]',
        (WidgetTester tester) async {
          when(() => accountVerificationCubit.state)
              .thenReturn(const AccountVerificationState());

          whenListen(
            accountVerificationCubit,
            Stream.fromIterable([
              const AccountVerificationState(),
              const AccountVerificationState(
                status: AccountVerificationStatus.success,
              ),
            ]),
          );

          await tester.pumpWidget(
            buildMockOtpVerificationScreen(
              cubit: accountVerificationCubit,
              navigator: navigator,
              args: argsForRegistration(mockPhoneNumberIntl),
            ),
          );

          verifyRouteIsPushed(
            navigator,
            PinInputScreen.routeName,
          );
        },
      );

      testWidgets(
        'display a [DropezyBottomSheet] containing the error message when an '
        'error State is emitted.',
        (WidgetTester tester) async {
          when(() => accountVerificationCubit.state)
              .thenReturn(const AccountVerificationState());

          final controller = StreamController<AccountVerificationState>();
          controller.add(const AccountVerificationState());

          const errMsg = 'Dummy Error';
          whenListen(
            accountVerificationCubit,
            controller.stream,
          );

          await tester.pumpWidget(
            buildMockOtpVerificationScreen(
              cubit: accountVerificationCubit,
              args: argsForLogin(mockPhoneNumberIntl),
            ),
          );

          controller.add(
            const AccountVerificationState(
              status: AccountVerificationStatus.error,
              errMsg: errMsg,
            ),
          );

          await tester.pumpAndSettle();

          expect(find.byType(DropezyBottomSheet), findsOneWidget);
          expect(find.text(errMsg), findsOneWidget);
        },
      );
    });
  });
}

Widget buildMockOtpVerificationScreen({
  required OtpVerificationScreenArgs args,
  required AccountVerificationCubit cubit,
  MockNavigator? navigator,
}) =>
    buildMockScreenWithBlocProvider<AccountVerificationCubit>(
      cubit,
      OtpVerificationScreen(
        phoneNumberIntlFormat: args.phoneNumberIntlFormat,
        successAction: args.successAction,
        timeoutInSeconds: 10,
      ),
      navigator,
    );

OtpVerificationScreenArgs argsForLogin(String phone) =>
    OtpVerificationScreenArgs(
      successAction: OtpSuccessAction.goToHomeScreen,
      phoneNumberIntlFormat: phone,
    );

OtpVerificationScreenArgs argsForRegistration(String phone) =>
    OtpVerificationScreenArgs(
      successAction: OtpSuccessAction.goToPinScreen,
      phoneNumberIntlFormat: phone,
    );
