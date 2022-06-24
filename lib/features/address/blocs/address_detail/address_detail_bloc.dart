import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

part 'address_detail_event.dart';
part 'address_detail_state.dart';

/// handles address detail form submission
/// however, form validation is handled in UI side
@injectable
class AddressDetailBloc extends Bloc<AddressDetailEvent, AddressDetailState> {
  final IDeliveryAddressRepository _repository;
  final DateTimeProvider _dateTimeProvider;

  AddressDetailBloc({
    required IDeliveryAddressRepository repository,
    required DateTimeProvider dateTimeProvider,
  })  : _repository = repository,
        _dateTimeProvider = dateTimeProvider,
        super(const AddressDetailState()) {
    on<LoadPlaceDetail>((event, emit) async {
      final placeDetails = event.placeDetailsModel;
      if (placeDetails != null) {
        emit(
          state.copyWith(
            latLng: LatLng(placeDetails.lat, placeDetails.lng),
            addressDetailsName: placeDetails.name,
            addressDetails: placeDetails.addressDetails.toPrettyAddress,
          ),
        );
      }
    });
    on<LoadDeliveryAddress>((event, emit) async {
      final deliveryAddress = event.deliveryAddressModel;

      emit(
        state.copyWith(
          isEditMode: true,
          id: deliveryAddress.id,
          addressName: deliveryAddress.title,
          addressDetailsNote: deliveryAddress.notes,
          recipientName: deliveryAddress.recipientName,
          recipientPhoneNumber: deliveryAddress.recipientPhoneNumber,
          isPrimaryAddress: deliveryAddress.isPrimaryAddress,
        ),
      );

      emit(
        state.copyWith(
          latLng: LatLng(deliveryAddress.lat, deliveryAddress.lng),
          addressDetailsName: deliveryAddress.details?.name,
          addressDetails: deliveryAddress.details?.toPrettyAddress,
        ),
      );
    });
    on<AddressNameChanged>((event, emit) {
      emit(state.copyWith(addressName: event.addressName));
    });
    on<MapIsReady>((event, emit) {
      emit(
        state.copyWith(
          isMapReady: true,
          updateLatLng: true,
        ),
      );
    });
    on<AddressDetailNoteChanged>((event, emit) {
      emit(state.copyWith(addressDetailsNote: event.addressDetailNote));
    });
    on<RecipientNameChanged>((event, emit) {
      emit(state.copyWith(recipientName: event.recipientName));
    });
    on<RecipientPhoneChanged>((event, emit) {
      emit(state.copyWith(recipientPhoneNumber: event.phoneNumber));
    });
    on<PrimaryAddressChanged>((event, emit) {
      emit(state.copyWith(isPrimaryAddress: event.isPrimaryAddress));
    });
    on<FormSubmitted>(
      (event, emit) => _onFormSubmitted(emit),
    );
  }

  Future<void> _onFormSubmitted(
    Emitter<AddressDetailState> emit,
  ) async {
    // TODO (widy): Fix model passed to repository
    final deliveryAddress = DeliveryAddressModel(
      id: state.id,
      title: state.addressName,
      isPrimaryAddress: state.isPrimaryAddress,
      lat: state.latLng.latitude,
      lng: state.latLng.longitude,
      notes: state.addressDetailsNote,
      recipientName: state.recipientName,
      recipientPhoneNumber: state.recipientPhoneNumber,
      dateCreated: _dateTimeProvider.now,
      // TODO (widy): fix with proper structure conversion
      details: AddressDetailsModel(
        street: state.addressDetails,
      ),
    );

    emit(state.copyWith(loading: true));

    final result = state.isEditMode
        ? await _repository.updateAddress(deliveryAddress)
        : await _repository.saveAddress(deliveryAddress);

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          loading: false,
        ),
      ),
      (success) => emit(
        state.copyWith(
          loading: false,
          addressUpdated: true,
        ),
      ),
    );
  }
}
