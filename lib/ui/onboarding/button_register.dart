import 'package:flutter/material.dart';
import 'package:storefront_app/ui/registration/registration_screen.dart';
import 'package:storefront_app/ui/widgets/dropezy_button.dart';

class ButtonRegister extends StatelessWidget {
  const ButtonRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyButton.secondary(
      label: 'Daftar',
      onPressed: () {
        Navigator.of(context).pushNamed(RegistrationScreen.routeName);
      },
    );
  }
}
