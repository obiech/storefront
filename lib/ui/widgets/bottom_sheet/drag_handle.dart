import 'package:flutter/material.dart';
import 'package:storefront_app/constants/dropezy_colors.dart';

/// [Widget] for [BottomSheet] to indicate it can be dismissed by dragging
class DragHandle extends StatelessWidget {
  const DragHandle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0,
      height: 4.0,
      decoration: const ShapeDecoration(
        color: DropezyColors.grey2,
        shape: StadiumBorder(),
      ),
    );
  }
}
