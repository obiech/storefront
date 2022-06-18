import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class LoadingLine extends StatelessWidget {
  final double height;
  final double borderRadius;

  const LoadingLine({
    Key? key,
    this.height = 9,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLine(
      style: SkeletonLineStyle(
        height: height,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
