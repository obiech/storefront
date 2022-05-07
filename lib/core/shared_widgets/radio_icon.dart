import 'package:flutter/material.dart';

import '../core.dart';

/// Widget for displaying radio state active and inactive
/// based on boolean input
class RadioIcon extends StatelessWidget {
  const RadioIcon({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Icon(
      active ? DropezyIcons.radio_checked : DropezyIcons.radio,
      color: active ? context.res.colors.blue : context.res.colors.grey3,
    );
  }
}
