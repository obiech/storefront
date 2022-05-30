part of '../address_selection_bottom_sheet.dart';

class AddressListView extends StatelessWidget {
  const AddressListView({
    Key? key,
    required this.addressList,
    required this.activeAddress,
  }) : super(key: key);

  final List<DeliveryAddressModel> addressList;
  final DeliveryAddressModel activeAddress;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: addressList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final address = addressList[index];
        final isActive = activeAddress.id == address.id;
        final formattedAddress = address.details?.toPrettyAddress ?? '';

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: context.res.dimens.pagePadding,
                right: context.res.dimens.pagePadding,
              ),
              child: ListTile(
                onTap: () {
                  if (address != activeAddress) {
                    context
                        .read<DeliveryAddressCubit>()
                        .setActiveAddress(address);
                  }
                },
                contentPadding: EdgeInsets.zero,
                title: Text(address.title),
                subtitle: Text(formattedAddress),
                trailing: RadioIcon(active: isActive),
              ),
            ),
            const Divider(thickness: 1),
          ],
        );
      },
    );
  }
}
