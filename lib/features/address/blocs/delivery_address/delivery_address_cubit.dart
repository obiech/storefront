import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/services/geofence/repository/i_geofence_local_persistence.dart';
import 'package:storefront_app/features/address/index.dart';

import '../../../../core/services/geofence/models/dropezy_polygon.dart';
import '../../../../core/services/geofence/repository/i_geofence_repository.dart';

part 'delivery_address_state.dart';

/// Handles all delivery addresses owned by user
@injectable
class DeliveryAddressCubit extends Cubit<DeliveryAddressState> {
  DeliveryAddressCubit({
    required this.deliveryAddressRepository,
    required this.geofenceLocalPersistence,
    required this.geofenceRepository,
  }) : super(const DeliveryAddressInitial()) {
   onSubscriptionRequested();
  }

  final IDeliveryAddressRepository deliveryAddressRepository;
  final IGeofenceRepository geofenceRepository;
  late final StreamSubscription _subcription;
  final IGeofenceLocalPersistence geofenceLocalPersistence;
  Set<DropezyPolygon> _polygons = {};

  @visibleForTesting
  Set<DropezyPolygon> get geofencePolygonsGetter => _polygons;

  Future<void> fetchDeliveryAddresses() async {
    emit(const DeliveryAddressLoading());

    final result = await deliveryAddressRepository.getDeliveryAddresses();

    final newState = result.fold(
      (failure) => DeliveryAddressError(failure.message),
      (addressList) {
        if (addressList.isEmpty) {
          return const DeliveryAddressLoadedEmpty();
        } else {
          addressList.sortDate();
          final scannedAddress = addressList.checkCoverageArea(
            geofencePolygonsGetter,
            geofenceRepository.scanMultiplePolygon,
          );
          return DeliveryAddressLoaded(
            addressList: scannedAddress,
            activeAddress: scannedAddress.first,
          );
        }
      },
    );

    emit(newState);
  }

  void setActiveAddress(
    DeliveryAddressModel activeAddress,
  ) {
    if (state is! DeliveryAddressLoaded) return;
    emit(
      DeliveryAddressLoaded(
        activeAddress: activeAddress,
        addressList: (state as DeliveryAddressLoaded).addressList,
      ),
    );
  }

  @protected
  @visibleForTesting
  Future<void> onSubscriptionRequested() async {
    await geofenceRepository.getUpdatedGeofences();
    _subcription = geofenceLocalPersistence.polygons.listen(
      (polys) {
        _polygons = polys;

        if (state is DeliveryAddressLoaded) {
          final currentState = state as DeliveryAddressLoaded;
          final _scannedAddresses = currentState.addressList.checkCoverageArea(
            polys,
            geofenceRepository.scanMultiplePolygon,
          );

          emit(
            DeliveryAddressLoaded(
              activeAddress: currentState.activeAddress,
              addressList: _scannedAddresses,
            ),
          );
        }
      },
      onError: (error) => emit(DeliveryAddressError(error.toString())),
    );
  }

  @override
  Future<void> close() async {
    _subcription.cancel();
    super.close();
  }
}
