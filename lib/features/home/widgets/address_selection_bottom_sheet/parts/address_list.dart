part of '../address_selection_bottom_sheet.dart';

class AddressList extends StatelessWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
      builder: (context, state) {
        if (state is DeliveryAddressLoaded) {
          return AddressListView(
            addressList: state.addressList,
            activeAddress: state.activeAddress,
          );
        } else if (state is DeliveryAddressLoading) {
          return const AddressSelectionLoading();
        } else if (state is DeliveryAddressError) {
          return AddressSelectionError(message: state.message);
        }
        return const SizedBox();
      },
    );
  }
}
