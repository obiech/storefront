import 'package:flutter/material.dart';

/// Thick grey divider used as a separator
/// in a page with many sections
class ThickDivider extends StatelessWidget {
  const ThickDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Color(0xFFEEF0F2),
      endIndent: 0,
      indent: 0,
      thickness: 8,
    );
  }
}
