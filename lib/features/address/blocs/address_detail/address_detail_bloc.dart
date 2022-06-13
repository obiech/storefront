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
    on<LoadAddressDetail>((event, emit) async {
      // FIXME: ugly hacks to delay & wait for map creation
      await Future.delayed(const Duration(milliseconds: 500));

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
    on<AddressNameChanged>((event, emit) {
      emit(state.copyWith(addressName: event.addressName));
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
    on<FormSubmitted>((event, emit) => _onFormSubmitted(emit));
  }

  Future<void> _onFormSubmitted(Emitter<AddressDetailState> emit) async {
    emit(state.copyWith(loading: true));

    final result = await _repository.saveAddress(
      // TODO (widy): Fix model passed to repository
      // Notes:
      // - id can be exist if page opened from edit address
      DeliveryAddressModel(
        id: 'id',
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
      ),
    );

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
