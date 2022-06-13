part of 'address_detail_bloc.dart';

abstract class AddressDetailEvent extends Equatable {
  const AddressDetailEvent();
}

/// Initial event when [AddressDetailPage] is loaded
class LoadAddressDetail extends AddressDetailEvent {
  final PlaceDetailsModel? placeDetailsModel;

  const LoadAddressDetail({this.placeDetailsModel});

  @override
  List<Object?> get props => [placeDetailsModel];
}

/// Event to change [addressName] and save it to state
class AddressNameChanged extends AddressDetailEvent {
  final String addressName;

  const AddressNameChanged(this.addressName);

  @override
  List<Object?> get props => [addressName];
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
