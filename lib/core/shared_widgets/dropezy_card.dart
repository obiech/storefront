import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// [Card] with customized box shadow
///
class DropezyCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  const DropezyCard({
    Key? key,
    required this.child,
    this.color,
    this.borderRadius,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          margin ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: color ?? context.res.colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        boxShadow: [
          /// box-shadow: 0px 1px 8px 0px #ACBACF80;
          BoxShadow(
            color: const Color(0xFFACBACF).withOpacity(0.5),
            blurRadius: 8.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
