part of 'delivery_address_cubit.dart';

abstract class DeliveryAddressState extends Equatable {
  const DeliveryAddressState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the cubit
class DeliveryAddressInitial extends DeliveryAddressState {
  const DeliveryAddressInitial();
}

/// Loading addresses from repository
class DeliveryAddressLoading extends DeliveryAddressState {
  const DeliveryAddressLoading();
}

/// Successfully loaded all addresses
class DeliveryAddressLoaded extends DeliveryAddressState {
  const DeliveryAddressLoaded({
    required this.addressList,
    required this.activeAddress,
  });

  /// All delivery addresses
  final List<DeliveryAddressModel> addressList;

  /// Currently active address
  final DeliveryAddressModel activeAddress;

  @override
  List<Object?> get props => [addressList, activeAddress];
}

/// Error occured while loading for addresses
class DeliveryAddressError extends DeliveryAddressState {
  const DeliveryAddressError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
