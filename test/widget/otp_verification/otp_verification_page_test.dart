import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/pages/otp_verification/otp_input_field.dart';
import 'package:storefront_app/features/auth/pages/otp_verification/otp_success_action.dart';
import 'package:storefront_app/features/auth/pages/otp_verification/resend_otp_timer.dart';

import '../../src/mock_customer_service_client.dart';
import '../../src/mock_navigator.dart';
import '../../src/mock_page_utils.dart';

class MockAccountVerificationCubit extends MockCubit<AccountVerificationState>
    implements AccountVerificationCubit {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'env/.env');
  // configureInjection(determineEnvironment());

  late StackRouter navigator;
  late IPrefsRepository prefs;
  late AccountVerificationCubit accountVerificationCubit;

  const mockPhoneNumberIntl = '+6281234567890';
  final mockPhoneNumberLocal = mockPhoneNumberIntl.replaceAll('+62', '0');

  setUp(() {
    accountVerificationCubit = MockAccountVerificationCubit();

    // Router stubs
    registerFallbackValue(FakePageRouteInfo());
    navigator = MockStackRouter();
    when(() => navigator.push(any())).thenAnswer((_) async => null);
    when(() => navigator.replaceAll(any())).thenAnswer((_) async => {});

    prefs = MockIPrefsRepository();

    if (getIt.isRegistered<IPrefsRepository>()) {
      getIt.unregister<IPrefsRepository>();
    }

    when(() => prefs.setIsOnBoarded(any())).thenAnswer((_) async => {});
    when(() => prefs.isOnBoarded()).thenAnswer((_) async => true);

    getIt.registerSingleton<IPrefsRepository>(prefs);
  });

  group('OTP Verification Page', () {
    // Test important elements are visible
    // Test navigation for Login
    // Test navigation for Registration
    // Test error handling
    testWidgets('should display important Widgets when opened',
        (WidgetTester tester) async {
      when(() => accountVerificationCubit.state)
          .thenReturn(const AccountVerificationState());

      await tester.pumpWidget(
        buildMockOtpVerificationPage(
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
        '[HomePage] if [successBehavior] is set to [goToHome]',
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
            buildMockOtpVerificationPage(
              cubit: accountVerificationCubit,
              navigator: navigator,
              args: argsForLogin(mockPhoneNumberIntl),
            ),
          );

          final routeStack = verify(() => navigator.replaceAll(captureAny()))
              .captured
              .first as List<PageRouteInfo>;

          expect(routeStack.length, 1);
          expect(routeStack.first, isA<MainRoute>());

          verify(() => prefs.setIsOnBoarded(true)).called(1);
        },
      );

      testWidgets(
        '[PinInputPage] if [successBehavior] is set to [goToPinPage]',
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
            buildMockOtpVerificationPage(
              cubit: accountVerificationCubit,
              navigator: navigator,
              args: argsForRegistration(mockPhoneNumberIntl),
            ),
          );

          final routes = verify(() => navigator.push(captureAny())).captured;

          expect(routes.length, 1);
          expect(routes.first, isA<PinInputRoute>());
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
            buildMockOtpVerificationPage(
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

Widget buildMockOtpVerificationPage({
  required OtpVerificationPageArgs args,
  required AccountVerificationCubit cubit,
  StackRouter? navigator,
}) =>
    buildMockPageWithBlocProviderAndAutoRoute<AccountVerificationCubit>(
      cubit,
      OtpVerificationPage(
        phoneNumberIntlFormat: args.phoneNumberIntlFormat,
        successAction: args.successAction,
        timeoutInSeconds: 10,
      ),
      navigator,
    );

OtpVerificationPageArgs argsForLogin(String phone) => OtpVerificationPageArgs(
      successAction: OtpSuccessAction.goToHomePage,
      phoneNumberIntlFormat: phone,
    );

OtpVerificationPageArgs argsForRegistration(String phone) =>
    OtpVerificationPageArgs(
      successAction: OtpSuccessAction.goToPinPage,
      phoneNumberIntlFormat: phone,
    );