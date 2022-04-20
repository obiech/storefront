import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ContactSupportButton extends StatelessWidget {
  const ContactSupportButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DropezyButton(
      label: context.res.strings.support,
      onPressed: onPressed,
      textStyle: context.res.styles.caption1.copyWith(
        color: context.res.colors.blue,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: context.res.colors.lightBlue,
    );
  }
}
