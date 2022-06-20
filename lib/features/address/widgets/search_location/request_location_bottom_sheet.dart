import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/core/core.dart';

class RequestLocationBottomSheet extends StatelessWidget {
  const RequestLocationBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet.twoButtons(
      image: SvgPicture.asset(
        context.res.paths.imageLocationAccess,
      ),
      content: Text(
        context.res.strings.locationAccessRationale,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ).withLineHeight(26),
      ),
      primaryButton: DropezyButton.primary(
        label: context.res.strings.activateNow,
        onPressed: () {
          context.popRoute();
          DropezyPermissionHandler.openAppSettings();
        },
      ),
      secondaryButton: DropezyButton.secondary(
        label: context.res.strings.later,
        onPressed: () {
          context.popRoute();
        },
      ),
    );
  }
}
