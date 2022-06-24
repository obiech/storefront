import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef CountdownWidgetBuilder = Widget Function(int timeInSeconds);

/// Widget that holds a [Timer] internally and does a countdown with
/// an interval of 1 seconds.
///
/// Use this when you need widgets that display remaining time e.g.
/// remaining delivery time, remaining payment expiry time
class CountdownBuilder extends StatefulWidget {
  const CountdownBuilder({
    Key? key,
    required this.countdownDuration,
    required this.builder,
  }) : super(key: key);

  final int countdownDuration;

  /// [builder] returns the current remaining time (in seconds)
  /// and builds a Widget based on that value
  final CountdownWidgetBuilder builder;

  @override
  State<CountdownBuilder> createState() => CountdownBuilderState();
}

@visibleForTesting
class CountdownBuilderState extends State<CountdownBuilder> {
  late int timeLeftInSeconds;
  late Timer? timer;

  @override
  void initState() {
    super.initState();
    timeLeftInSeconds = math.max(widget.countdownDuration, 0);

    // Rebuild UI every 1 seconds for countdown
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timeLeftInSeconds == 0) {
          timer.cancel();
          this.timer = null;
          return;
        }

        timeLeftInSeconds--;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.builder(timeLeftInSeconds);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
