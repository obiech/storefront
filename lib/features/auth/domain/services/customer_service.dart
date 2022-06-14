import 'package:dartz/dartz.dart';
import 'package:dropezy_proto/v1/customer/customer.pbgrpc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';

import '../domain.dart';

/// Responsible for managing customer profile and authentication
/// with storefront-backend with [CustomerServiceClient].
///
/// For Firebase related actions, see [FirebaseAuthService].
@LazySingleton(as: ICustomerRepository)
class CustomerService extends ICustomerRepository {
  CustomerService(this._customerServiceClient);

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
  RepoResult<Unit> updateFullName(String fullName) async {
    final request = UpdateProfileRequest(
      profile: Profile(fullName: fullName),
    );

    try {
      await _customerServiceClient.updateProfile(request);

      return right(unit);
    } on Exception catch (e) {
      return left(e.toFailure);
    }
  }
}
