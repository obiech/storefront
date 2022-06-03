import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class PayNowButton extends StatelessWidget {
  const PayNowButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DropezyButton.primary(
      label: context.res.strings.payNow,
      onPressed: onPressed,
      textStyle: context.res.styles.caption1.copyWith(
        color: context.res.colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
