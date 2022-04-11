import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// TODO - Refactor to own feature
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyScaffold.textTitle(
      title: 'Profile',
      child: Text(
        'Profile',
        style: res.styles.title,
      ),
    );
  }
}
