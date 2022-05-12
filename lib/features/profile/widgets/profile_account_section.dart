import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import 'widgets.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.account(),
            style: context.res.styles.title,
          ),
          const SizedBox(height: 8.0),
          ProfileMenuTile.icon(
            icon: DropezyIcons.document,
            title: context.res.strings.myOrders,
            onTap: () {
              context.pushRoute(
                const OrderRouter(
                  children: [OrderHistoryRoute()],
                ),
              );
            },
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.pin_outlined,
            title: context.res.strings.changeAddress,
            onTap: () {},
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.lock,
            title: context.res.strings.changePin,
            onTap: () {},
          ),
          ProfileMenuTile.svgImage(
            assetPath: context.res.paths.icCoin,
            title: context.res.strings.dropezyPoints,
            onTap: () {},
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.voucher_outlined,
            title: context.res.strings.myVoucher,
            onTap: () {},
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.language,
            title: context.res.strings.selectLanguage,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}