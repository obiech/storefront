import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

part 'pin_registration_state.dart';

/// Handles PIN registration which associates the user's current device with
/// the submitted PIN.
///
/// Device information includes:
/// - device name obtained with [deviceNameProvider].
/// - device fingerprint obtained with [deviceFingerprintProvider].
///
/// Request is sent to storefront backend using
/// [customerServiceClient] and authentication token is obtained from
/// [authService].
@injectable
class PinRegistrationCubit extends Cubit<PinRegistrationState> {
  // TODO (leovinsen): Depend on Service instead of directly depending on gRPC client
  PinRegistrationCubit({
    required this.customerServiceClient,
    required this.deviceFingerprintProvider,
    required this.deviceNameProvider,
  }) : super(const PinRegistrationInitial());

  final CustomerServiceClient customerServiceClient;
  final DeviceFingerprintProvider deviceFingerprintProvider;
  final DeviceNameProvider deviceNameProvider;

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
    emit(const PinRegistrationLoading());

    final fingerprint = await deviceFingerprintProvider.getFingerprint();
    final deviceName = await deviceNameProvider.getDeviceName();

    final device = Device(
      name: deviceName,
      pin: pin,
      fingerprint: fingerprint,
    );

    final request = RegisterDeviceRequest(device: device);

    try {
      await customerServiceClient.registerDevice(request);

      emit(const PinRegistrationSuccess());
    } on Exception catch (e) {
      final failure = e.toFailure;

      emit(PinRegistrationError(failure.message));
    }
  }
}
