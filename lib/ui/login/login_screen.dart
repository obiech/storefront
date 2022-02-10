import 'package:flutter/material.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = 'login';

  const LoginScreen({Key? key}) : super(key: key);

  //TODO: Implement LoginScreen
  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      child: const Text('Login placeholder'),
      title: 'Login',
    );
  }
}
