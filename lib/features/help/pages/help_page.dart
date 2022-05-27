import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:url_launcher/url_launcher.dart';

part 'parts/customer_service_tile.dart';
part 'parts/whatsapp_button.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      bodyAlignment: Alignment.topCenter,
      title: context.res.strings.help,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: const [
            _CustomerServiceTile(),
            ThickDivider(),
          ],
        ),
      ),
    );
  }
}
