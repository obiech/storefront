part of 'address_detail_bloc.dart';

class AddressDetailState extends Equatable {
  final String addressName;
  final String addressDetail;
  final String recipientName;
  final String recipientPhoneNumber;
  final bool isPrimaryAddress;
  final bool loading;
  final String? errorMessage;
  final bool addressUpdated;

  const AddressDetailState({
    this.addressName = '',
    this.addressDetail = '',
    this.recipientName = '',
    this.recipientPhoneNumber = '',
    this.isPrimaryAddress = false,
    this.loading = false,
    this.errorMessage,
    this.addressUpdated = false,
  });

  AddressDetailState copyWith({
    String? addressName,
    String? addressDetail,
    String? recipientName,
    String? recipientPhoneNumber,
    bool? isPrimaryAddress,
    bool? loading,
    String? errorMessage,
    bool? addressUpdated,
  }) {
    return AddressDetailState(
      addressName: addressName ?? this.addressName,
      addressDetail: addressDetail ?? this.addressDetail,
      recipientName: recipientName ?? this.recipientName,
      recipientPhoneNumber: recipientPhoneNumber ?? this.recipientPhoneNumber,
      isPrimaryAddress: isPrimaryAddress ?? this.isPrimaryAddress,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      addressUpdated: addressUpdated ?? this.addressUpdated,
    );
  }

  @override
  List<Object?> get props => [
        addressName,
        addressDetail,
        recipientName,
        recipientPhoneNumber,
        isPrimaryAddress,
        loading,
        errorMessage,
        addressUpdated,
      ];
}
