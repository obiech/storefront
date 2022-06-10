import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/core.dart';
import '../../../di/injection.dart';
import '../../auth/domain/services/auth_service.dart';

class ProfileSignOutBottomSheet extends StatelessWidget {
  const ProfileSignOutBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet.twoButtons(
      image: SvgPicture.asset(
        context.res.paths.imageDropezySignOut,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34),
        child: Text(
          context.res.strings.doYouWantToSignOut,
          style: context.res.styles.subtitle
              .copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              )
              .withLineHeight(26),
          textAlign: TextAlign.center,
        ),
      ),
      primaryButton: DropezyButton.primary(
        label: context.res.strings.yesSignOut,
        onPressed: () async {
          getIt<AuthService>().signOut();
          context.router.replaceAll([OnboardingRoute(isUserSignOut: true)]);
        },
      ),
      secondaryButton: DropezyButton(
        label: context.res.strings.cancel,
        textStyle: context.res.styles.caption1
            .copyWith(
              color: context.res.colors.blue,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            )
            .withLineHeight(24),
        backgroundColor: context.res.colors.lightBlue,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
