import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.help,
      child: const SizedBox(),
    );
  }
}
