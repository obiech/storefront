import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class LoadingParagraph extends StatelessWidget {
  final double height;
  final double borderRadius;

  const LoadingParagraph({
    Key? key,
    this.height = 9,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonParagraph(
      style: SkeletonParagraphStyle(
        lineStyle: SkeletonLineStyle(
          height: height,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
