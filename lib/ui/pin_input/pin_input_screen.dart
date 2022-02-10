import 'package:flutter/material.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';

class PinInputScreen extends StatelessWidget {
  static const routeName = 'pin-input';

  const PinInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'PIN',
      child: const Center(child: Text('PIN Placeholder')),
    );
  }
}
