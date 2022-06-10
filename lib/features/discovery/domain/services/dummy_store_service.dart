import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/core.dart';
import '../../../../di/di_environment.dart';
import '../repository/i_store_repository.dart';

@LazySingleton(as: IStoreRepository, env: [DiEnvironment.dummy])
class DummyStoreRepository extends IStoreRepository {
  final BehaviorSubject<String> _storeStream;

  DummyStoreRepository() : _storeStream = BehaviorSubject();

  @override
  RepoResult<String> getStore() async {
    await Future.delayed(const Duration(seconds: 1));
    const storeId = 'store-id-1';
    _storeStream.add(storeId);
    return right(storeId);
  }

  @override
  BehaviorSubject<String> get storeStream => _storeStream;
}
