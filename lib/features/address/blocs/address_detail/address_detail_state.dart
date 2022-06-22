part of 'address_detail_bloc.dart';

class AddressDetailState extends Equatable {
  final String addressName;

  // Id address
  final String? id;

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

  /// Indicating case to handle
  final bool isEditMode;

  const AddressDetailState({
    this.id,
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
    this.isEditMode = false,
  });

  AddressDetailState copyWith({
    String? id,
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
    bool? isEditMode,
  }) {
    return AddressDetailState(
      id: id ?? this.id,
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
      isEditMode: isEditMode ?? this.isEditMode,
    );
  }

  @override
  List<Object?> get props => [
        id,
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
        isEditMode,
      ];
}
