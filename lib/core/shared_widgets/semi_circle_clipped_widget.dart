import 'package:flutter/material.dart';

/// Widget that applies clipping in the form of semi circles along
/// the bottom of [child].
class SemiCircleClippedWidget extends StatelessWidget {
  const SemiCircleClippedWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _SemiCircleClipper(
        holeRadius: 10,
        rationOfLine: 1.6,
      ),
      child: child,
    );
  }
}

class _SemiCircleClipper extends CustomClipper<Path> {
  _SemiCircleClipper({
    required this.holeRadius,
    required this.rationOfLine,
  });

  final double holeRadius;
  final double rationOfLine;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height);

    for (double d = 0; d < size.width; d += holeRadius * rationOfLine) {
      path.lineTo(size.width - d, size.height);
      path.arcToPoint(
        Offset(size.width - (d + holeRadius), size.height),
        clockwise: false,
        radius: const Radius.circular(1),
      );
    }

    path.lineTo(0.0, size.height);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(_SemiCircleClipper oldClipper) => true;
}
