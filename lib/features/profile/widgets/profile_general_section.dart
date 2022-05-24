import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import 'widgets.dart';

class ProfileGeneralSection extends StatelessWidget {
  const ProfileGeneralSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.res.strings.general,
            style: context.res.styles.title,
          ),
          const SizedBox(height: 8.0),
          ProfileMenuTile.icon(
            icon: DropezyIcons.shield_done,
            title: context.res.strings.privacyPolicy,
            onTap: () {},
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.support,
            title: context.res.strings.help,
            onTap: () {
              context.pushRoute(
                const HelpRoute(),
              );
            },
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.paper,
            title: context.res.strings.termsOfUse,
            onTap: () {},
          ),
          ProfileMenuTile.icon(
            icon: DropezyIcons.help,
            title: context.res.strings.howItWorks,
            onTap: () {},
          ),
          ProfileMenuTile.svgImage(
            assetPath: context.res.paths.imageDropezyLogoBlack,
            title: context.res.strings.aboutUs,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
