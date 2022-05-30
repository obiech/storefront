import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/auth/index.dart';

class MockAccountVerificationCubit extends MockCubit<AccountVerificationState>
    implements AccountVerificationCubit {}

void main() {
  final Finder finderInputField =
      find.byKey(const Key(OtpInputField.keyInputField));

  final Finder finderErrorMessage =
      find.byKey(const Key(OtpInputField.keyErrorMessage));

  group('OTP Input Field', () {
    late AccountVerificationCubit cubit;

    setUp(() {
      cubit = MockAccountVerificationCubit();
    });

    testWidgets(
      'should call [AccountVerificationCubit.verifyOtp()] after 6 numbers has '
      'been entered.',
      (WidgetTester tester) async {
        // Mock Cubit functions
        when(() => cubit.state).thenAnswer(
          (_) => const AccountVerificationOtpIsSent(),
        );

        when(() => cubit.verifyOtp(any())).thenAnswer((_) async {});
        whenListen(cubit, Stream<AccountVerificationState>.fromIterable([]));
        await tester.pumpWidget(_buildMockAppWithOtpInputField(cubit));

        // Should not call verifyOtp(); only 1 character entered
        await tester.enterText(finderInputField, '1');
        await tester.pump();
        verifyNever(() => cubit.verifyOtp(any()));

        // Should not call verifyOtp(); only 2 character entered
        await tester.enterText(finderInputField, '12');
        await tester.pump();
        verifyNever(() => cubit.verifyOtp(any()));

        // Should not call verifyOtp(); only 3 character entered
        await tester.enterText(finderInputField, '123');
        await tester.pump();
        verifyNever(() => cubit.verifyOtp(any()));

        // Should not call verifyOtp(); only 4 character entered
        await tester.enterText(finderInputField, '1234');
        await tester.pump();
        verifyNever(() => cubit.verifyOtp(any()));

        // Should not call verifyOtp(); only 5 character entered
        await tester.enterText(finderInputField, '12345');
        await tester.pump();
        verifyNever(() => cubit.verifyOtp(any()));

        // SHOULD call verifyOtp(); 6 characters reached!
        await tester.enterText(finderInputField, '123456');
        await tester.pump();
        verify(() => cubit.verifyOtp('123456')).called(1);
      },
    );

    group(
      'is disabled when state has status that indicates loading state, i.e.',
      () {
        Future<void> expectTextFieldIsDisabled(
          WidgetTester tester,
          AccountVerificationState stateToTest,
        ) async {
          when(() => cubit.state).thenAnswer((_) => stateToTest);

          whenListen(
            cubit,
            Stream<AccountVerificationState>.fromIterable([]),
          );

          await tester.pumpWidget(_buildMockAppWithOtpInputField(cubit));

          await tester.enterText(finderInputField, '123456');
          await tester.pump();

          expect(find.text('123456'), findsNothing);
        }

        testWidgets(
          '[AccountVerificationStatus.initialState]',
          (WidgetTester tester) async {
            expectTextFieldIsDisabled(
              tester,
              const AccountVerificationInitial(),
            );
          },
        );
        testWidgets(
          '[AccountVerificationStatus.sendingOtp]',
          (WidgetTester tester) async {
            expectTextFieldIsDisabled(
              tester,
              const AccountVerificationLoading(),
            );
          },
        );
      },
    );

    testWidgets(
      'should display error message when cubit state is '
      '[AccountVerificationStatus.invalidOtp]',
      (WidgetTester tester) async {
        // Set cubit state to invalidOtp
        when(() => cubit.state)
            .thenAnswer((_) => const AccountVerificationInvalidOtp());

        whenListen(cubit, Stream<AccountVerificationState>.fromIterable([]));

        await tester.pumpWidget(_buildMockAppWithOtpInputField(cubit));

        expect(finderErrorMessage, findsOneWidget);
      },
    );
  });
}

Widget _buildMockAppWithOtpInputField(AccountVerificationCubit cubit) {
  return MaterialApp(
    home: Scaffold(
      body: BlocProvider<AccountVerificationCubit>.value(
        value: cubit,
        child: const Center(child: OtpInputField()),
      ),
    ),
  );
}
