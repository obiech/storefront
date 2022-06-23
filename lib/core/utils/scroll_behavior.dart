import 'package:flutter/material.dart';

/// Override default [GlowingOverscrollIndicator] which gives
/// the overflow glow when scrolling beyond bounds
///
/// https://stackoverflow.com/questions/51119795/how-to-remove-scroll-glow
class DropezyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
