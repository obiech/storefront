import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/bloc/account_verification/account_verification.dart';
import 'package:storefront_app/domain/auth/phone_verification_result.dart';
import 'package:storefront_app/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/services/auth/auth_service.dart';

import '../src/auth/mock_auth_service.dart';
import '../src/mock_customer_service_client.dart';
import '../src/mock_response_future.dart';

void main() {
  group('Account Verification Cubit', () {
    late CustomerServiceClient customerServiceClient;
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
      customerServiceClient = MockCustomerServiceClient();
      authService = MockAuthService();
    });

    test(
        'initial state status should be [initialState] and other '
        'properties should be unassigned', () {
      /// Return an empty stream
      mockPhoneVerificationStream(authService, []);

      final cubit =
          AccountVerificationCubit(authService, customerServiceClient);

      expect(
        cubit.state,
        const AccountVerificationState(
          status: AccountVerificationStatus.initialState,
          errMsg: null,
        ),
      );
    });

    blocTest<AccountVerificationCubit, AccountVerificationState>(
      '[sendOtp()] should return State with status of [sendingOtp]',
      setUp: () {
        /// Return an empty stream
        mockPhoneVerificationStream(authService, []);

        // /// Stub sendOtp function
        when(() => authService.sendOtp(any())).thenAnswer((_) async {});
      },
      build: () => AccountVerificationCubit(authService, customerServiceClient),
      act: (cubit) => cubit.sendOtp(dummyPhoneNumber),
      expect: () => const [
        AccountVerificationState(status: AccountVerificationStatus.sendingOtp),
      ],
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
          final cubit =
              AccountVerificationCubit(authService, customerServiceClient);
          cubit.otpIsSent = true;
          return cubit;
        },
        act: (cubit) => cubit.verifyOtp(dummyPhoneNumber),
        expect: () => const [
          AccountVerificationState(
              status: AccountVerificationStatus.verifyingOtp),
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
          final cubit =
              AccountVerificationCubit(authService, customerServiceClient);
          cubit.otpIsSent = false;
          return cubit;
        },
        act: (cubit) => cubit.verifyOtp(dummyPhoneNumber),
        expect: () => const [
          AccountVerificationState(
            status: AccountVerificationStatus.error,
            errMsg: 'OTP belum terkirim!',
          ),
        ],
      );
    });

    group(' -- react to events from [AuthService.phoneVerifcationStream]', () {
      blocTest<AccountVerificationCubit, AccountVerificationState>(
        '-- emit State with status [otpSent] after receiving [PhoneVerificationStatus.otpSent]',
        setUp: () {
          final mockEvents = [
            PhoneVerificationResult(status: PhoneVerificationStatus.otpSent)
          ];
          mockPhoneVerificationStream(authService, mockEvents);
        },
        build: () =>
            AccountVerificationCubit(authService, customerServiceClient),
        expect: () => const [
          AccountVerificationState(status: AccountVerificationStatus.otpSent),
        ],
      );

      blocTest<AccountVerificationCubit, AccountVerificationState>(
        '-- emit State with status [registeringAccount], call '
        '[CustomerServiceClient.register] once, and emit State with status '
        '[success] after receiving [PhoneVerificationStatus.verifiedSuccessfully]',
        setUp: () {
          final mockEvents = [
            PhoneVerificationResult(
                status: PhoneVerificationStatus.verifiedSuccessfully)
          ];

          mockPhoneVerificationStream(authService, mockEvents);

          mockCustomerServiceRegister(customerServiceClient,
              (_) => MockResponseFuture.value(dummyRegisterResponse));
        },
        build: () {
          final cubit =
              AccountVerificationCubit(authService, customerServiceClient);
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        },
        expect: () => const [
          AccountVerificationState(
              status: AccountVerificationStatus.registeringAccount),
          AccountVerificationState(status: AccountVerificationStatus.success),
        ],
        verify: (cubit) {
          verify(() => customerServiceClient.register(any())).called(1);
        },
      );

      blocTest<AccountVerificationCubit, AccountVerificationState>(
        '-- emit State with status [registeringAccount], call '
        '[CustomerServiceClient.register] once, and emit State with status [error]'
        'if registration fails',
        setUp: () {
          final mockEvents = [
            PhoneVerificationResult(
                status: PhoneVerificationStatus.verifiedSuccessfully)
          ];

          mockPhoneVerificationStream(authService, mockEvents);

          mockCustomerServiceRegister(
              customerServiceClient,
              (_) =>
                  MockResponseFuture.error(GrpcError.unknown('Dummy Error')));
        },
        build: () {
          final cubit =
              AccountVerificationCubit(authService, customerServiceClient);
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        },
        expect: () => const [
          AccountVerificationState(
              status: AccountVerificationStatus.registeringAccount),
          AccountVerificationState(
            status: AccountVerificationStatus.error,
            errMsg: 'Dummy Error',
          ),
        ],
        verify: (cubit) {
          verify(() => customerServiceClient.register(any())).called(1);
        },
      );

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

          mockCustomerServiceRegister(customerServiceClient,
              (_) => MockResponseFuture.value(dummyRegisterResponse));
        },
        build: () {
          final cubit =
              AccountVerificationCubit(authService, customerServiceClient);
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        },
        expect: () => const [
          AccountVerificationState(
            status: AccountVerificationStatus.invalidOtp,
            errMsg: 'OTP tidak valid!',
          ),
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

          mockCustomerServiceRegister(customerServiceClient,
              (_) => MockResponseFuture.value(dummyRegisterResponse));
        },
        build: () {
          final cubit =
              AccountVerificationCubit(authService, customerServiceClient);
          cubit.phoneNumber = dummyPhoneNumber;

          return cubit;
        },
        expect: () => const [
          AccountVerificationState(
            status: AccountVerificationStatus.error,
            errMsg: 'Dummy Error',
          ),
        ],
      );
    });
  });
}

void mockPhoneVerificationStream(
    AuthService authService, Iterable<PhoneVerificationResult> mockEvents) {
  when(() => authService.phoneVerificationStream)
      .thenAnswer((invocation) => Stream.fromIterable(mockEvents));
}

void mockCustomerServiceRegister(CustomerServiceClient mockClient,
    ResponseFuture<RegisterResponse> Function(Invocation) mockCallback) {
  when(() => mockClient.register(any())).thenAnswer(mockCallback);
}
