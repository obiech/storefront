import 'package:flutter/material.dart';
import 'package:storefront_app/ui/login/login_screen.dart';
import 'package:storefront_app/ui/widgets/dropezy_button.dart';

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
