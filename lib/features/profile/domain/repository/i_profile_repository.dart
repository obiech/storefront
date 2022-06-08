import 'package:dartz/dartz.dart';
import 'package:storefront_app/core/core.dart';

abstract class IProfileRepository {
  /// Save user fullname to remote
  RepoResult<Unit> saveFullName(String fullName);
}
