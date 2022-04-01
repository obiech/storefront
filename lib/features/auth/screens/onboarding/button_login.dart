import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../login/login_screen.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyButton.primary(
      label: 'Masuk',
      onPressed: () {
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      },
    );
  }
}
