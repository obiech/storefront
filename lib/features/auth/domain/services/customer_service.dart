import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../profile/index.dart';
import '../domain.dart';

/// Responsible for managing customer profile and authentication
/// with storefront-backend with [CustomerServiceClient].
///
/// For Firebase related actions, see [FirebaseAuthService].
@LazySingleton(as: ICustomerRepository)
class CustomerService extends ICustomerRepository {
  CustomerService(
    this._customerServiceClient, {
    required this.sharedPreferences,
    required this.deviceFingerprintProvider,
    required this.deviceNameProvider,
  });

  final IPrefsRepository sharedPreferences;

  final DeviceFingerprintProvider deviceFingerprintProvider;

  final DeviceNameProvider deviceNameProvider;

  final CustomerServiceClient _customerServiceClient;

  /// Register [phoneNumber] with storefront-backend.
  ///
  /// Make sure to call before Firebase OTP verification is attempted,
  /// otherwise backend will fail to create a user profile in Firebase.
  @override
  RepoResult<Unit> registerPhoneNumber(String phoneNumber) async {
    final request = RegisterRequest(phoneNumber: phoneNumber);

    try {
      await _customerServiceClient.register(request);

      return right(unit);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<ProfileModel> getProfile() async {
    final request = GetProfileRequest();

    try {
      final response = await _customerServiceClient.getProfile(request);
      final profile = ProfileModel.fromPb(response.profile);

      return right(profile);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  @override
  RepoResult<String> updateFullName(String fullName) async {
    final request = UpdateProfileRequest(
      profile: Profile(fullName: fullName),
    );

    try {
      final response = await _customerServiceClient.updateProfile(request);
      final profile = response.profile;

      return right(profile.fullName);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }

  /// Device information includes:
  /// - device name obtained with [deviceNameProvider].
  /// - device fingerprint obtained with [deviceFingerprintProvider].
  ///
  /// Request is sent to storefront backend using
  /// [customerServiceClient].
  @override
  RepoResult<Unit> registerDeviceFingerPrint([String? pin = '']) async {
    try {
      final fingerprint = await deviceFingerprintProvider.getFingerprint();
      final deviceName = await deviceNameProvider.getDeviceName();

      final device = Device(
        name: deviceName,
        fingerprint: fingerprint,
        pin: pin,
      );
      final request = RegisterDeviceRequest(device: device);

      await _customerServiceClient.registerDevice(request);
      return const Right(unit);
    } on AlreadyExistFailure catch (_) {
      return const Right(unit);
    } on Exception catch (e) {
      return Left(e.toFailure);
    }
  }
}
