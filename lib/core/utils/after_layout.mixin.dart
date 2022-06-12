import 'dart:async';

import 'package:flutter/widgets.dart';

/// Taken from https://github.com/fluttercommunity/flutter_after_layout
///
/// The library is copied instead of added in pubspec.yaml because
/// the latest versions (1.1.1 and 2.0.0) requires Dart SDK 2.17 and our app
/// is still on Dark SDK 2.16.
///
/// And most importantly, in the latest versions there's an addition
/// to check for mounted property which is missing from v1.1.0.
mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.endOfFrame.then(
      (_) {
        if (mounted) afterFirstLayout(context);
      },
    );
  }

  FutureOr<void> afterFirstLayout(BuildContext context);
}
