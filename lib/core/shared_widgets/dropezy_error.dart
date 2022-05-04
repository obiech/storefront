import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// Display error/status page
///
/// e.g no network or no inventory results
class DropezyError extends StatelessWidget {
  /// Error title
  final String title;

  /// Error message
  final String message;

  const DropezyError({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: res.dimens.spacingLarge,
        horizontal: res.dimens.spacingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              height: 33 / 28,
              color: res.colors.grey4,
            ),
          ),
          SizedBox(
            height: res.dimens.spacingLarge,
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              height: 17 / 14,
              color: res.colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
