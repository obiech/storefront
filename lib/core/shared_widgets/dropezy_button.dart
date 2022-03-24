import 'package:flutter/material.dart';

import '../../core/constants/dropezy_colors.dart';
import '../../core/constants/dropezy_text_styles.dart';

class DropezyButton extends StatelessWidget {
  const DropezyButton({
    Key? key,
    required this.label,
    required this.textStyle,
    required this.backgroundColor,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  factory DropezyButton.primary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return DropezyButton(
      key: key,
      label: label,
      backgroundColor: DropezyColors.blue,
      onPressed: isLoading ? () {} : onPressed,
      textStyle: DropezyTextStyles.button.copyWith(
        color: DropezyColors.white,
      ),
      isLoading: isLoading,
    );
  }

  factory DropezyButton.secondary({
    Key? key,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return DropezyButton(
      key: key,
      label: label,
      backgroundColor: DropezyColors.white,
      onPressed: onPressed,
      textStyle: DropezyTextStyles.button.copyWith(
        color: DropezyColors.blue,
      ),
      isLoading: isLoading,
    );
  }

  final String label;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        shape: const StadiumBorder(),
      ),
      child: !isLoading
          ? Text(
              label,
              style: textStyle,
            )
          : _loadingIndicator(),
    );
  }

  Widget _loadingIndicator() => const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
}
