import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/i_store_repository.dart';

/// Responsible for determining which store
/// should serve a user (Store Discovery).
///
/// Will be expanded when Geofence module is available.
@injectable
class DiscoveryCubit extends Cubit<String?> {
  DiscoveryCubit(this._storeRepository) : super(null);

  final IStoreRepository _storeRepository;

  Future<void> loadStore() async {
    final result = await _storeRepository.getStore();

    result.fold(
      (failure) {
        debugPrint('Failed to load store: ${failure.message}');
        emit(null);
      },
      (storeId) {
        emit(storeId);
      },
    );
  }
}
