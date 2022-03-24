import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/network/grpc/customer/customer.pbgrpc.dart';
import 'package:storefront_app/core/services/device/index.dart';
import 'package:storefront_app/features/auth/domain/repository/user_credentials.dart';
import 'package:storefront_app/features/auth/domain/services/user_credentials_storage.dart';
import 'package:storefront_app/features/auth/index.dart';

import '../src/mock_customer_service_client.dart';
import '../src/mock_response_future.dart';

class MockDeviceNameProvider extends Mock implements DeviceNameProvider {}

class MockDeviceFingerprintProvider extends Mock
    implements DeviceFingerprintProvider {}

class MockUserCredentialsStorage extends Mock
    implements UserCredentialsStorage {}

void main() {
  group('PinRegistrationCubit', () {
    late CustomerServiceClient customerServiceClient;
    late DeviceNameProvider deviceNameProvider;
    late DeviceFingerprintProvider deviceFingerprintProvider;
    late UserCredentialsStorage userCredentialsStorage;
    late PinRegistrationCubit pinRegistrationCubit;

    /// Convenience for bootstraping Cubit instance
    PinRegistrationCubit _buildCubit() =>
        pinRegistrationCubit = PinRegistrationCubit(
          customerServiceClient: customerServiceClient,
          deviceFingerprintProvider: deviceFingerprintProvider,
          deviceNameProvider: deviceNameProvider,
          userCredentialsStorage: userCredentialsStorage,
        );

    const fakeFingerprint = 'fingerprint';
    const fakeDeviceName = 'Flutter Test Device';
    const fakePin = '123456';
    const fakeBearerToken = 'abcdef';
    const fakePhoneNumber = '+6281234567890';

    const fakeUserCredentials = UserCredentials(
      authToken: fakeBearerToken,
      phoneNumber: fakePhoneNumber,
    );

    final device = Device(
      name: fakeDeviceName,
      fingerprint: fakeFingerprint,
      pin: fakePin,
    );

    final SavePINResponse dummySavePinResponse =
        SavePINResponse(device: device);

    setUpAll(() {
      registerFallbackValue(SavePINRequest(device: device));
      registerFallbackValue(dummySavePinResponse);
      customerServiceClient = MockCustomerServiceClient();

      deviceFingerprintProvider = MockDeviceFingerprintProvider();
      deviceNameProvider = MockDeviceNameProvider();
      userCredentialsStorage = MockUserCredentialsStorage();

      pinRegistrationCubit = _buildCubit();
    });

    test(
      'initial state status should be [PinRegistrationStatus.initialState] '
      'and other properties should be unassigned',
      () {
        expect(
          pinRegistrationCubit.state,
          const PinRegistrationState(
            status: PinRegistrationStatus.initialState,
          ),
        );
      },
    );

    group('[registerPin()]', () {
      test(
        'should retrieve fingerprint, device name, and user credentials to be '
        'used for SavePIN request',
        () async {
          // Mock all dependencies
          _mockDeviceFingerprint(deviceFingerprintProvider, fakeFingerprint);
          _mockDeviceName(deviceNameProvider, fakeDeviceName);
          _mockUserCredentials(userCredentialsStorage, fakeUserCredentials);

          // Mock SavePIN request
          final expectedRequest = SavePINRequest(
            device: Device(
              fingerprint: fakeFingerprint,
              name: fakeDeviceName,
              pin: fakePin,
            ),
          );

          _mockSavePINRequest(
            customerServiceClient,
            (_) => MockResponseFuture.value(dummySavePinResponse),
          );

          // Initialize cubit and call registerPin
          final cubit = _buildCubit();
          await cubit.registerPin(fakePin);

          // Ensure data is retrieved from dependencies
          verify(() => deviceFingerprintProvider.getFingerprint()).called(1);
          verify(() => deviceNameProvider.getDeviceName()).called(1);
          verify(() => userCredentialsStorage.getCredentials()).called(1);

          // Ensure SavePIN request uses informaton provided above
          verify(
            () => customerServiceClient.savePIN(
              expectedRequest,
              options: any(named: 'options'),
            ),
          ).called(1);
        },
      );

      group('should return a loading State', () {
        blocTest<PinRegistrationCubit, PinRegistrationState>(
          'and a success State if request to backend is successful',
          build: () {
            // Mock all dependencies
            _mockDeviceFingerprint(deviceFingerprintProvider, fakeFingerprint);
            _mockDeviceName(deviceNameProvider, fakeDeviceName);
            _mockUserCredentials(userCredentialsStorage, fakeUserCredentials);

            // Mock SavePIN request
            _mockSavePINRequest(
              customerServiceClient,
              (_) => MockResponseFuture.value(dummySavePinResponse),
            );

            return _buildCubit();
          },
          act: (cubit) => cubit.registerPin(fakePin),
          expect: () => const [
            PinRegistrationState(status: PinRegistrationStatus.loading),
            PinRegistrationState(status: PinRegistrationStatus.success),
          ],
        );

        blocTest<PinRegistrationCubit, PinRegistrationState>(
          'and an error State if user credentials is null',
          build: () {
            // Mock all dependencies
            _mockDeviceFingerprint(deviceFingerprintProvider, fakeFingerprint);
            _mockDeviceName(deviceNameProvider, fakeDeviceName);
            _mockUserCredentials(userCredentialsStorage, null);

            // Mock SavePIN request
            _mockSavePINRequest(
              customerServiceClient,
              (_) => MockResponseFuture.value(dummySavePinResponse),
            );

            return _buildCubit();
          },
          act: (cubit) => cubit.registerPin(fakePin),
          expect: () => const [
            PinRegistrationState(status: PinRegistrationStatus.loading),
            PinRegistrationState(
              status: PinRegistrationStatus.error,
              errMsg: 'Anda belum melakukan login',
            ),
          ],
        );

        blocTest<PinRegistrationCubit, PinRegistrationState>(
          'and an error State if a gRPC error is thrown',
          setUp: () {
            // Mock all dependencies
            _mockDeviceFingerprint(deviceFingerprintProvider, fakeFingerprint);
            _mockDeviceName(deviceNameProvider, fakeDeviceName);
            _mockUserCredentials(userCredentialsStorage, fakeUserCredentials);

            // Mock SavePIN request
            _mockSavePINRequest(
              customerServiceClient,
              (_) => MockResponseFuture<SavePINResponse>.error(
                GrpcError.unknown('Dummy Error'),
              ),
            );
          },
          build: () => PinRegistrationCubit(
            customerServiceClient: customerServiceClient,
            deviceFingerprintProvider: deviceFingerprintProvider,
            deviceNameProvider: deviceNameProvider,
            userCredentialsStorage: userCredentialsStorage,
          ),
          act: (cubit) async => cubit.registerPin(fakePin),
          expect: () => const [
            PinRegistrationState(status: PinRegistrationStatus.loading),
            PinRegistrationState(
              status: PinRegistrationStatus.error,
              errMsg: '${StatusCode.unknown}, Dummy Error',
            ),
          ],
        );

        blocTest<PinRegistrationCubit, PinRegistrationState>(
          'and an error State if runtime exception is thrown',
          setUp: () {
            // Mock all dependencies
            _mockDeviceFingerprint(deviceFingerprintProvider, fakeFingerprint);
            _mockDeviceName(deviceNameProvider, fakeDeviceName);
            _mockUserCredentials(userCredentialsStorage, fakeUserCredentials);

            // Mock SavePIN request
            _mockSavePINRequest(
              customerServiceClient,
              (_) => MockResponseFuture<SavePINResponse>.error(
                Exception('Dummy Error'),
              ),
            );
          },
          build: () => _buildCubit(),
          act: (cubit) async => cubit.registerPin(fakePin),
          expect: () => [
            const PinRegistrationState(status: PinRegistrationStatus.loading),
            PinRegistrationState(
              status: PinRegistrationStatus.error,
              errMsg: Exception('Dummy Error').toString(),
            ),
          ],
        );
      });
    });
  });
}

void _mockDeviceFingerprint(
  DeviceFingerprintProvider provider,
  String fingerprint,
) {
  when(() => provider.getFingerprint()).thenAnswer((_) async => fingerprint);
}

void _mockDeviceName(DeviceNameProvider provider, String name) {
  when(() => provider.getDeviceName()).thenAnswer((_) async => name);
}

/// Pass null for [userCredentials] to simulate unauthenticated state
void _mockUserCredentials(
  UserCredentialsStorage storage,
  UserCredentials? userCredentials,
) {
  when(() => storage.getCredentials()).thenAnswer((_) async => userCredentials);
}

void _mockSavePINRequest(
  CustomerServiceClient mockClient,
  ResponseFuture<SavePINResponse> Function(Invocation) mockCallback,
) {
  when(() => mockClient.savePIN(any(), options: any(named: 'options')))
      .thenAnswer(mockCallback);
}