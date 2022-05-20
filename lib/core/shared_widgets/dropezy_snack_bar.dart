import 'package:flutter/material.dart';

/// [SnackBar] with preset duration
class DropezySnackBar {
  DropezySnackBar._();

  static SnackBar info(String content, {Duration? duration}) {
    return SnackBar(
      content: Text(content),
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
