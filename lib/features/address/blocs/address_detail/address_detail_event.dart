part of 'address_detail_bloc.dart';

abstract class AddressDetailEvent extends Equatable {
  const AddressDetailEvent();
}

/// Initial event when [AddressDetailPage] is loaded
///
/// P.S: Indicating the use of bloc for create address
class LoadPlaceDetail extends AddressDetailEvent {
  final PlaceDetailsModel? placeDetailsModel;

  const LoadPlaceDetail({this.placeDetailsModel});

  @override
  List<Object?> get props => [placeDetailsModel];
}

/// Initial event when [AddressDetailPage] is loaded
///
/// P.S: Indicating the use of bloc for edit address
class LoadDeliveryAddress extends AddressDetailEvent {
  final DeliveryAddressModel deliveryAddressModel;

  const LoadDeliveryAddress({required this.deliveryAddressModel});

  @override
  List<Object?> get props => [deliveryAddressModel];
}

/// Event to change [addressName] and save it to state
class AddressNameChanged extends AddressDetailEvent {
  final String addressName;

  const AddressNameChanged(this.addressName);

  @override
  List<Object?> get props => [addressName];
}

/// Event to indicate that Map View is ready
class MapIsReady extends AddressDetailEvent {
  const MapIsReady();

  @override
  List<Object?> get props => [];
}

/// Event to change [addressDetailNote] and save it to state
class AddressDetailNoteChanged extends AddressDetailEvent {
  final String addressDetailNote;

  const AddressDetailNoteChanged(this.addressDetailNote);

  @override
  List<Object?> get props => [addressDetailNote];
}

/// Event to change [recipientName] and save it to state
class RecipientNameChanged extends AddressDetailEvent {
  final String recipientName;

  const RecipientNameChanged(this.recipientName);

  @override
  List<Object?> get props => [recipientName];
}

/// Event to change recipient [phoneNumber] and save it to state
class RecipientPhoneChanged extends AddressDetailEvent {
  final String phoneNumber;

  const RecipientPhoneChanged(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

/// Event to change [isPrimaryAddress] and save it to state
class PrimaryAddressChanged extends AddressDetailEvent {
  final bool isPrimaryAddress;

  const PrimaryAddressChanged(this.isPrimaryAddress);

  @override
  List<Object?> get props => [isPrimaryAddress];
}

/// Event when Address detail form is submitted
class FormSubmitted extends AddressDetailEvent {
  const FormSubmitted();

  @override
  List<Object?> get props => [];
}
