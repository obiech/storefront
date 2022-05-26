import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/auth/pages/otp_verification/resend_otp_timer.dart';

class MockAccountVerificationCubit extends MockCubit<AccountVerificationState>
    implements AccountVerificationCubit {}

class MockFunction extends Mock {
  void call();
}

void main() {
  final Finder finderResendOtpTimerWidget = find.byType(ResendOtpTimer);
  final Finder finderTextCountdown =
      find.byKey(const Key(ResendOtpTimer.keyTextCountdown));
  final Finder finderTextResend =
      find.byKey(const Key(ResendOtpTimer.keyTextResend));

  group('Resend OTP Timer', () {
    final VoidCallback mockCallback = MockFunction();

    testWidgets(
      'should initialize a timer with time specified in its '
      'contructor and show Countdown text and not Resend text',
      (WidgetTester tester) async {
        const waitPeriod = 30;

        await tester.pumpWidget(
          _buildMockAppWithResendOtpTimer(mockCallback, waitPeriod),
        );
        final ResendOtpTimerState state =
            tester.state(finderResendOtpTimerWidget);

        // Expect timer is initialized and starts counting down at [waitPeriod]
        expect(state.secsBeforeEnablingResend, waitPeriod);
        expect(state.otpTimer.isActive, true);

        // Expect countdown text is shown but not Resend text
        expect(finderTextCountdown, findsOneWidget);
        expect(finderTextResend, findsNothing);
      },
    );

    testWidgets(
      'should show Resend Text and not Countdown text after specified wait '
      'period has elapsed. On clicking Resend, onResend callback '
      'will trigger, and state will be reset.',
      (WidgetTester tester) async {
        const waitPeriod = 30;

        await tester.pumpWidget(
          _buildMockAppWithResendOtpTimer(mockCallback, waitPeriod),
        );
        final ResendOtpTimerState state =
            tester.state(finderResendOtpTimerWidget);

        // additional 5s to ensure timer has fully elapsed
        await tester.pumpAndSettle(const Duration(seconds: waitPeriod + 5));

        // After waitPeriod as elapsed,
        // Expect Resend text is shown but not countdown text
        expect(finderTextCountdown, findsNothing);
        expect(finderTextResend, findsOneWidget);

        when(() => mockCallback.call()).thenAnswer((invocation) {});

        // Tapping on Resend should call mockCallback
        verifyNever(() => mockCallback.call());
        await tester.tap(finderTextResend);
        verify(() => mockCallback.call()).called(1);

        // State should be reset
        await tester.pumpAndSettle();
        expect(state.secsBeforeEnablingResend, waitPeriod);
        expect(state.otpTimer.isActive, true);
        expect(finderTextCountdown, findsOneWidget);
        expect(finderTextResend, findsNothing);
      },
    );
  });
}

Widget _buildMockAppWithResendOtpTimer(
  VoidCallback callback, [
  int waitPeriod = 60,
]) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: ResendOtpTimer(
          onResendTap: callback,
          resendWaitPeriodInSeconds: waitPeriod,
        ),
      ),
    ),
  );
}
