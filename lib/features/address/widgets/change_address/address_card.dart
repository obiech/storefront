import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/domain/domains.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    Key? key,
    required this.address,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  final DeliveryAddressModel address;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DropezyCard(
        color:
            isActive ? context.res.colors.lightBlue : context.res.colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    address.title,
                    style: context.res.styles.subtitle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Visibility(
                    visible: address.isPrimaryAddress,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      child: DropezyChip.primary(
                        label: context.res.strings.addressPrimary,
                        res: context.res,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: context.res.colors.grey7,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ).withLineHeight(16),
                    ),
                    onPressed: () {
                      context.router.push(
                        AddressDetailRoute(deliveryAddress: address),
                      );
                    },
                    child: Row(
                      children: [
                        const Icon(
                          DropezyIcons.edit,
                          size: 20,
                        ),
                        Text(context.res.strings.update),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address.recipientName} | ${address.recipientPhoneNumber}',
                          style: context.res.styles.subtitle
                              .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              )
                              .withLineHeight(20),
                        ),
                        Text(
                          address.details?.toPrettyAddress ?? '',
                          style: context.res.styles.subtitle
                              .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )
                              .withLineHeight(20),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RadioIcon(active: isActive),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
