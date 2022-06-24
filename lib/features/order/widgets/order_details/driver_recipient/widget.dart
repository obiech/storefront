import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/models/order_model.dart';

part 'keys.dart';
part 'parts/person_info_widget.dart';

/// Contains information of
/// - the driver
/// - the recipient (for completed orders)
class DriverAndRecipientSection extends StatelessWidget {
  const DriverAndRecipientSection({
    Key? key,
    required this.driverModel,
    this.recipientModel,
    required this.status,
  }) : super(key: key);

  final OrderDriverModel? driverModel;

  final OrderRecipientModel? recipientModel;

  final OrderStatus status;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.res.strings.deliveredBy,
            style: context.res.styles.caption1.copyWith(
              fontWeight: FontWeight.w500,
              height: 22 / 14,
            ),
          ),
          SizedBox(height: context.res.dimens.spacingMedium),
          if (driverModel != null)
            _PersonInfoWidget(
              key: const ValueKey(
                DriverAndRecipientSectionKeys.driverInformation,
              ),
              imageUrl: driverModel!.imageUrl,
              personName: driverModel!.fullName,
              additionalDescription: driverModel!.vehicleLicenseNumber,
              trailing: _ContactDriverButton(
                onPressed: () => _contactDriverOnWhatsapp(context),
              ),
            ),
          if (recipientModel != null && status == OrderStatus.arrived) ...[
            Divider(
              // margin of 12 dp on both vertical sides
              height: context.res.dimens.spacingMiddle * 2,
              color: context.res.colors.dividerColor,
            ),
            Text(
              context.res.strings.receivedBy,
              style: context.res.styles.caption1.copyWith(
                fontWeight: FontWeight.w500,
                height: 22 / 14,
              ),
            ),
            SizedBox(height: context.res.dimens.spacingMedium),
            _PersonInfoWidget(
              key: const ValueKey(
                DriverAndRecipientSectionKeys.recipientInformation,
              ),
              imageUrl: recipientModel!.imageUrl,
              personName: recipientModel!.fullName,
              additionalDescription: recipientModel!.relationToCustomer,
            ),
          ]
        ],
      ),
    );
  }

  Future<void> _contactDriverOnWhatsapp(BuildContext context) async {
    final whatsappDeeplink = context.res.links.whatsappDeeplink(
      driverModel!.whatsappNumber,
    );

    if (await canLaunch(whatsappDeeplink)) {
      launch(whatsappDeeplink);
    }
  }
}

/// Button that says 'Contact' (contact driver)
class _ContactDriverButton extends StatelessWidget {
  const _ContactDriverButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const ValueKey(
        DriverAndRecipientSectionKeys.contactDriverButton,
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // forces button to not have a default size, thus using Padding
        // and child elements to determine its size
        minimumSize: Size.zero,
        primary: context.res.colors.lightBlue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 16.0,
        ),
        shape: const StadiumBorder(),
      ),
      child: Row(
        children: [
          Icon(
            DropezyIcons.whatsapp,
            size: 16,
            color: context.res.colors.blue,
          ),
          const SizedBox(width: 6),
          Text(
            context.res.strings.contact,
            style: context.res.styles.caption2.copyWith(
              color: context.res.colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
