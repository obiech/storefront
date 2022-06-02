import 'package:flutter/material.dart';

import '../../../../core/core.dart';

part 'keys.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.editProfile,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropezyTextFormField(
                        fieldKey: EditProfilePageKeys.nameField,
                        label: context.res.strings.name(),
                        hintText: context.res.strings.enterYourName(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: context.res.styles.bottomSheetStyle,
              padding: const EdgeInsets.all(8),
              child: DropezyButton.primary(
                key: EditProfilePageKeys.saveProfileButton,
                label: context.res.strings.saveProfile,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
