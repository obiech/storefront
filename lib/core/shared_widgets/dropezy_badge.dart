import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Icon & Badge, works great with cart count display
class DropezyBadge extends StatelessWidget {
  const DropezyBadge({
    Key? key,
    required this.count,
    required this.icon,
  }) : super(key: key);

  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Padding(
          padding: count == 0
              ? EdgeInsets.zero
              : const EdgeInsets.only(top: 7, right: 7),
          child: Icon(
            icon,
            size: 17.7,
          ),
        ),
        if (count != 0)
          Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              backgroundColor: res.colors.red,
              radius: 7,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(count.badgeText),
                ),
              ),
            ),
          )
      ],
    );
  }
}
