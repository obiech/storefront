import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../features/address/index.dart';

/// Widget for delivery address detail
/// that consist of:
///
/// - Address title
/// - Recipient Name and Phone Number
/// - Delivery Address
/// - Notes (if there's any)
class DeliveryAddressDetail extends StatelessWidget {
  const DeliveryAddressDetail({
    Key? key,
    required this.address,
    this.padding,
  }) : super(key: key);

  final DeliveryAddressModel address;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final formattedAddress = address.details?.toPrettyAddress ?? '';
    return Container(
      padding: padding ??
          EdgeInsets.fromLTRB(
            context.res.dimens.pagePadding,
            12,
            context.res.dimens.pagePadding,
            context.res.dimens.pagePadding,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.deliveryLocation,
            style: context.res.styles.caption1
                .copyWith(fontWeight: FontWeight.w600)
                .withLineHeight(22),
          ),
          SizedBox(
            height: context.res.dimens.spacingMiddle,
          ),

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
          SizedBox(height: context.res.dimens.spacingMiddle),

          Visibility(
            visible: address.notes != null,
            child: Row(
              children: [
                Icon(
                  DropezyIcons.note,
                  color: context.res.colors.grey4,
                ),
                SizedBox(width: context.res.dimens.spacingMiddle),
                Text(
                  address.notes ?? '',
                  style: context.res.styles.caption2
                      .copyWith(fontWeight: FontWeight.w500)
                      .withLineHeight(16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
