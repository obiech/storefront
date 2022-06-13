part of 'address_detail_bloc.dart';

class AddressDetailState extends Equatable {
  final String addressName;

  // The address name that comes from places API and shown below map view
  final String addressDetailsName;

  /// The address detail that comes from Places API and shown below map view
  final String addressDetails;

  /// Address detail on form
  final String addressDetailsNote;
  final String recipientName;
  final String recipientPhoneNumber;
  final bool isPrimaryAddress;
  final bool loading;
  final String? errorMessage;
  final bool addressUpdated;
  final LatLng latLng;

  const AddressDetailState({
    this.addressName = '',
    this.addressDetailsName = '',
    this.addressDetails = '',
    this.addressDetailsNote = '',
    this.recipientName = '',
    this.recipientPhoneNumber = '',
    this.isPrimaryAddress = false,
    this.loading = false,
    this.errorMessage,
    this.addressUpdated = false,
    this.latLng = const LatLng(0, 0),
  });

  AddressDetailState copyWith({
    String? addressName,
    String? addressDetailsName,
    String? addressDetails,
    String? addressDetailsNote,
    String? recipientName,
    String? recipientPhoneNumber,
    bool? isPrimaryAddress,
    bool? loading,
    String? errorMessage,
    bool? addressUpdated,
    LatLng? latLng,
  }) {
    return AddressDetailState(
      addressName: addressName ?? this.addressName,
      addressDetailsName: addressDetailsName ?? this.addressDetailsName,
      addressDetails: addressDetails ?? this.addressDetails,
      addressDetailsNote: addressDetailsNote ?? this.addressDetailsNote,
      recipientName: recipientName ?? this.recipientName,
      recipientPhoneNumber: recipientPhoneNumber ?? this.recipientPhoneNumber,
      isPrimaryAddress: isPrimaryAddress ?? this.isPrimaryAddress,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      addressUpdated: addressUpdated ?? this.addressUpdated,
      latLng: latLng ?? this.latLng,
    );
  }

  @override
  List<Object?> get props => [
        addressName,
        addressDetailsName,
        addressDetails,
        addressDetailsNote,
        recipientName,
        recipientPhoneNumber,
        isPrimaryAddress,
        loading,
        errorMessage,
        addressUpdated,
        latLng,
      ];
}
