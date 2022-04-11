import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

class ButtonRegister extends StatelessWidget {
  const ButtonRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyButton.secondary(
      label: 'Daftar',
      onPressed: () {
        context.router.push(RegistrationRoute());
      },
    );
  }
}
