import 'package:rxdart/rxdart.dart';

import '../../../../core/core.dart';

abstract class IStoreRepository {
  RepoResult<String> getStore();

  /// The stream of a store that is serving the customer.
  ///
  /// When user changes their delivery address and hence
  /// their geofence location, there's a chance
  /// the storeId will be changed.
  ///
  /// When storeId changes, the user's cart, search will be reset.
  BehaviorSubject<String> get storeStream;

  /// Currently active store id
  String? get activeStoreId => storeStream.valueOrNull;
}
