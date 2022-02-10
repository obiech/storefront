import 'package:flutter/material.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';

class RegistrationScreen extends StatelessWidget {
  static const routeName = 'registration';

  const RegistrationScreen({Key? key}) : super(key: key);

  //TODO: Implement RegistrationScreen
  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      child: const Text('Registration placeholder'),
      title: 'Registration',
    );
  }
}
