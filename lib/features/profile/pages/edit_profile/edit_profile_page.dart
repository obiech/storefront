import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Edit Profile',
      child: const Text('Edit Profile Page'),
    );
  }
}
