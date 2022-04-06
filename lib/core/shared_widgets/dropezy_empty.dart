import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Empty state display
///
/// Incase of empty pages or error pages
/// use this widget to give users a way out
class DropezyEmptyState extends StatelessWidget {
  /// The message to display to a user
  final String message;

  /// Action to carry out if user decides to retry
  final VoidCallback? onRetry;

  /// Retry button will be shown if this is set to true
  final bool showRetry;

  /// The text to be displayed in the retry button
  final String? retryText;
  const DropezyEmptyState({
    Key? key,
    required this.message,
    this.onRetry,
    this.showRetry = false,
    this.retryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        if (showRetry) ...[
          SizedBox(
            height: res.dimens.spacingMiddle,
          ),
          DropezyButton.primary(
            label: retryText ?? res.strings.retry,
            onPressed: onRetry,
            textStyle: res.styles.button.copyWith(fontSize: 15),
          )
        ]
      ],
    );
  }
}
