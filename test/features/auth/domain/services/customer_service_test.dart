import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/index.dart';
import 'package:storefront_app/features/profile/index.dart';

import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group(
    '[CustomerService]',
    () {
      const mockPhoneNumber = '+6281234567890';
      const mockFullName = 'dummyName';
      const mockFingerPrint = 'FingerPrintMock';
      const mockDeviceName = 'MockDeviceName';

      late CustomerServiceClient customerServiceClient;
      late CustomerService customerService;
      late IPrefsRepository sharedPreferences;
      late DeviceFingerprintProvider deviceFingerprintProvider;
      late DeviceNameProvider deviceNameProvider;

      setUp(() {
        customerServiceClient = MockCustomerServiceClient();
        sharedPreferences = MockIPrefsRepository();
        deviceFingerprintProvider = MockDeviceFingerprintProvider();
        deviceNameProvider = MockDeviceNameProvider();

        customerService = CustomerService(
          customerServiceClient,
          sharedPreferences: sharedPreferences,
          deviceFingerprintProvider: deviceFingerprintProvider,
          deviceNameProvider: deviceNameProvider,
        );
      });

      group(
        '[registerPhoneNumber()]',
        () {
          final mockRequest = RegisterRequest(phoneNumber: mockPhoneNumber);
          test(
            'should call [CustomerServiceClient.register] once '
            'and return Unit '
            'when request is successful',
            () async {
              when(
                () => customerServiceClient.register(mockRequest),
              ).thenAnswer(
                (_) => MockResponseFuture.value(RegisterResponse()),
              );

              final result =
                  await customerService.registerPhoneNumber(mockPhoneNumber);

              final unit = result.getRight();
              expect(unit, isA<Unit>());

              verify(() => customerServiceClient.register(mockRequest))
                  .called(1);
            },
          );

          test(
            'should call [CustomerServiceClient.register] once '
            'and return a Failure '
            'when request is not successful',
            () async {
              when(
                () => customerServiceClient
                    .register(RegisterRequest(phoneNumber: mockPhoneNumber)),
              ).thenAnswer(
                (_) => MockResponseFuture.error(GrpcError.internal('Error')),
              );

              final result =
                  await customerService.registerPhoneNumber(mockPhoneNumber);

              final failure = result.getLeft();
              expect(failure, isA<NetworkFailure>());
              expect(failure.message, 'Error');

              verify(() => customerServiceClient.register(mockRequest))
                  .called(1);
            },
          );
        },
      );

      group('[updateFullName()]', () {
        final mockRequest = UpdateProfileRequest(
          profile: Profile(fullName: mockFullName),
        );

        test(
          'should call [CustomerServiceClient.updateProfile] once '
          'and return a String '
          'when request is successful',
          () async {
            when(
              () => customerServiceClient.updateProfile(mockRequest),
            ).thenAnswer(
              (_) => MockResponseFuture.value(UpdateProfileResponse()),
            );

            final result = await customerService.updateFullName(mockFullName);

            final fullName = result.getRight();
            expect(fullName, isA<String>());

            verify(() => customerServiceClient.updateProfile(mockRequest))
                .called(1);
          },
        );

        test(
          'should call [CustomerServiceClient.updateProfile] once '
          'and return a Failure '
          'when request is not successful',
          () async {
            when(
              () => customerServiceClient.updateProfile(mockRequest),
            ).thenAnswer(
              (_) => MockResponseFuture.error(GrpcError.internal('Error')),
            );

            final result = await customerService.updateFullName(mockFullName);

            final failure = result.getLeft();
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, 'Error');

            verify(() => customerServiceClient.updateProfile(mockRequest))
                .called(1);
          },
        );
      });

      group('[getProfile()]', () {
        final mockRequest = GetProfileRequest();

        test(
          'should call [CustomerServiceClient.getProfile] once '
          'and return a ProfileModel '
          'when request is successful',
          () async {
            when(
              () => customerServiceClient.getProfile(mockRequest),
            ).thenAnswer(
              (_) => MockResponseFuture.value(GetProfileResponse()),
            );

            final result = await customerService.getProfile();

            final profile = result.getRight();
            expect(profile, isA<ProfileModel>());

            verify(() => customerServiceClient.getProfile(mockRequest))
                .called(1);
          },
        );

        test(
          'should call [CustomerServiceClient.getProfile] once '
          'and return a Failure '
          'when request is not successful',
          () async {
            when(
              () => customerServiceClient.getProfile(mockRequest),
            ).thenAnswer(
              (_) => MockResponseFuture.error(GrpcError.internal('Error')),
            );

            final result = await customerService.getProfile();

            final failure = result.getLeft();
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, 'Error');

            verify(() => customerServiceClient.getProfile(mockRequest))
                .called(1);
          },
        );
      });
      group(
        '[registerDeviceFingerPrint()]',
        () {
          final mockDevice = Device(
            fingerprint: mockFingerPrint,
            name: mockDeviceName,
            pin: '',
          );

          setUp(() {
            when(
              () => customerServiceClient
                  .registerDevice(RegisterDeviceRequest(device: mockDevice)),
            ).thenAnswer(
              (_) => MockResponseFuture.value(RegisterDeviceResponse()),
            );

            when(
              () => deviceFingerprintProvider.getFingerprint(),
            ).thenAnswer(
              (_) => MockResponseFuture.value(mockFingerPrint),
            );

            when(
              () => deviceNameProvider.getDeviceName(),
            ).thenAnswer(
              (_) => MockResponseFuture.value(mockDeviceName),
            );
          });
          test(
            'should return Unit '
            'and register a new device finger print '
            'when device has not been registered before',
            () async {
              final result = await customerService.registerDeviceFingerPrint();

              final unit = result.getRight();
              expect(unit, isA<Unit>());

              verify(() => deviceFingerprintProvider.getFingerprint())
                  .called(1);
              verify(() => deviceNameProvider.getDeviceName()).called(1);
              verify(
                () => customerServiceClient
                    .registerDevice(RegisterDeviceRequest(device: mockDevice)),
              ).called(1);
            },
          );

          test(
            'should return a Failure '
            'when request is not successful',
            () async {
              when(
                () => customerServiceClient
                    .registerDevice(RegisterDeviceRequest(device: mockDevice)),
              ).thenAnswer(
                (_) => MockResponseFuture.error(Exception('Error')),
              );

              final result = await customerService.registerDeviceFingerPrint();

              final failure = result.getLeft();
              expect(failure, isA<Failure>());

              verify(() => deviceFingerprintProvider.getFingerprint())
                  .called(1);
              verify(() => deviceNameProvider.getDeviceName()).called(1);
              verify(
                () => customerServiceClient
                    .registerDevice(RegisterDeviceRequest(device: mockDevice)),
              ).called(1);
            },
          );
          test(
            'should return a Unit '
            'when device is already registered',
            () async {
              when(
                () => customerServiceClient
                    .registerDevice(RegisterDeviceRequest(device: mockDevice)),
              ).thenAnswer(
                (_) => MockResponseFuture.error(
                  AlreadyExistFailure('Already Exist'),
                ),
              );

              final result = await customerService.registerDeviceFingerPrint();

              final unit = result.getRight();
              expect(unit, isA<Unit>());

              verify(() => deviceFingerprintProvider.getFingerprint())
                  .called(1);
              verify(() => deviceNameProvider.getDeviceName()).called(1);
              verify(
                () => customerServiceClient
                    .registerDevice(RegisterDeviceRequest(device: mockDevice)),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
