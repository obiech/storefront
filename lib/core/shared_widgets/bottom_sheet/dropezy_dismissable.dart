import 'package:flutter/material.dart';

/// Makes a [DraggableScrollableSheet] dismissable
class DropezyDismissable extends StatelessWidget {
  final Widget child;

  const DropezyDismissable({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: child,
      onTap: () => Navigator.of(context).pop(),
    );
  }
}
