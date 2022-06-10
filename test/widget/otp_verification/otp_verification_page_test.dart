import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/auth/index.dart';

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
    when(() => prefs.isOnBoarded()).thenAnswer((_) => true);
    when(() => prefs.getDeviceLocale())
        .thenAnswer((_) => const Locale('en', 'EN'));

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
          .thenReturn(const AccountVerificationInitial());

      await tester.pumpWidget(
        buildMockOtpVerificationPage(
          cubit: accountVerificationCubit,
          phoneNumberIntlFormat: mockPhoneNumberIntl,
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
              .thenReturn(const AccountVerificationInitial());

          whenListen(
            accountVerificationCubit,
            Stream.fromIterable([
              const AccountVerificationInitial(),
              const AccountVerificationSuccess(),
            ]),
          );

          await tester.pumpWidget(
            buildMockOtpVerificationPage(
              cubit: accountVerificationCubit,
              navigator: navigator,
              phoneNumberIntlFormat: mockPhoneNumberIntl,
              successAction: OtpSuccessAction.goToHomePage,
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
              .thenReturn(const AccountVerificationInitial());

          whenListen(
            accountVerificationCubit,
            Stream.fromIterable([
              const AccountVerificationInitial(),
              const AccountVerificationSuccess(),
            ]),
          );

          await tester.pumpWidget(
            buildMockOtpVerificationPage(
              cubit: accountVerificationCubit,
              navigator: navigator,
              phoneNumberIntlFormat: mockPhoneNumberIntl,
              successAction: OtpSuccessAction.goToPinPage,
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
              .thenReturn(const AccountVerificationInitial());

          final controller = StreamController<AccountVerificationState>();
          controller.add(const AccountVerificationInitial());

          const errMsg = 'Dummy Error';
          whenListen(
            accountVerificationCubit,
            controller.stream,
          );

          await tester.pumpWidget(
            buildMockOtpVerificationPage(
              cubit: accountVerificationCubit,
              phoneNumberIntlFormat: mockPhoneNumberIntl,
            ),
          );

          controller.add(const AccountVerificationError(errMsg));

          await tester.pumpAndSettle();

          expect(find.byType(DropezyBottomSheet), findsOneWidget);
          expect(find.text(errMsg), findsOneWidget);
        },
      );
    });
  });
}

Widget buildMockOtpVerificationPage({
  required String phoneNumberIntlFormat,
  OtpSuccessAction? successAction,
  required AccountVerificationCubit cubit,
  StackRouter? navigator,
}) =>
    buildMockPageWithBlocProviderAndAutoRoute<AccountVerificationCubit>(
      cubit,
      OtpVerificationPage(
        phoneNumberIntlFormat: phoneNumberIntlFormat,
        successAction: successAction ?? OtpSuccessAction.goToHomePage,
        timeoutInSeconds: 10,
      ),
      navigator,
    );
