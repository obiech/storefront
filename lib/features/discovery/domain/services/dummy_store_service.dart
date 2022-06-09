import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../di/di_environment.dart';
import '../repository/i_store_repository.dart';

@LazySingleton(as: IStoreRepository, env: [DiEnvironment.dummy])
class DummyStoreRepository extends IStoreRepository {
  @override
  RepoResult<String> getStore() async {
    await Future.delayed(const Duration(seconds: 1));
    return right('store-id-1');
  }
}
