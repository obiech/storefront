import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../profile/index.dart';
import '../services/firebase_auth_service.dart';

/// Responsible for managing customer profile and authentication.
///
/// For Firebase related actions, see [FirebaseAuthService]
abstract class ICustomerRepository {
  RepoResult<Unit> registerPhoneNumber(String phoneNumber);
  RepoResult<String> updateFullName(String fullName);
  RepoResult<ProfileModel> getProfile();

  // Registers device finger print for new devices.
  RepoResult<Unit> registerDeviceFingerPrint([String pin]);
}
