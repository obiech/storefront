part of 'address_detail_bloc.dart';

abstract class AddressDetailEvent extends Equatable {
  const AddressDetailEvent();
}

/// Event to change [addressName] and save it to state
class AddressNameChanged extends AddressDetailEvent {
  final String addressName;

  const AddressNameChanged(this.addressName);

  @override
  List<Object?> get props => [addressName];
}

/// Event to change [addressDetail] and save it to state
class AddressDetailChanged extends AddressDetailEvent {
  final String addressDetail;

  const AddressDetailChanged(this.addressDetail);

  @override
  List<Object?> get props => [addressDetail];
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
