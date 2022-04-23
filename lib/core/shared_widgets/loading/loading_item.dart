import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class LoadingItem extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;

  const LoadingItem({
    Key? key,
    this.height,
    this.width,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonItem(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.grey,
        ),
      ),
    );
  }
}
