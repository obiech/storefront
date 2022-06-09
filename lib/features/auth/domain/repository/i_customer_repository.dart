import 'package:dartz/dartz.dart';
import 'package:storefront_app/core/core.dart';

import '../services/firebase_auth_service.dart';

/// Responsible for managing customer profile and authentication.
///
/// For Firebase related actions, see [FirebaseAuthService]
abstract class ICustomerRepository {
  RepoResult<Unit> registerPhoneNumber(String phoneNumber);
}
