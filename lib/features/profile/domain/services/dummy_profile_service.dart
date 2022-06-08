import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../index.dart';

@LazySingleton(as: IProfileRepository)
class DummyProfileService implements IProfileRepository {
  @override
  RepoResult<Unit> saveFullName(String fullName) async {
    try {
      //  Simulate network loading
      await Future.delayed(const Duration(seconds: 1));
      return right(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
