import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core.dart';

part 'keys.dart';

class AuthBottomSheet extends StatelessWidget {
  const AuthBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet.twoButtons(
      image: SvgPicture.asset(
        AssetsPath.imgAuth,
      ),
      content: Text(
        context.res.strings.letsLoginOrRegister,
        style: context.res.styles.subtitle,
        textAlign: TextAlign.center,
      ),
      secondaryButton: DropezyButton.blueTint(
        key: AuthBottomSheetKeys.registerButton,
        label: context.res.strings.register,
        onPressed: () {
          context.router.push(RegistrationRoute());
        },
      ),
      primaryButton: DropezyButton.primary(
        key: AuthBottomSheetKeys.loginButton,
        label: context.res.strings.login,
        onPressed: () {
          context.router.push(LoginRoute());
        },
      ),
    );
  }
}
