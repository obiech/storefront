import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/core/services/prefs/i_prefs_repository.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../src/mock_customer_service_client.dart';
import '../src/mock_response_future.dart';

void main() {
  group('Account Availability Cubit', () {
    late CustomerServiceClient customerServiceClient;
    late IPrefsRepository prefsRepository;

    /// Setup default request
    setUpAll(() {
      registerFallbackValue(CheckRequest(phoneNumber: '+6281234567890'));
    });

    /// Initialize new client for each test
    setUp(() {
      customerServiceClient = MockCustomerServiceClient();
      prefsRepository = MockIPrefsRepository();
    });

    test(
        'Initial state status should be [AccountAvailabilityStatus.initialState]',
        () {
      final cubit =
          AccountAvailabilityCubit(customerServiceClient, prefsRepository);

      expect(
        cubit.state,
        const AccountAvailabilityState(
          status: AccountAvailabilityStatus.initialState,
        ),
      );
    });

    blocTest<AccountAvailabilityCubit, AccountAvailabilityState>(
      '''
      Phone number is available for registration; 
      should return State with [AccountAvailabilityStatus.loading]
      followed by State with [AccountAvailabilityStatus.phoneIsAvailable]''',
      setUp: () {
        mockClientResponse(
          customerServiceClient,
          (_) => MockResponseFuture.error(
            GrpcError.notFound('Profile not found!'),
          ),
        );

        when(() => prefsRepository.setUserPhoneNumber(any()))
            .thenAnswer((_) async => {});
      },
      build: () =>
          AccountAvailabilityCubit(customerServiceClient, prefsRepository),
      act: (cubit) => cubit.checkPhoneNumberAvailability('+6281234567890'),
      expect: () => const [
        AccountAvailabilityState(status: AccountAvailabilityStatus.loading),
        AccountAvailabilityState(
          status: AccountAvailabilityStatus.phoneIsAvailable,
          errStatusCode: StatusCode.notFound,
        ),
      ],
    );

    blocTest<AccountAvailabilityCubit, AccountAvailabilityState>(
      '''
      Phone number is already registered; 
      should return State with [AccountAvailabilityStatus.loading]
      followed by State with [AccountAvailabilityStatus.phoneAlreadyRegistered]''',
      setUp: () {
        final fakeDevice = Device(
          fingerprint: 'asd',
          name: 'Mock Phone',
          pin: '123456',
        );

        final successCheckResponse = CheckResponse(
          profile: Profile(
            phoneNumber: '081234567890',
            devices: [fakeDevice],
          ),
        );

        mockClientResponse(
          customerServiceClient,
          (_) => MockResponseFuture.value(successCheckResponse),
        );

        when(() => prefsRepository.setUserPhoneNumber(any()))
            .thenAnswer((_) async => {});
      },
      build: () =>
          AccountAvailabilityCubit(customerServiceClient, prefsRepository),
      act: (cubit) => cubit.checkPhoneNumberAvailability('+6281234567890'),
      expect: () => const [
        AccountAvailabilityState(status: AccountAvailabilityStatus.loading),
        AccountAvailabilityState(
          status: AccountAvailabilityStatus.phoneAlreadyRegistered,
        ),
      ],
    );

    blocTest<AccountAvailabilityCubit, AccountAvailabilityState>(
      '''
      Failed request; 
      should return State with [AccountAvailabilityStatus.loading]
      followed by State with [AccountAvailabilityStatus.phoneAlreadyRegistered]''',
      setUp: () {
        mockClientResponse(
          customerServiceClient,
          (_) => MockResponseFuture.error(
            GrpcError.deadlineExceeded('Connection timed out'),
          ),
        );

        when(() => prefsRepository.setUserPhoneNumber(any()))
            .thenAnswer((_) async => {});
      },
      build: () =>
          AccountAvailabilityCubit(customerServiceClient, prefsRepository),
      act: (cubit) => cubit.checkPhoneNumberAvailability('+6281234567890'),
      expect: () => const [
        AccountAvailabilityState(status: AccountAvailabilityStatus.loading),
        AccountAvailabilityState(
          status: AccountAvailabilityStatus.error,
          errMsg: 'Connection timed out',
          errStatusCode: StatusCode.deadlineExceeded,
        ),
      ],
    );
  });
}

void mockClientResponse(
  CustomerServiceClient mockClient,
  ResponseFuture<CheckResponse> Function(Invocation) mockCallback,
) {
  when(() => mockClient.check(any())).thenAnswer(mockCallback);
}
