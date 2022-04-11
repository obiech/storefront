import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

import '../../domain/services/user_credentials_storage.dart';
import 'pin_registration_state.dart';

/// Handles PIN registration which associates the user's current device with
/// the submitted PIN.
///
/// Device information includes:
/// - device name obtained with [deviceNameProvider].
/// - device fingerprint obtained with [deviceFingerprintProvider].
///
/// Request is sent to storefront backend using
/// [customerServiceClient] and authentication token is obtained from
/// [userCredentialsStorage].
@injectable
class PinRegistrationCubit extends Cubit<PinRegistrationState> {
  PinRegistrationCubit({
    required this.customerServiceClient,
    required this.deviceFingerprintProvider,
    required this.deviceNameProvider,
    required this.userCredentialsStorage,
  }) : super(const PinRegistrationState());

  final CustomerServiceClient customerServiceClient;
  final DeviceFingerprintProvider deviceFingerprintProvider;
  final DeviceNameProvider deviceNameProvider;
  final UserCredentialsStorage userCredentialsStorage;

  /// Registers [pin] for user's current device. Device information
  /// is retrieved with [deviceFingerprintProvider] and [deviceNameProvider].
  ///
  /// Calling this method emits a [PinRegistrationState] with status of
  /// [PinRegistrationStatus.loading].
  ///
  /// On a successful request, will emit a [PinRegistrationState] with status of
  /// [PinRegistrationStatus.success]. If there are any errors, will emit status
  /// [PinRegistrationStatus.error].
  Future<void> registerPin(String pin) async {
    emit(const PinRegistrationState(status: PinRegistrationStatus.loading));

    final fingerprint = await deviceFingerprintProvider.getFingerprint();
    final deviceName = await deviceNameProvider.getDeviceName();
    final credentials = await userCredentialsStorage.getCredentials();

    // In theory, this should never happen as user should already be logged in
    if (credentials == null) {
      emit(
        const PinRegistrationState(
          status: PinRegistrationStatus.error,
          errMsg: 'Anda belum melakukan login',
        ),
      );

      return;
    }

    final device = Device(
      name: deviceName,
      pin: pin,
      fingerprint: fingerprint,
    );

    final request = RegisterDeviceRequest(device: device);

    try {
      await customerServiceClient.registerDevice(request);

      emit(const PinRegistrationState(status: PinRegistrationStatus.success));
    } on GrpcError catch (e) {
      emit(
        PinRegistrationState(
          status: PinRegistrationStatus.error,
          errMsg: '${e.code}, ${e.message}',
        ),
      );
    } catch (e) {
      emit(
        PinRegistrationState(
          status: PinRegistrationStatus.error,
          errMsg: e.toString(),
        ),
      );
    }
  }
}
