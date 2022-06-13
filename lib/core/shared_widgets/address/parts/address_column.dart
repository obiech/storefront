part of '../delivery_address_detail.dart';

/// A [Column] containing all address components:
///
/// - Address title
/// - Recipient Name and Phone Number
/// - Delivery Address
/// - Notes (if there's any)
class AddressColumn extends StatelessWidget {
  const AddressColumn({
    Key? key,
    required this.address,
  }) : super(key: key);

  final DeliveryAddressModel address;

  @override
  Widget build(BuildContext context) {
    final formattedAddress = address.details?.toPrettyAddress ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text for address title
        Text(
          address.title,
          style: context.res.styles.caption2
              .copyWith(fontWeight: FontWeight.w600)
              .withLineHeight(16),
        ),
        SizedBox(height: context.res.dimens.spacingSmall),

        // Text for recipient name and phone number
        Text(
          '${address.recipientName} | ${address.recipientPhoneNumber}',
          style: context.res.styles.caption2
              .copyWith(fontWeight: FontWeight.w400)
              .withLineHeight(20),
        ),

        // Text for delivery address
        Text(
          formattedAddress,
          style: context.res.styles.caption2
              .copyWith(fontWeight: FontWeight.w400)
              .withLineHeight(20),
        ),
      ],
    );
  }
}
