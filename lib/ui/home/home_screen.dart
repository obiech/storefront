import 'package:flutter/material.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home';

  const HomeScreen({Key? key}) : super(key: key);

  //TODO: Implement HomeScreen
  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      child: const Text('Home placeholder'),
      title: 'Home',
    );
  }
}
