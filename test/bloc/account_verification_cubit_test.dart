import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/domain/repository/phone_verification_result.dart';
import 'package:storefront_app/features/auth/domain/services/auth_service.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../src/auth/mock_auth_service.dart';
import '../src/mock_customer_service_client.dart';

void main() {
  group('Account Verification Cubit', () {
    late ICustomerRepository customerRepository;
    late AuthService authService;

    const dummyPhoneNumber = '+6281234567890';

    final Profile dummyProfile = Profile(
      devices: [],
      phoneNumber: dummyPhoneNumber,
      id: '123',
    );

    final RegisterResponse dummyRegisterResponse =
        RegisterResponse(profile: dummyProfile);

    setUpAll(() {
      registerFallbackValue(RegisterRequest(phoneNumber: dummyPhoneNumber));
      registerFallbackValue(dummyRegisterResponse);
    });

    setUp(() {
      customerRepository = MockCustomerRepository();
      authService = MockAuthService();
    });

    test(
        'initial state status should be [initialState] and other '
        'properties should be unassigned', () {
      /// Return an empty stream
      mockPhoneVerificationStream(authService, []);

      final cubit = AccountVerificationCubit(
        authService,
        customerRepository,
        true,
      );

      expect(cubit.state, const AccountVerificationInitial());
    });

    blocTest<AccountVerificationCubit, AccountVerificationState>(
      '[sendOtp()] should call [authService.sendOtp] '
      'and emit AccountVerificationLoading '
      'when [isRegistration] is false',
      setUp: () {
        /// Return an empty stream
        mockPhoneVerificationStream(authService, []);

        // /// Stub sendOtp function
        when(() => authService.sendOtp(any())).thenAnswer((_) async {});
      },
      build: () => AccountVerificationCubit(
        authService,
        customerRepository,
        false,
      ),
      act: (cubit) => cubit.sendOtp(dummyPhoneNumber),
      expect: () => const [
        AccountVerificationLoading(),
      ],
      verify: (cubit) {
        verifyNever(
          () => customerRepository.registerPhoneNumber(dummyPhoneNumber),
        );
        verify(() => authService.sendOtp(dummyPhoneNumber)).called(1);
      },
    );

    blocTest<AccountVerificationCubit, AccountVerificationState>(
      '[sendOtp()] should call [customerRepository.registerPhoneNumber] '
      'and call [authService.sendOtp] '
      'and emit AccountVerificationLoading '
      'when [isRegistration] is true '
      'and [customerRepository.registerPhoneNumber] is successful',
      setUp: () {
        /// Return an empty stream
        mockPhoneVerificationStream(authService, []);

        when(() => customerRepository.registerPhoneNumber(any()))
            .thenAnswer((_) async {
          return right(unit);
        });

        // /// Stub sendOtp function
        when(() => authService.sendOtp(any())).thenAnswer((_) async {});
      },
      build: () => AccountVerificationCubit(
        authService,
        customerRepository,
        true,
      ),
      act: (cubit) => cubit.sendOtp(dummyPhoneNumber),
      expect: () => const [
        AccountVerificationLoading(),
      ],
      verify: (cubit) {
        verify(() => customerRepository.registerPhoneNumber(dummyPhoneNumber))
            .called(1);
        verify(() => authService.sendOtp(dummyPhoneNumber)).called(1);
      },
    );

    blocTest<AccountVerificationCubit, AccountVerificationState>(
      '[sendOtp()] should call [customerRepository.registerPhoneNumber] '
      'and NOT call [authService.sendOtp] '
      'and emit AccountVerificationError '
      'when [isRegistration] is false '
      'and [customerRepository.registerPhoneNumber] returns a Failure',
      setUp: () {
        /// Return an empty stream
        mockPhoneVerificationStream(authService, []);

        when(() => customerRepository.registerPhoneNumber(any()))
            .thenAnswer((_) async {
          return left(Failure('Test Error'));
        });

        // /// Stub sendOtp function
        when(() => authService.sendOtp(any())).thenAnswer((_) async {});
      },
      build: () => AccountVerificationCubit(
        authService,
        customerRepository,
        true,
      ),
      act: (cubit) => cubit.sendOtp(dummyPhoneNumber),
      expect: () => const [
        AccountVerificationLoading(),
        AccountVerificationError('Test Error'),
      ],
      verify: (cubit) {
        verify(() => customerRepository.registerPhoneNumber(dummyPhoneNumber))
            .called(1);
        verifyNever(() => authService.sendOtp(dummyPhoneNumber));
      },
    );

    group('[verifyOtp()]', () {
      blocTest<AccountVerificationCubit, AccountVerificationState>(
        'should return State with status of [verifyingOtp]',
        setUp: () {
          /// Return an empty stream
          mockPhoneVerificationStream(authService, []);

          // /// Stub sendOtp function
          when(() => authService.verifyOtp(any())).thenAnswer((_) async {});
        },
        build: () {
          final cubit = AccountVerificationCubit(
            authService,
            customerRepository,
            false,
          );
          cubit.otpIsSent = true;
          return cubit;
        },
        act: (cubit) => cubit.verifyOtp(dummyPhoneNumber),
        expect: () => const [
          AccountVerificationLoading(),
        ],
      );
      blocTest<AccountVerificationCubit, AccountVerificationState>(
        'should return State with status of [error] if [otpIsSent] is false',
        setUp: () {
          /// Return an empty stream
          mockPhoneVerificationStream(authService, []);

          // /// Stub sendOtp function
          when(() => authService.verifyOtp(any())).thenAnswer((_) async {});
        },
        build: () {
          final cubit = AccountVerificationCubit(
            authService,
            customerRepository,
            false,
          );
          cubit.otpIsSent = false;
          return cubit;
        },
        act: (cubit) => cubit.verifyOtp(dummyPhoneNumber),
        expect: () => const [
          AccountVerificationError('OTP belum terkirim!'),
        ],
      );
    });

    group(' -- react to events from [AuthService.phoneVerificationStream]', () {
      blocTest<AccountVerificationCubit, AccountVerificationState>(
        '-- emit State with status [otpSent] after receiving [PhoneVerificationStatus.otpSent]',
        setUp: () {
          final mockEvents = [
            PhoneVerificationResult(status: PhoneVerificationStatus.otpSent)
          ];
          mockPhoneVerificationStream(authService, mockEvents);
        },
        build: () => AccountVerificationCubit(
          authService,
          customerRepository,
          true,
        ),
        expect: () => const [
          AccountVerificationOtpIsSent(),
        ],
      );

      group(
          '-- after receiving [PhoneVerificationStatus.verifiedSuccessfully] ',
          () {
        void setupFn() {
          // Emit phone verification success event
          final mockEvents = [
            PhoneVerificationResult(
              status: PhoneVerificationStatus.verifiedSuccessfully,
            )
          ];

          mockPhoneVerificationStream(authService, mockEvents);
        }

        AccountVerificationCubit buildFn(
          bool isRegistration,
        ) {
          final cubit = AccountVerificationCubit(
            authService,
            customerRepository,
            isRegistration,
          );
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        }

        blocTest<AccountVerificationCubit, AccountVerificationState>(
          'should emit State with status [AccountVerificationStatus.success] ',
          setUp: () {
            setupFn();
          },
          build: () => buildFn(false),
          expect: () => const [
            AccountVerificationSuccess(),
          ],
        );
      });

      blocTest<AccountVerificationCubit, AccountVerificationState>(
        '-- emit State with status [invalidOtp] and error message after receiving '
        '[PhoneVerificationStatus.invalidOtp]',
        setUp: () {
          final mockEvents = [
            PhoneVerificationResult(
              status: PhoneVerificationStatus.invalidOtp,
              exception: const PhoneVerificationException('OTP tidak valid!'),
            )
          ];

          mockPhoneVerificationStream(authService, mockEvents);
        },
        build: () {
          final cubit = AccountVerificationCubit(
            authService,
            customerRepository,
            false,
          );
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        },
        expect: () => const [
          AccountVerificationInvalidOtp(),
        ],
      );

      blocTest<AccountVerificationCubit, AccountVerificationState>(
        '-- emit State with status [error] and error message after receiving '
        '[PhoneVerificationStatus.error]',
        setUp: () {
          final mockEvents = [
            PhoneVerificationResult(
              status: PhoneVerificationStatus.error,
              exception: const PhoneVerificationException('Dummy Error'),
            )
          ];

          mockPhoneVerificationStream(authService, mockEvents);
        },
        build: () {
          final cubit = AccountVerificationCubit(
            authService,
            customerRepository,
            false,
          );
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        },
        expect: () => const [AccountVerificationError('Dummy Error')],
      );
    });
  });
}

void mockPhoneVerificationStream(
  AuthService authService,
  Iterable<PhoneVerificationResult> mockEvents,
) {
  when(() => authService.phoneVerificationStream)
      .thenAnswer((invocation) => Stream.fromIterable(mockEvents));
}

void mockCustomerServiceRegister(
  ICustomerRepository customerRepository,
  RepoResult<Unit> Function(Invocation) mockCallback,
) {
  when(() => customerRepository.registerPhoneNumber(any()))
      .thenAnswer(mockCallback);
}
