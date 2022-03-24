import 'package:flutter/material.dart';

import '../../../../core/shared_widgets/widgets.dart';
import '../registration/registration_screen.dart';

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
