part of '../widget.dart';

/// Stacked [_Bar.inProgressBar] and [_Bar.activeBar]
class _StackedInProgressBar extends StatelessWidget {
  const _StackedInProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Bar.activeBar(context.res),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: _Bar.barWidth / 2,
            child: _Bar.inProgressBar(context.res),
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    Key? key,
    required this.height,
    required this.width,
    required this.color,
  }) : super(key: key);

  static const barHeight = 3.0;
  static const barWidth = 48.0;

  final double height;
  final double width;
  final Color color;

  factory _Bar.activeBar(Resources res) {
    return _Bar(
      height: barHeight,
      width: barWidth,
      color: res.colors.green,
    );
  }

  factory _Bar.inactiveBar(Resources res) {
    return _Bar(
      height: barHeight,
      width: barWidth,
      color: res.colors.grey3,
    );
  }

  factory _Bar.inProgressBar(Resources res) {
    return _Bar(
      height: barHeight,
      width: barWidth / 2,
      color: res.colors.neonGreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: barWidth,
      height: barHeight,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: color,
      ),
    );
  }
}
