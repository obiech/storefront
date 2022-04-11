import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyButton.primary(
      label: 'Masuk',
      onPressed: () {
        context.router.push(LoginRoute());
      },
    );
  }
}
