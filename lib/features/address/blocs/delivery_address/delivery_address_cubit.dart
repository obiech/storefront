import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/address/index.dart';

part 'delivery_address_state.dart';

/// Handles all delivery addresses owned by user
@injectable
class DeliveryAddressCubit extends Cubit<DeliveryAddressState> {
  DeliveryAddressCubit({
    required this.deliveryAddressRepository,
  }) : super(const DeliveryAddressInitial());

  final IDeliveryAddressRepository deliveryAddressRepository;

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
          return DeliveryAddressLoaded(
            addressList: addressList,
            activeAddress: addressList.first,
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
}
