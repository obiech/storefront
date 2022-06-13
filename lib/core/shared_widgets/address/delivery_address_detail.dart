import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../../features/address/index.dart';

part 'parts/address_column.dart';
part 'parts/chevron_button.dart';

/// Widget for delivery address detail
/// that consists of:
///
/// - A heading text and delivery estimation (optional).
/// - A column of address details [AddressColumn].
/// - Notes (if there's any)
class DeliveryAddressDetail extends StatelessWidget {
  const DeliveryAddressDetail({
    Key? key,
    required this.heading,
    required this.address,
    this.padding,
    this.showDeliveryEstimation = false,
    this.enableAddressSelection = false,
  }) : super(key: key);

  final DeliveryAddressModel address;

  /// Text shown at the top
  final String heading;

  final EdgeInsets? padding;

  /// If true, show estimated delivery duration
  /// in the form of a [DropezyChip.deliveryDuration].
  final bool showDeliveryEstimation;

  /// If true, show a IconButton with [DropezyIcons.chevron_right] icon.
  /// On tap, take user to [ChangeAddressPage].
  final bool enableAddressSelection;

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  heading,
                  style: context.res.styles.caption1
                      .copyWith(fontWeight: FontWeight.w600)
                      .withLineHeight(22),
                ),
              ),
              if (showDeliveryEstimation)
                // TODO (leovinsen): use estimation from geofence module
                DropezyChip.deliveryDuration(res: context.res, minutes: 15),
            ],
          ),
          SizedBox(
            height: context.res.dimens.spacingMiddle,
          ),
          Row(
            children: [
              Expanded(
                child: AddressColumn(address: address),
              ),
              if (enableAddressSelection) const ChevronRightButton(),
            ],
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
