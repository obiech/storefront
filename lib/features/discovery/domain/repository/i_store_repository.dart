import 'package:rxdart/rxdart.dart';

import '../../../../core/core.dart';

abstract class IStoreRepository {
  RepoResult<String> getStore();

  // Store stream
  BehaviorSubject<String> get storeStream;
}
